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

struct CurrencyTextField: UIViewRepresentable {

    typealias UIViewType = CurrencyUITextField
    @Binding var value: Decimal
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: CurrencyTextField.self))
    
    private let formatter: NumberFormatter

    init(value: Binding<Decimal>) {
        Self.logger.trace("init \(value.wrappedValue)")
        self._value = value
        
        //if this is being rebuilt all the time this is a performance hit
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

    //TODO: SwiftUI to UIKit is not working
    func updateUIView(_ uiView: CurrencyUITextField, context: Context) {
        Self.logger.trace("updateUIView")
        //This is the source of trouble
//        let decimal = value / pow(10, formatter.maximumFractionDigits)
//        uiView.decimal = decimal
//        uiView.text = formatter.string(for: decimal)
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
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            Self.logger.trace("textFieldDidChangeSelection")
            
        }
        
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            Self.logger.trace("textFieldShouldBeginEditing text: \(textField.text ?? "empty")")
            //start the editing cursor in all the way to the right
            textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
            return true
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            Self.logger.trace("shouldChangeCharactersIn")
            
            guard string != "" else {
                Self.logger.trace("deleteBackward")
                if let text = textField.text {
                    let removeFrmt = text.digits
                    let removeLeastChar = String(removeFrmt.dropLast())
                    let decimal = removeLeastChar.decimal / pow(10, formatter.maximumFractionDigits)
                    self.value = decimal
                    textField.text = formatter.string(for: decimal)
                }
                return false
            }
            
            if let text = textField.text {
                let removeFrmt = text.digits
                let appendChar = removeFrmt.appending(string)
                let decimal = appendChar.decimal / pow(10, formatter.maximumFractionDigits)
                self.value = decimal
                textField.text = formatter.string(for: decimal)
            }
            else {
                fatalError()
            }
            return false //prevent conventional replacement bcs handling textfield update above
        }
    }
}
