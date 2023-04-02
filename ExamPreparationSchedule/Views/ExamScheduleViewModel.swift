import Foundation

class ExamScheduleViewModel: ObservableObject {
    @Published var exams = [Exam(name: "", dateTime: .now)]
    var choosenExam: Exam?
    @Published var averageTimeToQuestion: Double = 30
    @Published var workWithoutRestTime: Double = 120
    @Published var timeToRest: Double = 30
    @Published var badDays = [Date]()
    @Published var timeInterval = TimeIntervalForPreparation()
    
    public func setChoosenExam(_ exam: Exam) {
        choosenExam = exam
    }
    
    public func deleteExam(at offset: IndexSet) {
        exams.remove(atOffsets: offset)
    }
    
    public func addExam() {
        exams.append(Exam(name: "", dateTime: .now))
    }
    
    public func addQuestion() {
        guard let choosenExam = choosenExam,
            let index = exams.firstIndex(of: choosenExam) else { return }
        exams[index].questions.append(ExamQuestion(num: exams[index].questions.count+1 , text: "", timeToLearn: 30))
    }
    
    public func deleteQuestion(at offset: IndexSet) {
        guard let choosenExam = choosenExam,
            let index = exams.firstIndex(of: choosenExam) else { return }
        exams[index].questions.remove(atOffsets: offset)
    }
    
    public func checkExamNames() -> Bool {
        if exams.count == 0 {
            return false
        }
        for i in 0..<exams.count - 1  {
            if exams[(i+1)...].contains(where: {exams[i].name == $0.name}) {
                print(exams[i].name)
                return false
            }
        }
        return true
    }
    
    //TODO: - CheckFunc
    public func checkExamQuestions() {
        //
    }
}
