

import SwiftUI


struct WeightInputView: View {
    @StateObject var viewModel = HydrationViewModel()
    @State private var weight: String = ""
    @State private var isNavigatingToPreferences = false
   @State private var feedback: String = ""
    @State private var isActive: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
            headerSection
            bodyWeightInputSection
            Spacer()
            startButton
            feedbackSection
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading) {
            Image(systemName: "drop.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(Color(red: 50/255, green: 173/255, blue: 230/255))
            
            Text("Hydrate")
                .font(.custom("SFPro-Semibold", size: 22))
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .lineSpacing(6)
                .padding(.vertical, 4)
            
            Text("Start with Hydrate to record and track your water intake daily based on your needs and stay hydrated.")
                .font(.custom("SFPro-Regular", size: 17))
                .foregroundColor(.gray)
                .lineSpacing(5)
        }
    }
    
    private var bodyWeightInputSection: some View {
        HStack {
            Text("Body Weight")
            TextField("Enter your Weight (kg)", text: $weight)
                .font(.custom("SFPro-Regular", size: 17))
                .padding(12)
                .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                .cornerRadius(5)
            
            Button(action: {
                weight = "" // Clear the text field
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color.gray)
                    .padding(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(Color(red: 242/255, green: 242/255, blue: 247/255))
    }
    
    private var startButton: some View {
        NavigationLink(destination: NotificationPreferenceView(viewModel: viewModel), isActive: $isNavigatingToPreferences) {
            Button(action: {
                if let weightValue = Double(weight) {
                    viewModel.setBodyWeight(weightValue)
                    isNavigatingToPreferences = true
                }
            }) {
                Text("Start")
                    .font(.custom("SFPro-Regular", size: 17))
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 50/255, green: 173/255, blue: 230/255))
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle()) // Ensure button style is applied
        }
    }
    
    private var feedbackSection: some View {
        Text(feedback)
            .foregroundColor(.red)
            .padding(.top, 10)
            .opacity(feedback.isEmpty ? 0 : 1) // Show/hide based on feedback
    }
}

struct WeightInputView_Previews: PreviewProvider {
    static var previews: some View {
        WeightInputView()
    }
}
