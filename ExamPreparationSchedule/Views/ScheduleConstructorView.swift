import SwiftUI

struct ScheduleConstructorView: View {
    @ObservedObject var viewModel: ExamScheduleViewModel
    @State var checkSuccess: Bool = false
    
    var body: some View {
        ScrollView {
            if checkSuccess {
                successBody
            }
            else {
                noSuccessBody
            }
        }
        .navigationDestination(for: PreparationDay.self) { preparationDay in
        }
        .onAppear {
            checkSuccess = viewModel.checkPossibilityPreparation()
        }
        .navigationTitle("График")
    }
    private var successBody: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            ForEach($viewModel.preparationDays) { preparationDay in
                    NavigationLink(destination: DetailPreparationDayView(preparationDay: preparationDay)) {
                        PreparationDayView(preparationDay: preparationDay)
                }
            }
        }.padding()
    }
    private var noSuccessBody: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("К сожалению, построить график с заданными параметрами не удалось.")
            Text("Можете попробовать:")
            Text("Изменить параметры расписания")
            Text("Уменьшить количество вопросов, оставив только основные")
            Text("Изменить количество дней, непохдящих для подготовки к экзаменам")
        }
    }
}

struct ScheduleConstructorView_Previews: PreviewProvider {
    static var previews: some View {
        ExamInfosAddingView()
    }
}
