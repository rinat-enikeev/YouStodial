import SwiftUI

struct StepperView: View {
    var totalSteps: Int
    var currentStep: Int
    var color: Color

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Rectangle()
                    .fill(index == currentStep ? color : Color(UIColor.lightGray))
                    .frame(width: index == currentStep ? 40 : 20, height: 4)
                    .cornerRadius(2)
            }
        }
        .padding()
    }
}
