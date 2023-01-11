//
//  CurrencyUITextField.swift
//  NumberSample
//
//  Created by Benoit Pasquier on 10/2/22.
//

import Foundation
import UIKit
import SwiftUI
import os

class CurrencyUITextField: UITextField {
    @Binding var decimal: Decimal
    private let formatter: NumberFormatter
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: CurrencyUITextField.self))
    
    init(decimal: Binding<Decimal>) {
        Self.logger.trace("init \(decimal.wrappedValue)")
        
        let nmbrFrmt = NumberFormatter()
        nmbrFrmt.numberStyle = .currency
        nmbrFrmt.maximumFractionDigits = 2
        
        self.formatter = nmbrFrmt
        self._decimal = decimal
        super.init(frame: .zero)
        
        self.text = formatter.string(for: decimal)
        self.delegate = self
        self.font = .systemFont(ofSize: 40, weight: .regular)
        self.keyboardType = .numberPad
        self.textAlignment = .right
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        Self.logger.trace("willMove toSuperView")
        super.willMove(toSuperview: superview)
        self.text = formatter.string(for: decimal)
    }
    
    override func deleteBackward() {
        Self.logger.trace("deleteBackward")
        if let text = text {
            let removeFrmt = text.digits
            let removeLeastChar = String(removeFrmt.dropLast())
            let decimal = removeLeastChar.decimal / pow(10, formatter.maximumFractionDigits)
            self.decimal = decimal
            self.text = formatter.string(for: decimal)
        }
        else {
            //i don't think you'll ever hit this code
            self.decimal = 0
            text = formatter.string(for: decimal)
        }
    }
    
    //prevent user from moving the cursor
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        return self.endOfDocument
    }
    
    //prevent user from moving cursor with copy paster ui
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        //editingChanged()
        return !isFirstResponder
    }
}

extension CurrencyUITextField: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        Self.logger.trace("textFieldShouldBeginEditing text: \(textField.text ?? "empty")")
        //start the editing cursor in all the way to the right
        textField.selectedTextRange = textRange(from: endOfDocument, to: endOfDocument)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        Self.logger.trace("shouldChangeCharactersIn")
        
        guard string != "" else {
            return true
        }
        
        if let text = textField.text {
            let removeFrmt = text.digits
            let appendChar = removeFrmt.appending(string)
            let decimal = appendChar.decimal / pow(10, formatter.maximumFractionDigits)
            self.decimal = decimal
            self.text = formatter.string(for: decimal)
        }
        else {
            fatalError()
        }
        return false //prevent conventional replacement bcs handling textfield update above
    }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    var digits: Self {
        //print("StringProtocol digits")
        return filter (\.isWholeNumber)
    }
}

extension String {
    var decimal: Decimal {
        //print("String decimal")
        return Decimal(string: digits) ?? 0
    }
}
