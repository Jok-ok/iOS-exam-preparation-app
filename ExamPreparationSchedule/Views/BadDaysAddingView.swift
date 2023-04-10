import SwiftUI

struct BadDaysAddingView: View {
    @State var badDays = Set<DateComponents>()
    @State var viewModel = ExamScheduleViewModel()
    
    var body: some View {
        VStack { Text("Выберите неподходящие для подготовки дни")
            MultiDatePicker("Выберите неподходящие для подготовки дни", selection: $badDays, in: .now...)
        }
    }
}

struct BadDaysAddingView_Previews: PreviewProvider {
    static var previews: some View {
        BadDaysAddingView()
    }
}
