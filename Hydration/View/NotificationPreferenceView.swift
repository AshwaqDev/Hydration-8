
import SwiftUI

struct NotificationPreferenceView: View {
    @StateObject var viewModel: HydrationViewModel
    @State private var isNavigatingToTracker = false
    @State private var startHour: String = "3:00"
    @State private var startPeriod: String = "PM"
    @State private var endHour: String = "12:00" // Updated to match time format
    @State private var endPeriod: String = "PM"
    @State private var selectedInterval: String? // State to keep track of the selected interval
    
    let intervals: [[String]] = [
        ["15 ", "30 ", "60 ", "90 "],
        ["2 ", "3 ", "4 ", "5"]
    ]
    var body: some View {
        
        
        VStack(spacing: 20) {
            // Title
            Text("The Start and End hour")
                .font(.custom("SFProText-Semibold", size: 17))
                .fontWeight(.bold) // Set font weight to regular
                .lineSpacing(5)
                .frame(maxWidth: .infinity, alignment: .leading) // Left alignment
            // Adjust line height
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0)).multilineTextAlignment(.leading)
            //            // Subtitle
            Text("Specify the start and end time to receive notifications")
                .font(.custom("SFPro-Regular", size: 16)) // Set custom font, size 17
                .fontWeight(.regular) // Set font weight to regular
            //            .foregroundColor(.gray)
                .foregroundColor(Color(red: 99/255, green: 98/255, blue: 102/255)) // Set the
                .lineSpacing(5) // Adjust line height (22px - 17px = 5px)
                .tracking(0) // Letter spacing (0px)
                .multilineTextAlignment(.leading) // Align text
                .frame(maxWidth: .infinity, alignment: .leading) // Full-width frame for alignment
                .opacity(1)
                .padding(EdgeInsets(top: -14, leading: 0, bottom: 4, trailing: 0)).multilineTextAlignment(.leading)
            //
        }.padding()
        
        VStack(spacing: 0) {
            HStack{
                Text("Start Hour:")
                    .frame(width: 165, alignment: .leading) // Fixed width for label
                TextField("HH:MM", text: $startHour)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 80) // Fixed width for the text field
                    .keyboardType(.decimalPad) // Show number keyboard
                
                Picker("Period", selection: $startPeriod) {
                    Text("AM").tag("AM")
                    Text("PM").tag("PM")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 100) // Fixed width for the toggle
            }.padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 242/255, green: 242/255, blue: 247/255))
            Rectangle() // Add a colored line here
                .fill(Color(.gray)) // Change color as needed
                .frame(height: 2) // Set the height of the line
                .padding(.vertical, -1) // Add vertical padding
            
            
            // End Time Selection
            HStack() {
                Text("End Hour:")
                    .frame(width: 165, alignment: .leading) // Fixed width for label
                TextField("HH:MM", text: $endHour) // Changed to use the correct state variable
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 80)
                    .keyboardType(.decimalPad)
                
                Picker("Period", selection: $endPeriod) {
                    Text("AM").tag("AM")
                    Text("PM").tag("PM")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 100)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 242/255, green: 242/255, blue: 247/255))
            
            
            // Spacer()
        }.padding()
        
        
        VStack(spacing: 20) {
            // Title
            Text("Notification Interval ")
                .font(.custom("SFProText-Semibold", size: 17))            .fontWeight(.bold) // Set font weight to regular
                .lineSpacing(5)
                .frame(maxWidth: .infinity, alignment: .leading) // Left alignment
            // Adjust line height
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0)).multilineTextAlignment(.leading)
            //
            //            // Subtitle
            Text("How often would you like to recive notfications within the specified time interval")
                .font(.custom("SFPro-Regular", size: 16)) // Set custom font, size 17
                .fontWeight(.regular) // Set font weight to regular
            //            .foregroundColor(.gray)
                .foregroundColor(Color(red: 99/255, green: 98/255, blue: 102/255)) // Set the
                .lineSpacing(5) // Adjust line height (22px - 17px = 5px)
                .tracking(0) // Letter spacing (0px)
                .multilineTextAlignment(.leading) // Align text
                .frame(maxWidth: .infinity, alignment: .leading) // Full-width frame for alignment
                .opacity(1)
                .padding(EdgeInsets(top: -14, leading: 0, bottom: 4, trailing: 0)).multilineTextAlignment(.leading)
            //
        }.padding()
        
        
        VStack(spacing: 20) {
            
            
            ForEach(0..<intervals.count, id: \.self) { row in
                HStack(spacing: 20) {
                    ForEach(intervals[row], id: \.self) { interval in
                        Button(action: {
                            
                            updateSelectedInterval(interval: interval, row: row)
                        }) {
                            VStack {
                                Text(interval)
                                    .font(.headline)
                                    .foregroundColor(textColor(for: interval, row: row, isNumber: true)) // Color for the number
                                Text(row == 0 ? "Mins" : "Hours")
                                    .font(.subheadline)
                                    .foregroundColor(textColor(for: interval, row: row, isNumber: false)) // Color for the unit
                            }
                            .frame(width: 80, height: 70) // Button size
                            .background(backgroundColor(for: interval, row: row)) // Background color
                            .cornerRadius(12) // Rounded corners
                        }
                    }
                }
                
            }
        }
        .padding()
        
        Button(action: {
            // Action for the button goes here
            print("Next button tapped")
            viewModel.scheduleNotifications()
            isNavigatingToTracker = true
        }) {
            Text("Next")
                .font(.custom("SFPro-Regular", size: 17)) // Set font to SF Pro Regular, size 17
                .fontWeight(.regular) // Set font weight to regular
                .foregroundColor(.white) // Set text color to white
                .lineSpacing(3) // Adjust line height (20px - 17px = 3px)
                .padding() // Padding for button text
                .frame(maxWidth: .infinity) // Full-width button
                .background(Color(red: 50/255, green: 173/255, blue: 230/255)) // Set the color to #32ADE6
            
                .cornerRadius(8) // Rounded corners
                .fullScreenCover(isPresented: $isNavigatingToTracker) {
                    HydrationTrackerView(viewModel: viewModel)
                }
        }.offset(x: 0, y: 50)
            .padding() // Padding for the button
        
        
        //        Form {
        //            DatePicker("Start Time", selection: $viewModel.notificationStartTime, displayedComponents: .hourAndMinute)
        //            DatePicker("End Time", selection: $viewModel.notificationEndTime, displayedComponents: .hourAndMinute)
        //            
        //            Stepper("Notification Interval: 1 minute", value: Binding(get: {
        //                1
        //            }, set: { _ in
        //                viewModel.notificationInterval = 60 // Set to 1 minute
        //            }), in: 1...60)
        //            
        //            Toggle("Reminder Notifications", isOn: $viewModel.shouldSendReminder)
        //            Toggle("Motivation Notifications", isOn: $viewModel.shouldSendMotivation)
        //            Toggle("Achievement Notifications", isOn: $viewModel.shouldSendAchievement)
        //
        //            Button("Save Preferences") {
        //                viewModel.scheduleNotifications()
        //                isNavigatingToTracker = true
        //
        //                // Navigate to the tracker view or update state to reflect this action
        //            }
        //            .padding()
        //            .background(Color.blue)
        //            .foregroundColor(.white)
        //            .cornerRadius(5)
        //            .fullScreenCover(isPresented: $isNavigatingToTracker) {
        //                         HydrationTrackerView(viewModel: viewModel)
        //                  }
        //        }
        //        .navigationTitle("Notification Preferences")
        //    }
        //
        
    }
    private func updateSelectedInterval(interval: String, row: Int) {
        let label = row == 0 ? "\(interval) min" : "\(interval) hours"
        selectedInterval = label
    }

    private func backgroundColor(for interval: String, row: Int) -> Color {
        let label = row == 0 ? "\(interval) min" : "\(interval) hours"
        return selectedInterval == label ? Color.blue : Color.gray.opacity(0.3)
    }

    private func textColor(for interval: String, row: Int, isNumber: Bool) -> Color {
            let label = row == 0 ? "\(interval) min" : "\(interval) hours"
            // Set color based on selection status
            if selectedInterval == label {
                return .white // Selected button
            } else {
                return isNumber ? Color.blue : Color.black // Blue for number, black for "min" or "hours"
            }
        }
}

