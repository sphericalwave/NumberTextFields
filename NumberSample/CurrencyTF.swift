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
    @State private var text: String
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: CurrencyTF.self))
        
    init(value: Binding<Decimal>) {
        self._value = value
        let t = Formatter.currency.string(for: value.wrappedValue) ?? ""
        Self.logger.trace("init val: \(value.wrappedValue), text: \(t)")
        self.text = t
    }
    
    func makeUIView(context: Context) -> TerminalTF {
        Self.logger.trace("makeUIView")
        let terminalTF = TerminalTF()
        terminalTF.delegate = context.coordinator
        return terminalTF
    }
    
    func updateUIView(_ uiView: TerminalTF, context: Context) {
        let removeFrmt = text.filter (\.isWholeNumber)
        let decimal = Decimal(string: removeFrmt) ?? 0
        let shiftedDecimal = decimal / pow(10, Formatter.currency.maximumFractionDigits)
        DispatchQueue.main.async {
            self.value = shiftedDecimal //TODO: skeptical about this ask JC
        }
        let frmtText = Formatter.currency.string(for: shiftedDecimal) ?? ""
        Self.logger.trace("updateUIView text: \(text) shiftedDecimal: \(shiftedDecimal)  frmtText \(frmtText)")
        uiView.text = frmtText
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                           category: String(describing: Coordinator.self))
        @Binding var text: String

        init(text: Binding<String>) {
            Self.logger.trace("init")
            self._text = text
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string != "" {
                Self.logger.trace("add digit")
                text = textField.text?.appending(string) ?? ""
            }
            else { //backspace case
                Self.logger.trace("remove digit")
                if let t = textField.text {
                    text = String(t.dropLast())
                }
            }
            return false //swiftui updates uiTextField.text in updateUiView
        }
    }
}
