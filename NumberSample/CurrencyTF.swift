//
//  CurrencyTextField.swift
//  NumberSample
//
//  Created by Benoit Pasquier on 10/2/22.
//

import Foundation
import SwiftUI
import os
import UIKit

struct CurrencyTF: UIViewRepresentable {
    typealias UIViewType = TerminalTF
    @Binding var value: Decimal?
    @State private var text: String
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: CurrencyTF.self))
        
    init(value: Binding<Decimal?>) {
        Self.logger.trace("init")
        self._value = value
        self.text = Formatter.currency.string(for: value.wrappedValue) ?? ""
    }
    
    func makeUIView(context: Context) -> TerminalTF {
        Self.logger.trace("makeUIView")
        let tf = TerminalTF()
        tf.delegate = context.coordinator
        tf.placeholder = "$"
        tf.accessibilityIdentifier = "IntegerTF"
        return tf
    }
    
    func updateUIView(_ uiView: TerminalTF, context: Context) {
        Self.logger.trace("updateUIView")
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Self.logger.trace("makeCoordinator()")
        return Coordinator(text: $text, decimal: $value)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                           category: String(describing: Coordinator.self))
        @Binding var text: String
        @Binding var decimal: Decimal?

        init(text: Binding<String>, decimal: Binding<Decimal?>) {
            Self.logger.trace("init")
            self._text = text
            self._decimal = decimal
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string != "" {
                Self.logger.trace("add digit")
                let newText = textField.text?.appending(string) ?? ""
                self.decimal = decimal(text: newText)
                self.text = Formatter.currency.string(for: decimal) ?? ""
            }
            else { //backspace case
                Self.logger.trace("remove digit")
                if let t = textField.text {
                    let newText = String(t.dropLast())
                    self.decimal = decimal(text: newText)
                    self.text = Formatter.currency.string(for: decimal) ?? ""
                }
            }
            return false //swiftui updates uiTextField.text in updateUiView
        }
        
        func decimal(text: String) -> Decimal? {
            let removeFrmt = text.filter (\.isWholeNumber)
            let decimal = Decimal(string: removeFrmt) ?? 0
            let shiftedDecimal = decimal / pow(10, Formatter.currency.maximumFractionDigits)
            return shiftedDecimal
        }
    }
}
