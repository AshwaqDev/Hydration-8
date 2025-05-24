//
//  NotificationSettingsViewModel.swift
//  Hydration
//
//  Created by Ashwaq on 24/04/1446 AH.
//

import SwiftUI
import UserNotifications

class NotificationSettingsViewModel: ObservableObject {
    @Published var startHour: String = "3:00"
    @Published var startPeriod: String = "PM"
    @Published var endHour: String = "12:00"
    @Published var endPeriod: String = "PM"
    @Published var selectedInterval: String?

    let intervals: [[String]] = [
        ["15", "30", "60", "90"],
        ["2", "3", "4", "5"]
    ]

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notifications: \(error)")
            }
        }
    }

    func scheduleNotifications() {
        guard let interval = selectedInterval, let minutes = extractMinutes(from: interval) else { return }
        print("scheduleNotifications NotificationSettingsViewModel: \(interval)")

        let startTime = convertToDate(hour: startHour, period: startPeriod)
        let endTime = convertToDate(hour: endHour, period: endPeriod)
        var currentDate = startTime
        let notificationInterval = TimeInterval(minutes * 60)

        while currentDate <= endTime {
            let content = UNMutableNotificationContent()
            content.title = "Hydration Reminder"
            content.body = "Time to drink some water!"
            content.sound = .default

            let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }

            currentDate = currentDate.addingTimeInterval(notificationInterval)
        }
    }

    private func extractMinutes(from interval: String) -> Int? {
        print("extractMinutes: \(interval)")

        return Int(interval)
    }

    private func convertToDate(hour: String, period: String) -> Date {
        print("convertToDate: \(hour)")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.date(from: "\(hour) \(period)") ?? Date()
    }
}
