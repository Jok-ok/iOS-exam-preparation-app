import SwiftUI

struct LineStepperView: View {
    @Binding var value: Int
    var prompt: String
    var step: Int
    
    var body: some View {
        HStack {
            Text(prompt)
            Spacer()
            Text("\(value)")
                .bold()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
            Stepper("", value: $value, step: step)
                .labelsHidden()
        }
    }
}

