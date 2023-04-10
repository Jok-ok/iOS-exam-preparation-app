import SwiftUI

struct QuestionAddingView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ExamScheduleViewModel
    @State var examIndex: Int
    
    var body: some View {
        List {
            Section(footer:
                        Button("Продолжить", action: { dismiss() })
                .buttonStyle(.borderless)
                .font(Font(CTFont(.system, size: 24)))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()){
                    ForEach($viewModel.exams[examIndex].questions, id: \.id) { question in
                        QuestionInputView(question: question)
                    }
                    .onDelete(perform: viewModel.deleteQuestion(for: examIndex))
                }
        }
        .toolbar {
            Button("Добавить", action: { viewModel.addQuestion(to: examIndex) })
        }
        .navigationTitle("\(viewModel.exams[examIndex].name)")
    }
}

struct QuestionAddingView_Previews: PreviewProvider {
    static var previews: some View {
        ExamInfosAddingView()
    }
}
