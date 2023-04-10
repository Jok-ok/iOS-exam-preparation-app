import SwiftUI

struct DetailPreparationDayView: View {
    @Binding var preparationDay: PreparationDay
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
        }.navigationTitle(preparationDay.day.formatted())
    }
}


//struct DetailPreparationDayView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailPreparationDayView(preparationDay: PreparationDay(day: .now,
//                                                                preparationInterval: TimeIntervalForPreparation(from: 10, to: 20),
//                                                                isBadDay: false,
//                                                                examQuestions: [ExamQuestion(num: 1, text: "Какой-то текст", timeToLearn: 30),
//                                                                                ExamQuestion(num: 1, text: "Какой-то текст", timeToLearn: 30),
//                                                                                ExamQuestion(num: 1, text: "Какой-то текст", timeToLearn: 30),
//                                                                                ExamQuestion(num: 1, text: "Какой-то текст", timeToLearn: 30),
//                                                                                ExamQuestion(num: 1, text: "Какой-то текст", timeToLearn: 30),
//                                                                                ExamQuestion(num: 1, text: "Какой-то текст", timeToLearn: 30)]))
//    }
//}
