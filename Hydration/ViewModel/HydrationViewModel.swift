//
//  HydrationViewModel.swift
//  Hydration
//
//  Created by Ashwaq on 24/04/1446 AH.
//

import Foundation
import Combine
import UserNotifications

class HydrationViewModel: ObservableObject {
    @Published var model: HydrationModel
    @Published var notificationStartTime: Date = Date()
    @Published var notificationEndTime: Date = Date()
    @Published var notificationInterval: TimeInterval = 60 // 1 hour
    @Published var shouldNotify: Bool = true // For example, toggle for motivation notifications
    @Published var shouldSendReminder: Bool = true
    @Published var shouldSendMotivation: Bool = true
    @Published var shouldSendAchievement: Bool = true
    
    init() {
        self.model = HydrationModel(bodyWeight: 0.0)
    }
    
//    init(model: HydrationModel) {
//        self.model = model
//    }
//
    
    
    func setBodyWeight(_ weight: Double) {
        model.bodyWeight = weight
    }
    
    func addWater(amount: Double) {
        model.currentAmount += amount
        print("hi  addWater model.currentAmount", model.currentAmount )
        print("hi  addWater amount", amount )
    }
    
    func subtractWater(amount: Double) {
        model.currentAmount = max(0, model.currentAmount - amount)
        print("hi  subtractWater model.currentAmount", model.currentAmount )
        print("hi  subtractWater amount", amount )


    }
    
    // Computed property for hydration symbol
    func hydrationSymbol() -> String {
        print("hi  model.currentAmount", model.currentAmount )
        print("hi model.dailyGoal", model.dailyGoal)

        let percentage = model.currentAmount / model.dailyGoal
        print("hi percentage", percentage)
        switch percentage {
        case 0..<0.25:
            return "💤" // First quarter (zzz)
        case 0.25..<0.5:
            return "🐢" // Second quarter (turtle)
        case 0.5..<0.75:
            return "🐇" // Third quarter (rabbit)
        case 0.75..<1.0:
            return "👏" // Goal reached (clap)
        default:
            return "👏" // Goal reached (clap)
        }
    }
    func scheduleNotifications() {
            // Request notification permission
        print("  scheduleNotifications" )

            UNUserNotificationCenter.current().requestAuthorization { granted, error in
                if granted {
                    self.setupNotifications()
                    print("  after self.setupNotifications()" )

                }
            }
        }
        
    
    private func setupNotifications() {
        // Remove previous notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("  setupNotifications" )

        // Check if user has reached a certain percentage of their goal (e.g., 90%)
        let goalReachedThreshold = model.dailyGoal * 0.90
        if model.currentAmount >= goalReachedThreshold && model.currentAmount < model.dailyGoal {
            print("  1" )
            sendAchievementNotification()
        }

        // Schedule reminders and motivations as before
        if shouldSendReminder && model.currentAmount < model.dailyGoal {
            print("  2" )

            scheduleReminderNotifications()
        }

        if shouldSendMotivation && model.currentAmount < model.dailyGoal {
            print("  3" )

            scheduleMotivationNotifications()
        }
    }
        
        private func scheduleReminderNotifications() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder Notification 2"
            content.body = "Hey there! it's time to hydrate. You're close to reaching today's water goal. Take a sip to stay on track!"
            content.sound = .default
            
            // Create a trigger for hourly reminders (example)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            print("  trigger",trigger )

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            print("  request",request )

            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
        private func scheduleMotivationNotifications() {
            let content = UNMutableNotificationContent()
            content.title = "Motivation Notification 2"
            content.body = "Great job on staying hydrated! Keep up the good work. Every sip bring you closer to your health goals!"
            content.sound = .default
            
            // Create a trigger for motivation notifications (example)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 90, repeats: true) // Every 2 hours
            print("  trigger scheduleMotivationNotifications",trigger )

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            print("  request scheduleMotivationNotifications",request )

            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    // Send immediately when the user achieves their goal

        private func sendAchievementNotification() {
            let content = UNMutableNotificationContent()
            content.title = "Achievement Notification 3"
            content.body = "You're almost! there just a few more sips to go to reach today's water goal. You're doing fantastic!"
            content.sound = .default
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    
}


