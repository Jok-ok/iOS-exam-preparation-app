import Foundation

struct ExamQuestion: Identifiable, Equatable, Hashable {
    var num: Int
    var text: String
    var timeToLearn: Int
    var id = UUID()
}
