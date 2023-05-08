import SwiftUI
import CoreMotion

@main
struct CoreMotionGestureApp: App
{
    let hapticGenerator: HapticGeneratorProtocol
    let userTabStorage: UserTabStorageProtocol
    let defaults = UserDefaults.standard

    init()
    {
        self.hapticGenerator = HapticGenerator(
            generator: UINotificationFeedbackGenerator()
        )
        self.userTabStorage = UserTabStorage(defaults: defaults)
    }

    var body: some Scene
    {
        WindowGroup
        {
            ContentView(
                hapticGenerator: hapticGenerator,
                userTabStorage: userTabStorage
            )
        }
    }
}
