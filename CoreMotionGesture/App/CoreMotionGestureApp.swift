import SwiftUI
import CoreMotion

@main
struct CoreMotionGestureApp: App
{
    let hapticGenerator: HapticGeneratorProtocol

    init()
    {
        self.hapticGenerator = HapticGenerator(
            generator: UINotificationFeedbackGenerator()
        )
    }

    var body: some Scene
    {
        WindowGroup
        {
            ContentView(
                hapticGenerator: hapticGenerator
            )
        }
    }
}
