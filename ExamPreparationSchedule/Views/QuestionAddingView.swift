import SwiftUI

struct QuestionAddingView: View {
    @ObservedObject var viewModel: ExamScheduleViewModel
    private var choosenExamIndex: Int
    
    init(viewModel: ExamScheduleViewModel, choosenExam: Exam) {
        self.viewModel = viewModel
        viewModel.setChoosenExam(choosenExam)
        choosenExamIndex = viewModel.exams.firstIndex(of: choosenExam) ?? 0

    }
    
    var body: some View {
        List {
            ForEach($viewModel.exams[choosenExamIndex].questions.indices, id: \.self) { index in
                QuestionInputView(question: $viewModel.exams[choosenExamIndex].questions[index])
            }
        }
        .navigationTitle(viewModel.exams[choosenExamIndex].name)
        .toolbar {
            Button("Добавить") {
                viewModel.addQuestion()
            }
        }
    }
}

struct QuestionAddingView_Previews: PreviewProvider {
    static var previews: some View {
        ExamInfosAddingView()
    }
}
