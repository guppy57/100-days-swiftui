//
//  ContentView.swift
//  UnitConverter
//
//  Created by Armaan Gupta on 4/20/25.
//

import SwiftUI

struct ContentView: View {
    @State private var inputUnit = "minutes"
    @State private var outputUnit = "hours"
    @State private var inputNum = 0.0
    
    let units = ["minutes", "hours", "days"]
    
    var output: Double {
        if inputUnit == "minutes" {
            if outputUnit == "hours" {
                return Double(inputNum/60)
            } else if outputUnit == "days" {
                return Double(Double(inputNum/60)/24.0)
            }
            return inputNum
        } else if inputUnit == "hours" {
            if outputUnit == "minutes" {
                return inputNum*60
            } else if outputUnit == "days" {
                return Double(inputNum/24)
            }
            return inputNum
        } else if inputUnit == "days" {
            if outputUnit == "minutes" {
                return inputNum*60*24
            } else if outputUnit == "hours" {
                return inputNum*24
            }
            return inputNum
        }
        return 0.0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", value: $inputNum, format: .number)
                        .keyboardType(.numberPad)
                    Picker("Unit", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section("Output") {
                    Picker("Unit", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    Text("Output: \(output, specifier: "%.2f")")
                }
                
            }
            .navigationTitle("Unit Converter")
        }
    }
}

#Preview {
    ContentView()
}
