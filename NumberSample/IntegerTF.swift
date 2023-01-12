//
//  DecimalTF.swift
//  NumberSample
//
//  Created by Aaron Anthony on 2023-01-11.
//

import os
import SwiftUI

struct IntegerTF: UIViewRepresentable {
    typealias UIViewType = TerminalTF
    @Binding var int: Int?
    @State private var text: String
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: IntegerTF.self))
    
    init(int: Binding<Int?>) {
        Self.logger.trace("init")
        self._int = int
        self.text = Formatter.decimal.string(for: int.wrappedValue) ?? ""
    }
    
    func makeUIView(context: Context) -> TerminalTF {
        Self.logger.trace("makeUIView(context: Context)")
        let tf = TerminalTF()
        tf.delegate = context.coordinator
        tf.placeholder = "?"
        tf.accessibilityIdentifier = "IntegerTF"
        return tf
    }
    
    func updateUIView(_ uiView: TerminalTF, context: Context) {
        Self.logger.trace("updateUIView")
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Self.logger.trace("makeCoordinator()")
        return Coordinator(text: $text, int: $int)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                           category: String(describing: IntegerTF.Coordinator.self))
        @Binding var text: String
        @Binding var int: Int?
        
        init(text: Binding<String>, int: Binding<Int?>) {
            Self.logger.trace("init(text: Binding<String>)")
            self._text = text
            self._int = int
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string != "" {
                Self.logger.trace("add digit")
                let newText = textField.text?.appending(string) ?? "" //prevents SwiftUi inits?
                self.int = int(text: newText)
                self.text = Formatter.decimal.string(for: int) ?? ""

            }
            else { //backspace case
                Self.logger.trace("remove digit")
                if let t = textField.text {
                    let newText = String(t.dropLast()) //prevents SwiftUi inits?
                    self.int = int(text: newText)
                    self.text = Formatter.decimal.string(for: int) ?? ""
                }
            }
            return false //swiftui updates uiTextField.text in updateUiView
        }
        
        private func int(text: String) -> Int? {
            let removeFrmt = text.filter (\.isWholeNumber)
            return Int(removeFrmt)
        }
    }
}
