//
//  ContentView.swift
//  WeSplit
//
//  Created by Andy Wu on 12/4/22.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    
    @State private var showCustomTip = false
    @State private var customTip: Double = 0
    
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    let currencyFormat: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currency?.identifier ?? "USD")
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let amountPerPerson = orderTotal / peopleCount
        
        return amountPerPerson
    }
    
    var orderTotal: Double {
        if !showCustomTip {
            let tipSelection = Double(tipPercentage)
            return checkAmount + (checkAmount * (tipSelection / 100))
        }
        return checkAmount + customTip
    }
    
    var body: some View {
        VStack {
            Form {
                // Bill details
                Section {
                    HStack {
                        Text("Subtotal: ")
                        TextField("Amount", value: $checkAmount, format: currencyFormat)
                            .keyboardType(.decimalPad)
                            .focused($amountIsFocused)
                    }
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                } header: {
                    Text("Bill Details")
                }
                
                // Tip details
                Section {
                    Toggle("Custom Tip", isOn: $showCustomTip)
                    if !showCustomTip {
                        Picker("Tip percentage", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text($0, format: .percent)
                            }
                        }
                        .pickerStyle(.segmented)
                    } else {
                        HStack {
                            Text("Amount: ")
                            TextField("Amount", value: $customTip, format: currencyFormat)
                                .keyboardType(.decimalPad)
                                .focused($amountIsFocused)
                        }
                    }
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                // Check total w/ tip + calculation result
                Section {
                    HStack {
                        Text("Total: ")
                        Text(orderTotal, format: currencyFormat)
                    }
                    HStack {
                        Text("Each person owes")
                        Text(totalPerPerson, format: currencyFormat)
                    }
                    
                } header: {
                    Text("Result")
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
