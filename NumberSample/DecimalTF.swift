//
//  DecimalTF.swift
//  NumberSample
//
//  Created by Aaron Anthony on 2023-01-11.
//

import os

import SwiftUI

struct DecimalTF: UIViewRepresentable {
    @State private var text: String
    @Binding var decimal: Decimal?
    typealias UIViewType = TerminalTF
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: DecimalTF.self))
    
    init(decimal: Binding<Decimal?>) {
        self._decimal = decimal
        self.text = Formatter.decimal.string(for: decimal.wrappedValue) ?? ""
    }
    
    func makeUIView(context: Context) -> TerminalTF {
        Self.logger.trace("makeUIView(context: Context)")
        let tf = TerminalTF()
        tf.delegate = context.coordinator
        tf.placeholder = "empty"
        return tf
    }
    
    func updateUIView(_ uiView: TerminalTF, context: Context) {
        Self.logger.trace("updateUIView")
        
        let removeFrmt = text.filter (\.isWholeNumber)
        if let decimal = Decimal(string: removeFrmt) {
            let frmtText = Formatter.decimal.string(for: decimal)
            Self.logger.trace("updateUIView text: \(text) decimal: \(decimal)  frmtText \(frmtText ?? "nil")")
            
            //update uikit
            uiView.text = frmtText
        }
        else {
            uiView.text = nil
        }
        
        //update swiftUi
        DispatchQueue.main.async {
            self.decimal = decimal
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Self.logger.trace("makeCoordinator()")
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                           category: String(describing: DecimalTF.Coordinator.self))
        @Binding var text: String
        
        init(text: Binding<String>) {
            Self.logger.trace("init(text: Binding<String>)")
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
