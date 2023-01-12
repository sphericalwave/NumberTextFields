//
//  CurrencyUITextField.swift
//  NumberSample
//
//  Created by Benoit Pasquier on 10/2/22.
//

import Foundation
import UIKit
import SwiftUI
import os

class TerminalTF: UITextField {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: TerminalTF.self))
    init() {
        Self.logger.trace("init")
        super.init(frame: .zero)
        self.font =  UIFont.systemFont(ofSize: 17, weight: .regular) //TODO: match font
        self.keyboardType = .numberPad
        self.textAlignment = .right
        self.borderStyle = .roundedRect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //prevent user from moving the cursor
    //keep cursor all the way to the right
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        return self.endOfDocument
    }
    
    //prevent user from moving cursor with copy paster ui
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        //editingChanged()
        return !isFirstResponder
    }
}
