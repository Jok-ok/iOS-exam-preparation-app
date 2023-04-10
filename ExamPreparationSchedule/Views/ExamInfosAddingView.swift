import SwiftUI

struct ExamInfosAddingView: View {
    @ObservedObject private var viewModel = ExamScheduleViewModel()

    
    var body: some View {
        NavigationStack {
            List {
                Section(footer: NavigationLink(destination: ChooseQuestionExamView(viewModel: viewModel)) { Text("Продолжить")
                        .font(Font(CTFont(.system, size: 24)))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }.simultaneousGesture(TapGesture().onEnded{
                    viewModel.sortExams()
                })){
                    ForEach($viewModel.exams.indices, id: \.self) { index in
                        ExamInputView(exam: $viewModel.exams[index])
                    }.onDelete(perform: { self.resignAnyFirstResponder()
                        viewModel.exams.remove(atOffsets: $0) })
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Дисциплины")
            .toolbar {
                Button("Добавить", action: viewModel.addExam)
            }
        }
    }
}

extension View {
    public func resignAnyFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
}

struct ExamInfosAddingView_Previews: PreviewProvider {
    static var previews: some View {
        ExamInfosAddingView()
    }
}
