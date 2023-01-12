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
        self._value = value
        let t = Formatter.currency.string(for: value.wrappedValue) ?? ""
        //Self.logger.trace("init val: \(value.wrappedValue ?? "nil"), text: \(t)")
        Self.logger.trace("init val: ")

        self.text = t
    }
    
    func makeUIView(context: Context) -> TerminalTF {
        Self.logger.trace("makeUIView")
        let terminalTF = TerminalTF()
        terminalTF.delegate = context.coordinator
        return terminalTF
    }
    
    func updateUIView(_ uiView: TerminalTF, context: Context) {
        Self.logger.trace("updateUIView")
        if let decimal = value {
            let frmtText = Formatter.currency.string(for: decimal) ?? ""
            uiView.text = frmtText
        }
        else {
            let frmtText = Formatter.currency.string(for: 0) ?? ""
            uiView.text = frmtText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(decimal: $value)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                           category: String(describing: Coordinator.self))
        @Binding var decimal: Decimal?

        init(decimal: Binding<Decimal?>) {
            Self.logger.trace("init")
            self._decimal = decimal
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string != "" {
                Self.logger.trace("add digit")
                let text = textField.text?.appending(string) ?? ""
                self.decimal = decimal(text: text)
            }
            else { //backspace case
                Self.logger.trace("remove digit")
                if let t = textField.text {
                    let text = String(t.dropLast())
                    self.decimal = decimal(text: text)
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
