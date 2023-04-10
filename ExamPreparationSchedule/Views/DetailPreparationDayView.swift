import SwiftUI

struct DetailPreparationDayView: View {
    @Binding var preparationDay: PreparationDay
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "ru")
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        
        return formatter
    }()
    private var dayType: String {
        if preparationDay.isBadDay {
            return "Другие планы"
        }
        if preparationDay.isExamDay {
            return "Дата экзамена"
        }
        if preparationDay.examQuestions.isEmpty {
            return "День свободен"
        }
        return "Нужно готовиться"
    }
    
    var body: some View {
        List {
            Section(content: {
                ForEach($preparationDay.examQuestions) { examQuestion in
                    VStack{
                        Text("Вопрос №\(examQuestion.num.wrappedValue)")
                            .bold()
                        Divider()
                        HStack {
                            Text("На подготовку уйдет:")
                            Spacer()
                            Text("\(examQuestion.timeToLearn.wrappedValue) минут")
                                .bold()
                        }
                    }
                }
            }, header: {
                HStack {
                    Text("Дата: ")
                    Spacer()
                    Text(preparationDay.day.formatted())
                }
                HStack {
                    Text(dayType)
                }
            }){
            }
        }
        .navigationTitle("Дата \(preparationDay.day, formatter: formatter)")
    }
}

