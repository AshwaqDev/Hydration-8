//
//  ContentView.swift
//  Hydration
//
//  Created by Ashwaq on 24/04/1446 AH.
//

import SwiftUI

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var showNotificationPrompt = false
    
    var body: some View {
        VStack {
            // Your app's main content
            Text("Welcome to Hydrate!")
                .font(.largeTitle)
                .padding()

            Button("Get Started") {
                showNotificationPrompt = true
            }
            .padding()
        }
        .onAppear {
            // Check if it's the first launch and show the notification prompt
            if isFirstLaunch() {
                showNotificationPrompt = true
            }
        }
        .alert(isPresented: $showNotificationPrompt) {
            Alert(
                title: Text("Enable Notifications"),
                message: Text("We’ll remind you to stay hydrated throughout the day."),
                primaryButton: .default(Text("Allow")) {
                    requestNotificationPermission()
                },
                secondaryButton: .cancel(Text("Later"))
            )
        }
    }
    
    // Function to check if it's the first launch
    private func isFirstLaunch() -> Bool {
        let hasLaunchedKey = "hasLaunched"
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: hasLaunchedKey) {
            return false
        } else {
            userDefaults.set(true, forKey: hasLaunchedKey)
            return true
        }
    }
    
    // Request notification permissions
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted.")
            } else if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

