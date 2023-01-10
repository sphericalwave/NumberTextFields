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
    @Binding private var value: Int
    private let formatter: NumberFormatterProtocol
    
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: CurrencyUITextField.self))
    
    init(formatter: NumberFormatterProtocol, value: Binding<Int>) {
        Self.logger.trace("init \(value.wrappedValue)")
        self.formatter = formatter
        self._value = value
        super.init(frame: .zero)
        self.delegate = self
        self.font = .systemFont(ofSize: 40, weight: .regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        Self.logger.trace("willMove toSuperView")
        
        super.willMove(toSuperview: superview)
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        keyboardType = .numberPad
        textAlignment = .right
        sendActions(for: .editingChanged)
    }
    
    override func deleteBackward() {
        Self.logger.trace("deleteBackward")
        text = textValue.digits.dropLast().string
        sendActions(for: .editingChanged)
    }
    
    @objc private func editingChanged() {
        Self.logger.trace("editingChanged")
        text = currency(from: decimal)
        //resetSelection()
        updateValue()
    }
    
    private func updateValue() {
        DispatchQueue.main.async { [weak self] in
            Self.logger.trace("updateValue \(self?.intValue ?? 0)")
            self?.value = self?.intValue ?? 0
        }
    }
    
    private var textValue: String {
        Self.logger.trace("textValue \(self.text ?? "")")
        return text ?? ""
    }
    
    private var decimal: Decimal {
        Self.logger.trace("decimal \(self.textValue.decimal) / \(pow(10, self.formatter.maximumFractionDigits)) = \(self.textValue.decimal / pow(10, self.formatter.maximumFractionDigits))")
        return textValue.decimal / pow(10, formatter.maximumFractionDigits)
    }
    
    private var intValue: Int {
        Self.logger.trace("intValue \(NSDecimalNumber(decimal: self.decimal * 100).intValue)")
        return NSDecimalNumber(decimal: decimal * 100).intValue
    }
    
    private func currency(from decimal: Decimal) -> String {
        Self.logger.trace("currency(from decimal) \(self.formatter.string(for: decimal) ?? "")")
        return formatter.string(for: decimal) ?? ""
    }
    
    //prevent user from moving the cursor
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        return self.endOfDocument
    }
    
    //prevent user from moving cursor with copy paster ui
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
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
        text = currency(from: decimal)
        //resetSelection()
        updateValue()
        return true
    }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    var digits: Self { filter (\.isWholeNumber) }
}

extension String {
    var decimal: Decimal { Decimal(string: digits) ?? 0 }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}
