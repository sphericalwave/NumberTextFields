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
    var decimal: Decimal
    private let formatter: NumberFormatter
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: CurrencyUITextField.self))
    
    init(decimal: Decimal, formatter: NumberFormatter) {
        Self.logger.trace("init \(decimal)")
        self.formatter = formatter
        self.decimal = decimal
        super.init(frame: .zero)
        self.font =  UIFont.systemFont(ofSize: 17, weight: .regular) //TODO: match font
        self.keyboardType = .numberPad
        self.textAlignment = .right
        self.borderStyle = .roundedRect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        Self.logger.trace("willMove toSuperView")
        super.willMove(toSuperview: superview)
        self.text = formatter.string(for: decimal)
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
