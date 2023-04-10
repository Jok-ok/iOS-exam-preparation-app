import SwiftUI

struct ChooseQuestionExamView: View {
    @ObservedObject var viewModel: ExamScheduleViewModel
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "ru")
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Выберите экзамены к которым хотите добавить вопросы"),
                        footer: NavigationLink(destination: PreparationScheduleConfigurationView(viewModel: viewModel))
                        {
                    Text("Продолжить")
                        .font(Font(CTFont(.system, size: 24)))
                        .frame(maxWidth: .infinity, alignment: .center)
                    .padding()}) {
                    ForEach ($viewModel.exams.indices, id: \.self) { index in
                        NavigationLink(destination: QuestionAddingView(viewModel: viewModel, examIndex: index))
                        {
                            HStack {
                                VStack(alignment: .leading){
                                    Text(viewModel.exams[index].name)
                                    Text("\(viewModel.exams[index].dateTime, formatter: formatter)")
                                        .environment(\.locale, Locale.init(identifier: "ru"))
                                        .font(Font.footnote)
                                        .foregroundColor(Color.gray)
                                }
                                Spacer()
                                Text("\(viewModel.exams[index].questions.count)")
                                    .foregroundColor(Color.gray)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Экзамены")
    }
}

struct ChooseQuestionExamView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseQuestionExamView(viewModel: ExamScheduleViewModel())
    }
}
