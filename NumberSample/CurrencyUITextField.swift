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
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        Self.logger.trace("willMove toSuperView")
        
        super.willMove(toSuperview: superview)
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        addTarget(self, action: #selector(resetSelection), for: .allTouchEvents)
        keyboardType = .numberPad
        textAlignment = .right
        sendActions(for: .editingChanged)
    }
    
    override func removeFromSuperview() {
        Self.logger.trace("removeFromSuperview")
        
        print(#function)
    }
    
    override func deleteBackward() {
        Self.logger.trace("deleteBackward")
        text = textValue.digits.dropLast().string
        sendActions(for: .editingChanged)
    }
    
    private func setupViews() {
        Self.logger.trace("setupViews")
        //tintColor = .clear
        font = .systemFont(ofSize: 40, weight: .regular)
    }
    
    @objc private func editingChanged() {
        Self.logger.trace("editingChanged")
        text = currency(from: decimal)
        resetSelection()
        updateValue()
    }
    
    @objc private func resetSelection() {
        Self.logger.trace("resetSelection")
        selectedTextRange = textRange(from: endOfDocument, to: endOfDocument)
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
