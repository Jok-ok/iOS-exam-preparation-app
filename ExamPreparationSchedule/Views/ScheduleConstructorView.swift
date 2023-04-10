import SwiftUI

struct ScheduleConstructorView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ExamScheduleViewModel
    @State var checkSuccess: Bool = false
    
    var body: some View {
        ScrollView {
            successBody
        }.alert("Построить график не удалось. 😿", isPresented: $checkSuccess, actions: {Button("Изменить параметры") {dismiss()}}, message: {noSuccessBody})
        .navigationDestination(for: PreparationDay.self) { preparationDay in
        }
        .onAppear {
            checkSuccess = !viewModel.checkPossibilityPreparation()
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
        Text("Можете попробовать:\n1. Изменить параметры расписания\n2. Уменьшить количество вопросов, оставив только основные\n3. Изменить количество дней, неподходящих для подготовки к экзаменам")
    }
}

struct ScheduleConstructorView_Previews: PreviewProvider {
    static var previews: some View {
        ExamInfosAddingView()
    }
}
