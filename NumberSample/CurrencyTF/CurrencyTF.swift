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
    @Binding var value: Decimal
    @State var text: String
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: CurrencyTF.self))
    
    private let formatter: NumberFormatter
    
    //FIXME: this is being rebuilt whenever the value of TF ∆s
    init(value: Binding<Decimal>) {
        Self.logger.trace("init \(value.wrappedValue)")
        let nmbrFrmt = NumberFormatter()
        nmbrFrmt.numberStyle = .currency
        nmbrFrmt.maximumFractionDigits = 2
        self.formatter = nmbrFrmt
        self._value = value
        self.text = nmbrFrmt.string(for: value.wrappedValue) ?? ""
    }
    
    func makeUIView(context: Context) -> TerminalTF {
        Self.logger.trace("makeUIView")
        let terminalTF = TerminalTF()
        terminalTF.delegate = context.coordinator
        return terminalTF
    }
    
    func updateUIView(_ uiView: TerminalTF, context: Context) {
        Self.logger.trace("updateUIView")
        let removeFrmt = text.filter (\.isWholeNumber)
        let decimal = Decimal(string: removeFrmt) ?? 0
        let shiftedDecimal = decimal / pow(10, formatter.maximumFractionDigits)
        uiView.text = formatter.string(for: shiftedDecimal)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, value: $value, formatter: formatter)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                           category: String(describing: Coordinator.self))
        
        @Binding var text: String
        @Binding var value: Decimal
        private let formatter: NumberFormatter
        
        init(text: Binding<String>, value: Binding<Decimal>, formatter: NumberFormatter) {
            Self.logger.trace("init")
            self._text = text
            self._value = value
            self.formatter = formatter
        }
        
        //keep cursor all the way to the right
        func textFieldDidBeginEditing(_ textField: UITextField) {
            Self.logger.trace("move cursor to right")
            textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            if string != "" {
                Self.logger.trace("add digit")
                text = textField.text?.appending(string) ?? ""
                //TODO: update SwiftUI decimal
//                let removeFrmt = text.filter (\.isWholeNumber)
//                let appendChar = removeFrmt.appending(string)
//                let decimal = Decimal(string: appendChar) ?? 0
//                let shiftedDecimal = decimal / pow(10, formatter.maximumFractionDigits)
//                self.value = shiftedDecimal
            }
            else {
                Self.logger.trace("remove digit")
                if let t = textField.text {
                    text = String(t.dropLast())
                    
//                    let removeFrmt = text.filter (\.isWholeNumber)
//                    let removeLeastChar = String(removeFrmt.dropLast())
//                    let decimal = Decimal(string: removeLeastChar) ?? 0
//                    let shiftedDecimal = decimal / pow(10, formatter.maximumFractionDigits)
//                    self.value = shiftedDecimal
                }
                else {
                    text = ""
                }
            }
            return false
            
        }
        //
        //            //backspace
        //            guard string != "" else {
        //                Self.logger.trace("remove digit")
        //                if let text = textField.text {
        //                    let removeFrmt = text.filter (\.isWholeNumber)
        //                    let removeLeastChar = String(removeFrmt.dropLast())
        //                    let decimal = Decimal(string: removeLeastChar) ?? 0
        //                    let shiftedDecimal = decimal / pow(10, formatter.maximumFractionDigits)
        //                    self.value = shiftedDecimal
        //                }
        //                return false
        //            }
        //
        //            //add text
        //            if let text = textField.text {
        //                Self.logger.trace("add digit")
        //                let removeFrmt = text.filter (\.isWholeNumber)
        //                let appendChar = removeFrmt.appending(string)
        //                let decimal = Decimal(string: appendChar) ?? 0
        //                let shiftedDecimal = decimal / pow(10, formatter.maximumFractionDigits)
        //                self.value = shiftedDecimal
        //                return false
        //            }
        //
        //            //unused
        //            return false
        //        }
    }
}
