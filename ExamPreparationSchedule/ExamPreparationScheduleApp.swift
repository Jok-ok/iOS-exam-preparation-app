import SwiftUI

@main
struct ExamPreparationScheduleApp: App {
    var body: some Scene {
        WindowGroup {
            ExamInfosAddingView()
                .environment(\.locale, Locale(identifier: "ru"))
        }
    }
}
