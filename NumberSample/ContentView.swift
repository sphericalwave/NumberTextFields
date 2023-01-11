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
            
            currency
            
            //basicTF
            
            //decimalFields
        }
    }
    
    var currency: some View {
        VStack(spacing: 20) {
            
            Text("Send money")
                .font(.title)
            
            Text(value.description)
            
            TextField(".number", value: $value, format: .number)
                .keyboardType(.decimalPad)
            
            CurrencyTextField(value: $value)
                .padding(20)
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2))
                .frame(height: 100)
            
            Rectangle()
                .frame(width: 0, height: 40)
            
            Text("Send")
                .fontWeight(.bold)
                .padding(30)
                .frame(width: 180, height: 50)
                .background(Color.yellow)
                .cornerRadius(20)
                .onTapGesture {
                    if !isSubtitleHidden {
                        isSubtitleHidden.toggle()
                    }
                }
            
            
            if isSubtitleHidden {
                Text("Sending \(value.description)")
            }
            
            Spacer()
        }
        .padding(.top, 60)
        .padding(.horizontal, 20)
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
