//
//  CustomUiTF.swift
//  NumberSample
//
//  Created by Aaron Anthony on 2023-01-11.
//

import UIKit
import os

class CustomUiTF: UITextField {
    
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: CustomUiTF.self))
    
    init(text: String) {
        Self.logger.trace("init(text: String)")
        super.init(frame: .zero)
        self.text = text
        self.textColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI

struct CustomTF: UIViewRepresentable {
    @Binding var text: String
    typealias UIViewType = CustomUiTF
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: CustomTF.self))
    
    func makeUIView(context: Context) -> CustomUiTF {
        Self.logger.trace("makeUIView(context: Context)")
        let tf = CustomUiTF(text: text)
        tf.delegate = context.coordinator
        return tf
    }
    
    func updateUIView(_ uiView: CustomUiTF, context: Context) {
        Self.logger.trace("updateUIView")
        uiView.text = context.coordinator.text
    }
    
    func makeCoordinator() -> Coordinator {
        Self.logger.trace("makeCoordinator()")
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                           category: String(describing: Coordinator.self))
        @Binding var text: String
        
        init(text: Binding<String>) {
            Self.logger.trace("init(text: Binding<String>)")
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            Self.logger.trace("textFieldDidChangeSelection")
        }
    }
}
