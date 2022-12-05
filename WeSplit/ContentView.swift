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

    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
        
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)

        let tipValue = checkAmount * (tipSelection / 100)
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var orderTotal: Double {
        let tipSelection = Double(tipPercentage)
        return checkAmount + (checkAmount * (tipSelection / 100))
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
                        Text("Subtotal: ")
                        TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
                            .focused($amountIsFocused)
                    }
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                // Check total w/ tip
                Section {
                    HStack {
                        Text("Total: ")
                        Text(orderTotal, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                }
                
                // Result
                Section {
                    HStack {
                        Text("Each person owes")
                        Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                    
                }
            }
            .navigationTitle("WeSplit")
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
