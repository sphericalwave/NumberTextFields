//
//  CurrencyTextField.swift
//  NumberSample
//
//  Created by Benoit Pasquier on 10/2/22.
//

import Foundation
import SwiftUI
import os

struct CurrencyTextField: UIViewRepresentable {

    typealias UIViewType = CurrencyUITextField
    let currencyField: CurrencyUITextField
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: CurrencyTextField.self))

    init(value: Binding<Decimal>) {
        Self.logger.trace("init \(value.wrappedValue)")
        currencyField = CurrencyUITextField(decimal: value)
    }

    func makeUIView(context: Context) -> CurrencyUITextField {
        Self.logger.trace("makeUIView")
        return currencyField
    }

    func updateUIView(_ uiView: CurrencyUITextField, context: Context) {
        Self.logger.trace("updateUIView")
    }
}
