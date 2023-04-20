import SwiftUI
import CoreMotion

@main
struct CoreMotionGestureApp: App
{
    let motionManager: CMMotionManager
    let motionDetector: DoubleZShakeDetectorProtocol
    let hapticGenerator: HapticGeneratorProtocol

    init()
    {
        self.motionManager = CMMotionManager()
        self.motionDetector = DoubleZShakeDetector(
            motionManager: motionManager
        )
        self.hapticGenerator = HapticGenerator(
            generator: UINotificationFeedbackGenerator()
        )
    }

    var body: some Scene
    {
        WindowGroup
        {
            ContentView(
                hapticGenerator: hapticGenerator,
                motionEventViewModel: CoreMotionGestureViewModel(
                    motionDetector: DoubleZShakeDetector(
                        motionManager: CMMotionManager()
                    )
                )
            )
        }
    }
}
