//
//  ContentView.swift
//  BetterRest
//
//  Created by Jasper Tan on 11/12/24.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    //Alerts
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
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
                        
                        //Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
                        Picker("Number of cups", selection: $coffeeAmount) {
                            ForEach(1..<21) { num in
                                Text("^[\(num) cup](inflect: true)")
                            }
                        }
                    }
                    
//                    Section("Daily coffee intake") {
//                        Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
//                    }
                }
                .scrollContentBackground(.hidden)
            }
            .background(Color.mint.opacity(0.85).gradient)
            .navigationTitle("BetterRest")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar
            {
                Button("Calculate", action: calculateBedtime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your bedtime is"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        
        showingAlert = true
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
