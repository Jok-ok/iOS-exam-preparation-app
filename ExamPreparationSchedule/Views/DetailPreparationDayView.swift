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
            return "Неподходящий для подготовки день"
        }
        if preparationDay.isExamDay {
            return "День экзамена"
        }
        if preparationDay.examQuestions.isEmpty {
            return "День свободен"
        }
        return "День для подготовки"
    }
    
    var body: some View {
        List {
            Text(dayType)
                .font(.title2)
                .bold()
            if !preparationDay.examQuestions.isEmpty {
                Section(header: Text("Вопросы, для подготовки")) {
                    ForEach($preparationDay.examQuestions) { examQuestion in
                        VStack(alignment: .leading){
                            HStack {
                                Text("Вопрос №\(examQuestion.num.wrappedValue) ")
                                    .bold()
                                Spacer()
                                Text("(\(examQuestion.timeToLearn.wrappedValue) минут)")
                                    .bold()
                            }
                            Divider()
                            Text(examQuestion.text.wrappedValue)
                                .font(.footnote)
                        }
                    }
                }
            }
        }
        .navigationTitle("\(preparationDay.day, formatter: formatter)")
    }
}

