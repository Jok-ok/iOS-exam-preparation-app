import Foundation

struct PreparationDay: Identifiable, Equatable, Hashable {
    let id = UUID()
    var day: Date
    var preparationInterval: TimeIntervalForPreparation
    var isBadDay: Bool
    var examQuestions: [ExamQuestion]
    var isExamDay: Bool = false
}
