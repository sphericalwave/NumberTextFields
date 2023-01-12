//
//  Formatter+.swift
//  NumberSample
//
//  Created by Aaron Anthony on 2023-01-12.
//

import Foundation

//TODO: double check on best practice
extension Formatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
