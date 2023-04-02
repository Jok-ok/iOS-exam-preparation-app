import Foundation

struct Exam: Identifiable, Equatable, Hashable {
    var name: String
    var dateTime: Date
    var id = UUID()
    var questions = [ExamQuestion]()
}
