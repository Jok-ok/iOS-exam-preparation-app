import SwiftUI

struct PreparationDayView: View {
    @Binding var preparationDay: PreparationDay
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "ru")
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        
        return formatter
    }()
    private var color: Color {
        if preparationDay.isExamDay {
            return .red
        }
        if preparationDay.isBadDay || preparationDay.examQuestions.isEmpty {
            return .green
        }
        return .blue
    }
    
    private var note: String {
        if preparationDay.isExamDay {
            return "Экзамен"
        }
        if preparationDay.isBadDay || preparationDay.examQuestions.isEmpty {
            return "Отдых"
        }
        return "\(preparationDay.preparationInterval.from):00 - \(preparationDay.preparationInterval.to):00"
    }
    
    var body: some View {
        VStack {
            Text(preparationDay.day, formatter: formatter)
                .font(.title3)
                .bold()
            Divider()
                .frame(width: 125, height: 1)
                .background(Color.white)
            Text(note)
                .font(.body)
                .bold()
        }
        .padding()
        .foregroundColor(Color.white)
        .background(color)
        .cornerRadius(15)
        .shadow(radius: 4, x: 4, y: 4)
    }
}
