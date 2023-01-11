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
    @Binding var decimal: Decimal
    private let formatter: NumberFormatter
    typealias UIViewType = DecimalUiTF
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: DecimalTF.self))
    
    init(decimal: Binding<Decimal>) {
        self._decimal = decimal
        self.text = decimal.wrappedValue.description //TODO:
        
        //if this is being rebuilt all the time this is a performance hit
        let nmbrFrmt = NumberFormatter()
        nmbrFrmt.numberStyle = .currency
        nmbrFrmt.maximumFractionDigits = 2
        self.formatter = nmbrFrmt
    }
    
    func makeUIView(context: Context) -> DecimalUiTF {
        Self.logger.trace("makeUIView(context: Context)")
        let tf = DecimalUiTF(text: text)
        tf.borderStyle = .roundedRect
        tf.delegate = context.coordinator
        return tf
    }
    
    func updateUIView(_ uiView: DecimalUiTF, context: Context) {
        Self.logger.trace("updateUIView")
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Self.logger.trace("makeCoordinator()")
        return Coordinator(text: $text, decimal: $decimal, formatter: formatter)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                           category: String(describing: DecimalTF.Coordinator.self))
        @Binding var text: String //updates parent
        @Binding var decimal: Decimal //updates swiftui
        private let formatter: NumberFormatter //TODO: there are two formatters
        
        init(text: Binding<String>, decimal: Binding<Decimal>, formatter: NumberFormatter) {
            Self.logger.trace("init(text: Binding<String>)")
            self._text = text
            self._decimal = decimal
            self.formatter = formatter
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            Self.logger.trace("textFieldDidChangeSelection")
            text = textField.text ?? ""
            let dec = (textField.text ?? "").decimal /// pow(10, formatter.maximumFractionDigits)
            decimal = dec
        }
    }
}

import UIKit

class DecimalUiTF: UITextField {
    
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: DecimalUiTF.self))
    
    init(text: String) {
        Self.logger.trace("init(text: String)")
        super.init(frame: .zero)
//        self.text = text
//        self.textColor = .red
        
        self.font =  UIFont.systemFont(ofSize: 17, weight: .regular) //TODO: match font
        self.keyboardType = .numberPad
        self.textAlignment = .right
        self.borderStyle = .roundedRect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
