//
//  ContentView.swift
//  NumberSample
//
//  Created by Benoit PASQUIER on 28/10/2021.
//

import SwiftUI
import Combine
import os

struct ContentView: View {
    @State private var isSubtitleHidden = false
    @State private var value: Decimal = 10
    
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: ContentView.self))
    
    var body: some View {
        List {
            
//            Section {
//                currency
//            }
            
            //basicTF
            
            Section {
                decimalFields
            }
        }
    }
    
    var currency: some View {
        VStack {
            
            Text("CurrencyTF")
                .font(.title)
            
            HStack {
                Text("decimal")
                Spacer()
                Text(value.description)
            }
            
            HStack {
                Text("swiftUi")
                Spacer()
                TextField(".number", value: $value, format: .number)
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("uiKit")
                Spacer()
                CurrencyTF(value: $value)
            }
        }
    }
    
    @State var decimal: Decimal = 1
    var decimalFields: some View {
        VStack {
            
            HStack {
                Text("decimal")
                Spacer()
                Text(decimal.description)
            }
            
            HStack {
                Text("swiftUI")
                Spacer()
                TextField("test", value: $decimal, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
            }
            
            HStack {
                Text("uiKit")
                Spacer()
                DecimalTF(decimal: $decimal)
            }
        }
    }
    
    @State var text = "CustomTF Test"
    var basicTF: some View {
        
        VStack {
            
            HStack {
                Text("text")
                Spacer()
                Text(text)
            }
            
            HStack {
                Text("swiftUI")
                Spacer()
                TextField("test", text: $text)
                    .textFieldStyle(.roundedBorder)
            }
            
            HStack {
                Text("uiKit")
                Spacer()
                CustomTF(text: $text)
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(numberFormatter:
//                        PreviewNumberFormatter(locale: Locale(identifier: "en_US"))
//        )
//    }
//}
