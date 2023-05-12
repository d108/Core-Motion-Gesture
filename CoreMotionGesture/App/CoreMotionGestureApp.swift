import SwiftUI
import CoreMotion

enum AppError: LocalizedError
{
    case storageFailedToInitialize(String)

    var failureReason: String?
    {
        switch self
        {
        case .storageFailedToInitialize(let suiteName):
            return "🚨UserDefaults with suite name \(suiteName) failed to initialize."
        }
    }
}

@main
struct CoreMotionGestureApp: App
{
    let hapticGenerator: HapticGeneratorProtocol
    let userTabStorage: UserTabStorageProtocol
    let tabSelectionViewModel: TabSelectionViewModel

    init()
    {
        self.hapticGenerator = HapticGenerator(
            generator: UINotificationFeedbackGenerator()
        )
        guard let defaults = UserDefaults.group else
        {
            fatalError(
                AppError
                    .storageFailedToInitialize(Setting.suiteName)
                    .failureReason ??
                Setting.unknownErrorText
            )
        }
        self.userTabStorage = UserTabStorage(defaults: defaults)
        self.tabSelectionViewModel = TabSelectionViewModel(defaults: defaults)
    }

    var body: some Scene
    {
        WindowGroup
        {
            ContentView(
                hapticGenerator: hapticGenerator,
                tabSelectionViewModel: tabSelectionViewModel
            )
        }
    }
}
