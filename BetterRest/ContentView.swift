//
//  ContentView.swift
//  BetterRest
//
//  Created by Jasper Tan on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        
        NavigationStack {
            Form {
                VStack {
                    //MARK: Set Wakeup time
                    Text("What time do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Enter a wakeup time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                VStack {
                    //MARK: Set Desired Sleep Amount
                    Text("Desired Amount of Sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12)
                }
                
                VStack {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Stepper("\(coffeeAmount) cup(s)", value: $coffeeAmount, in: 1...20)
                }
            }
            .navigationTitle("BetterRest")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar
            {
                Button("Calculate", action: calculateBedtime)
            }
        }
    }
    
    func calculateBedtime() {
        
    }
}

#Preview {
    ContentView()
    //SandBoxView()
}

struct SandBoxView: View {
    @State private var wakeUp = Date.now
    
    var body: some View {
        DatePicker("Please enter a date", selection: $wakeUp)
            .labelsHidden()
    }
}
