//
//  ChooseQuestionExamView.swift
//  ExamPreparationSchedule
//
//  Created by Александр Воробей on 02.04.2023.
//

import SwiftUI

struct ChooseQuestionExamView: View {
    @ObservedObject var viewModel: ExamScheduleViewModel
    
    var body: some View {
            List {
                Section("Выберите экзамен, к которому хотите добавить вопросы"){
                    ForEach($viewModel.exams.indices, id:\.self) { index in
                        NavigationLink(destination: QuestionAddingView(viewModel: viewModel, choosenExam: viewModel.exams[index])) {
                            Text(viewModel.exams[index].name)
                        }
                    }
                }
            }
            .navigationTitle("Экзамены")
    }
}

struct ChooseQuestionExamView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseQuestionExamView(viewModel: ExamScheduleViewModel())
    }
}
