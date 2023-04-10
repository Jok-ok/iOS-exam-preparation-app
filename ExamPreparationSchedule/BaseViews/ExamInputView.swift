import SwiftUI

struct ExamInputView: View {
    @Binding var exam: Exam
    var onChangeSubmitHandler: (() -> Void)?
    
    var body: some View {
        VStack {
            TextField("Введите название дисциплины", text: $exam.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Укажите дату и время экзамена:")
            DatePicker("", selection: $exam.dateTime)
                .labelsHidden()
                .environment(\.locale, Locale.init(identifier: "ru"))
        }
    }
}
