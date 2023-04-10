import SwiftUI

struct PreparationScheduleConfigurationView: View {
    @ObservedObject var viewModel: ExamScheduleViewModel
    @State var showTimeIntervalAlert = false
    
    var body: some View {
        List {
            Section("Укажите часы в которые готовы заниматься") {
                HStack {
                    Picker("Начало", selection: $viewModel.timeInterval.from) {
                        ForEach(0..<24) { hour in
                            Text("\(hour)")
                        }
                    }
                    .pickerStyle(.automatic)
                    .onChange(of: viewModel.timeInterval) { newValue in
                        showTimeIntervalAlert = viewModel.timeIntervalsIsBad()
                    }
                    Picker("Конец", selection: $viewModel.timeInterval.to) {
                        ForEach(0..<24) { hour in
                            Text("\(hour)")
                        }
                    }
                    .pickerStyle(.automatic)
                }
            }
            Section("Укажите неподходящие для подготовки дни") {
                MultiDatePicker("", selection: $viewModel.badDays, in: .now..<viewModel.getLastExDateTime())
                
                    .environment(\.locale, Locale(identifier: "ru"))
            }
            Section(header: Text("Укажите продолжительность сеанса подготовки и время на отдых"), footer: NavigationLink(destination: ScheduleConstructorView(viewModel: viewModel)){ Text("Продолжить")
                    .font(Font(CTFont(.system, size: 24)))
                    .frame(maxWidth: .infinity, alignment: .center)
                .padding()}) {
                    LineStepperView(value: $viewModel.workWithoutRestTime, prompt: "Минут подготовки подряд", step: 10)
                    LineStepperView(value: $viewModel.timeToRest, prompt: "Минут на отдых", step: 5)
                }
            
        }
        .navigationTitle("Расписание")
        .alert("Неверный временной интервал", isPresented: $showTimeIntervalAlert, actions: {Button("Хорошо") { viewModel.setTimeIntervalToDefault() }}){
            Text("Время начала должно быть больше времени конца. Временной интервал будет сброшен к изначальным настройкам")
        }
    }
}

struct PreparationScheduleConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ExamInfosAddingView()
    }
}
