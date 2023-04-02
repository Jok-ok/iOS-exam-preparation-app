import SwiftUI

struct ExamInfosAddingView: View {
    @ObservedObject var viewModel = ExamScheduleViewModel()
    @State var canMoveNext: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section(footer: NavigationLink(destination: ChooseQuestionExamView(viewModel: viewModel)){ Text("Продолжить")
                        .font(Font(CTFont(.system, size: 24)))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }){
                    ForEach($viewModel.exams.indices, id: \.self) { index in
                        ExamInputView(exam: $viewModel.exams[index])
                    }.onDelete(perform: viewModel.deleteExam)
                }
            }.listStyle(.insetGrouped)
                .background(.white)
                .navigationTitle("Дисциплины")
            
                .toolbar {
                    Button("Добавить", action: viewModel.addExam)
                }
        }
    }
}

struct ExamInfosAddingView_Previews: PreviewProvider {
    static var previews: some View {
        ExamInfosAddingView()
    }
}
