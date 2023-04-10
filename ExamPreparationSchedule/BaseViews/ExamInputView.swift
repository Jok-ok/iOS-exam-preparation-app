import SwiftUI

struct ExamInputView: View {
    @Binding var exam: Exam
    var onChangeSubmitHandler: (() -> Void)?
    
    var body: some View {
        VStack {
            TextField("Введите название дисциплины", text: $exam.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Укажите дату и время экзамена:")
            DatePicker("", selection: $exam.dateTime, in: Calendar.current.date(byAdding: .day, value: 1, to: .now)!...)
                .labelsHidden()
                .environment(\.locale, Locale.init(identifier: "ru"))
        }
    }
}
