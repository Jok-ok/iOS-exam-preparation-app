import Foundation

class ExamScheduleViewModel: ObservableObject {
    @Published var exams = [Exam(name: "", dateTime: Calendar.current.date(byAdding: .day, value: 1, to: .now)!)]
    @Published var workWithoutRestTime: Int = 120
    @Published var timeToRest: Int = 30
    @Published var badDays = Set<DateComponents>()
    @Published var timeInterval = TimeIntervalForPreparation()
    @Published var preparationDays = [PreparationDay]()
    
    public func deleteExam(at offset: IndexSet) {
        exams.remove(atOffsets: offset)
    }
    
    public func getLastExDateTime() -> Date {
        exams.last?.dateTime ?? .now
    }
    
    public func sortExams() {
        exams.sort(by: {$0.dateTime < $1.dateTime})
    }
    
    public func addExam() {
        exams.append(Exam(name: "", dateTime: .now))
        exams.sort(by: {$0.dateTime < $1.dateTime})
    }
    
    public func addQuestion(to examIndex: Int) {
        exams[examIndex].questions.append(ExamQuestion(num: exams[examIndex].questions.count+1 , text: "", timeToLearn: 30))
    }
    
    public func deleteQuestion(for examIndex: Int) -> (IndexSet) -> Void{
        return { [weak self] index in
            guard let self = self else { return }
            self.exams[examIndex].questions.remove(atOffsets: index)
            self.exams[examIndex].questions.indices.forEach { questionIndex in
                self.exams[examIndex].questions[questionIndex].num = questionIndex + 1
            }
        }
    }
    
    public func checkPossibilityPreparation() -> Bool {
        // Считаем минуты, которые нам необходимо затратить на подготовку к вопросов к каждому экзамену
        var minutesToLearn = [Int]()
        for exam in exams {
            minutesToLearn.append(calculateTimeToLearnQuestions(for: exam))
        }
        // Считаем сколько минут, отведенных для изучения у нас есть без учета перерывов
        var minutesToLearnInDay = (timeInterval.to - timeInterval.from) * 60
        var clearWorkMinutes = 0
        
        // Считаем сколько минут у нас уйдет "чистыми" на работу с учетом перерывов
        while minutesToLearnInDay > 0 {
            // От минут отведенных для обучения в день отнимаем время на работу
            minutesToLearnInDay -= workWithoutRestTime
            clearWorkMinutes += workWithoutRestTime
            
            // Если перебор(число доступных минут в дне стало меньше нуля) то отнимаем это число от чистого времени на работу, чтобы убрать перебор и выходим из цикла
            if minutesToLearnInDay <= 0 {
                clearWorkMinutes += minutesToLearnInDay
                break
            }
            // Не забываем про отдых, он в "чистое рабочее время не идет"
            minutesToLearnInDay -= timeToRest
        }
        // Считаем дни, которые нам потребуются для изучения вопросов по каждому экзамену
        var daysToLearn = [Int]()
        // Возможный перебор
        var prof = 0
        
        for learn in minutesToLearn {
            var time = learn
            // Если перебор больше нуля то это время считается как рабочее, соответственно тоже уходит на подготовку вопросов
            if prof > 0 {
                time -= prof
                prof = 0
            }
            // Счетчик дней
            var dayCounter = 0
            // Пока время отведенное для изучения вопросов по экзамену не вышло
            while time > 0 {
                // Отнимаем от него по одному дню, увеличивая счетчик дней на этот экзамен на единицу с каждой итерацией
                time -= clearWorkMinutes
                dayCounter += 1
            }
            // О, вышли из цикла, значит мы отработали все минуты на вопросы...
            // ...И если вдруг привысили их...
            if time < 0 {
                // То складываем оставшееся время в "перевбор"
                prof = -time
            }
            // И добавляем количество дней в список
            daysToLearn.append(dayCounter)
        }
        
        // Теперь посчитаем дни, которые "выпадают" из промежутков между экзаменами для каждого промежутка
        var badDaysInSessionExamCount = [Int]()
        let badDays = Array(self.badDays)
        // ставим за точку начала промежутка текущую дату
        var lastExamDate = Date.now
        
        // берем дату следующего экзамена как конец промж
        for exam in exams {
            var badDaysCount = 0
            // теперь проверяем каждый плохой день
            for badDay in badDays {
                // если день входит в промежуток
                if (lastExamDate...exam.dateTime).contains(badDay.date!) {
                    // увеличиваем счетчик
                    badDaysCount += 1
                }
            }
            // добавляем подсчитанное в список
            badDaysInSessionExamCount.append(badDaysCount)
            // берем за начало точки осчета дату текущего экзамена
            lastExamDate = exam.dateTime
        }

        lastExamDate = Date.now
        for index in exams.indices {
            let daysInFactWeHave = Calendar.numberOfDaysBetween(lastExamDate, and: exams[index].dateTime)
            if daysInFactWeHave - badDaysInSessionExamCount[index] < daysToLearn[index] {
                return false
            }
        }
        calculateSchedule(daysToLearn: daysToLearn, clearWorkMinutes: clearWorkMinutes, badDaysInSessionExamCount: badDaysInSessionExamCount)
        return true
    }
    
