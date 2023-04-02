//
//  ContentView.swift
//  WeSplitApp
//
//  Created by Aida Igarashi on 2023/03/31.
//

import SwiftUI

struct TipPercentageView: View {
    @Binding var tipPercentage: Double
    
    let tipPercentages = Array(0...100)
    
    var body: some View {
        VStack {
            Picker("Tip percentage", selection: $tipPercentage) {
                ForEach(tipPercentages, id: \.self) {
                    Text("\($0)%")
                }
            }
            .pickerStyle(.wheel)
        }
        .navigationTitle("Tip Percentage")
    }
}

struct ContentView: View {
    @FocusState private var amountIsFocused: Bool
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 20.0
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var totalTipIncluded: Double {
        let tipSelection = Double(tipPercentage)
        if tipSelection == 0 {
            return checkAmount
        } else {
            return checkAmount + (checkAmount / 100 * tipSelection)
        }
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format:.currency(code: Locale.current.currencyCode ?? ""))
                        .focused($amountIsFocused)
                        .keyboardType(.decimalPad)
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                //
                Section {
                    NavigationLink(destination: TipPercentageView(tipPercentage: $tipPercentage)) {
                        HStack {
                            Text("Tip percentage")
                            Spacer()
                            Text("\(Int(tipPercentage))%")
                        }
                    }
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? ""))
                } header: {
                    Text ("Amount per person including tip")
                }
                
                Section {
                    Text(totalTipIncluded, format: .currency(code: Locale.current.currencyCode ?? ""))
                } header: {
                    Text ("Amount tip excluded")
                }
                
                .navigationTitle("weSplit")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button ("Done") {
                            amountIsFocused = false
                        }
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
