
import SwiftUI

struct HydrationTrackerView: View {
    @StateObject var viewModel: HydrationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var addedAmount: Double = 0

    var body: some View {
        VStack {
            // Title and intake summary aligned to the left
            HStack {
                VStack(alignment: .leading) {
                    Text("Today's Water Intake")
                        .font(.custom("SFPro-Semibold", size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .lineSpacing(6)
                        .padding(.vertical, 4)

                    HStack {
                        Text("\(viewModel.model.dailyGoal, specifier: "%.1f") liters")
                            .font(.custom("SFPro-Semibold", size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .lineSpacing(6)
                            .padding(.vertical, 4)

                        Text("/")
                        
                        Text("\(viewModel.model.currentAmount + addedAmount, specifier: "%.1f") liters")
                            .font(.custom("SFPro-Semibold", size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .lineSpacing(6)
                            .padding(.vertical, 4)
                    }
                    .font(.headline)
                }
                Spacer() // Push the VStack to the left
            }
            .padding(.leading) // Optional padding for left alignment
            Spacer(minLength: 20) // Adjust the min length as needed

            // Circular progress view centered
            CircularProgressView(viewModel: viewModel, currentAmount: viewModel.model.currentAmount + addedAmount, total: viewModel.model.dailyGoal)
                .frame(width: 300, height: 300)
                .padding()

            // Centered stepper and its label
            Spacer(minLength: 20) // Adjust the min length as needed

            VStack {
                Text("\(addedAmount, specifier: "%.1f") liters")
                    .font(.headline)
                    .padding(.top).foregroundColor(.black)


                Stepper("", value: $addedAmount, in: 0...(viewModel.model.dailyGoal - viewModel.model.currentAmount), step: 0.25)
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .center) // Center the stepper
            }
            .padding(.horizontal) // Add horizontal padding to the VStack
            
            .onChange(of: addedAmount) { newValue in
                // Adjust the amount automatically as the stepper changes
                if newValue > 0 {
                    viewModel.addWater(amount: newValue)
                } else {
                    viewModel.subtractWater(amount: abs(newValue))
                }
            }
            .disabled(viewModel.model.currentAmount >= viewModel.model.dailyGoal && addedAmount > 0)
            
            Spacer() // Push everything up and allow for centering
        }
        .padding()
        .navigationTitle("Hydration Tracker")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    showAlert = true
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Warning"),
                message: Text("You cannot go back at this stage."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


struct CircularProgressView: View {
    @ObservedObject var viewModel: HydrationViewModel // Observed object to watch for changes
    var currentAmount: Double
    var total: Double
    
    var body: some View {
        GeometryReader { geometry in
            let width = min(geometry.size.width, geometry.size.height)
            let percentage = currentAmount / total
            
            Circle()
                .stroke(
                    Color(red: 242/255, green: 242/255, blue: 247/255),
                    lineWidth: 30
                )
            Circle()
                .trim(from: 0.0, to: CGFloat(percentage))
                .stroke(Color(red: 50/255, green: 173/255, blue: 230/255), style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: width, height: width)
                .overlay(
                    VStack {
                        Text(viewModel.hydrationSymbol()) // Call method to get the symbol dynamically
                            .font(.largeTitle) .font(.custom("", size: 50))

//                        Text("\(Int(percentage * 100))%")
//                            .font(.subheadline)
//                            .foregroundColor(Color(red: 50/255, green: 173/255, blue: 230/255))
                    }
                )
        }
    }
}