    private func calculateTimeToLearnQuestions(for exam: Exam) -> Int {
        return exam.questions.reduce(0, { $0 + $1.timeToLearn })
    }
    
    private func calculateSchedule(daysToLearn: [Int], clearWorkMinutes: Int, badDaysInSessionExamCount: [Int]) {
        preparationDays = []
        let currExDate = Date.now
        let badDaysArray = badDays.map({ $0.date! })
        var lastExDate = getLastExDateTime()
        let daysBetween = Calendar.numberOfDaysBetween(currExDate, and: lastExDate)
        
        
        // Получаем перечисление дней и переворачиваем, чтобы подготовка происходила как можно ближе к экзаменам
        
        guard daysBetween > 1 else { return }
        let dateRange = (1...daysBetween).map({Calendar.current.date(byAdding: .day, value: $0, to: currExDate)}).reversed()
        
        // Расставляем плохие дни для подготовки
        for day in dateRange {
            guard let day = day else { return }
            let dayComponents = Calendar.current.dateComponents([.year, .month, .day], from: day)
            guard let date = Calendar.current.date(from: dayComponents) else { return }
            var preparationDay = PreparationDay(day: day, preparationInterval: timeInterval, isBadDay: false, examQuestions: [])
            if badDaysArray.contains(date) {
                preparationDay = PreparationDay(day: day, preparationInterval: timeInterval, isBadDay: true, examQuestions: [])
            }
            else {
                preparationDay = PreparationDay(day: day, preparationInterval: timeInterval, isBadDay: false, examQuestions: [])
            }
            preparationDays.append(preparationDay)
        }
        var dayIndex = 0
        lastExDate = .now
        for exam in exams.reversed() {
            // Также переворачиваем вопросы, чтобы подготовка происходила с конца
            var questions = Array(exam.questions.reversed())
            var clearWM = clearWorkMinutes
            while !questions.isEmpty {
                if preparationDays[dayIndex].isBadDay ||
                    (exam.dateTime <= preparationDays[dayIndex].day && preparationDays[dayIndex].day <= lastExDate) {
                    dayIndex += 1
                    continue
                }
                if clearWM == 0 {
                    clearWM = clearWorkMinutes
                    dayIndex += 1
                    continue
                }
                var question = questions.remove(at: 0)
                if question.timeToLearn > clearWM {
                    var tmpQuestion = question
                    tmpQuestion.timeToLearn = clearWM
                    preparationDays[dayIndex].examQuestions.append(tmpQuestion)
                    question.timeToLearn -= clearWM
                    questions.insert(question, at: 0)
                    clearWM = clearWorkMinutes
                    dayIndex += 1
                    continue
                }
                else {
                    clearWM -= question.timeToLearn
                }
                preparationDays[dayIndex].examQuestions.append(question)
            }
            lastExDate = exam.dateTime
        }
        for exam in exams {
            preparationDays.append(PreparationDay(day: exam.dateTime, preparationInterval: timeInterval, isBadDay: false, examQuestions: [], isExamDay: true))
        }
        preparationDays.sort(by: { $0.day < $1.day })
    }
    
    public func checkExamNames() -> Bool {
        if exams.count == 0 {
            return false
        }
        for i in 0..<exams.count - 1  {
            if exams[(i+1)...].contains(where: {exams[i].name == $0.name}) {
                return false
            }
        }
        return true
    }
    
    //TODO: - CheckFunc
    public func checkExamQuestions() {
        //
    }
    
    public func timeIntervalsIsBad() -> Bool {
        if timeInterval.from > timeInterval.to {
            return true
        }
        return false
    }
    
    public func setTimeIntervalToDefault() {
        timeInterval.from = 16
        timeInterval.to = 20
    }
}
