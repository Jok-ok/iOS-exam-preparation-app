import SwiftUI

struct QuestionInputView: View {
    @Binding var question: ExamQuestion
    
    var body: some View {
        VStack {
            Text("Вопрос №\(question.num)")
                .bold()
            TextField("Текст вопроса...", text: $question.text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Stepper(value: $question.timeToLearn, step: 5) {
                VStack {
                    Text("На подготовку вопроса уйдет")
                        .font(.footnote)
                    Text("\(question.timeToLearn)")
                        .bold()
                    Text("минут")
                        .font(.footnote)
                }
            }
        }
    }
}
