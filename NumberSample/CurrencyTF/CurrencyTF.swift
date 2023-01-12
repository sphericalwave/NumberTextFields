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
    
    typealias UIViewType = CurrencyUITextField
    @Binding var value: Decimal
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: CurrencyTF.self))
    
    private let formatter: NumberFormatter
    
    init(value: Binding<Decimal>) {
        Self.logger.trace("init \(value.wrappedValue)")
        self._value = value
        
        //FIXME: this is being rebuilt whenever the value of TF ∆s
        let nmbrFrmt = NumberFormatter()
        nmbrFrmt.numberStyle = .currency
        nmbrFrmt.maximumFractionDigits = 2
        self.formatter = nmbrFrmt
    }
    
    func makeUIView(context: Context) -> CurrencyUITextField {
        Self.logger.trace("makeUIView")
        let currencyField = CurrencyUITextField(decimal: value, formatter: formatter)
        currencyField.delegate = context.coordinator
        return currencyField
    }
    
    func updateUIView(_ uiView: CurrencyUITextField, context: Context) {
        Self.logger.trace("updateUIView")
        uiView.text = formatter.string(for: value)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value, formatter: formatter)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                           category: String(describing: Coordinator.self))
        
        @Binding var value: Decimal
        private let formatter: NumberFormatter
        
        init(value: Binding<Decimal>, formatter: NumberFormatter) {
            Self.logger.trace("init")
            self._value = value
            self.formatter = formatter
        }
        
        //keep cursor all the way to the right
        func textFieldDidBeginEditing(_ textField: UITextField) {
            Self.logger.trace("move cursor to right")
            textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            //backspace
            guard string != "" else {
                Self.logger.trace("remove digit")
                if let text = textField.text {
                    let removeFrmt = text.filter (\.isWholeNumber)
                    let removeLeastChar = String(removeFrmt.dropLast())
                    let decimal = Decimal(string: removeLeastChar) ?? 0
                    let shiftedDecimal = decimal / pow(10, formatter.maximumFractionDigits)
                    self.value = shiftedDecimal
                }
                return false
            }
            
            //add text
            if let text = textField.text {
                Self.logger.trace("add digit")
                let removeFrmt = text.filter (\.isWholeNumber)
                let appendChar = removeFrmt.appending(string)
                let decimal = Decimal(string: appendChar) ?? 0
                let shiftedDecimal = decimal / pow(10, formatter.maximumFractionDigits)
                self.value = shiftedDecimal
                return false
            }
            
            //unused
            return false
        }
    }
}
