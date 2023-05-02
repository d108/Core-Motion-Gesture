import SwiftUI
import CoreMotion

@main
struct CoreMotionGestureApp: App
{
    let motionManager: CMMotionManager
    let motionDetector: DoubleShakeDetectorProtocol
    let hapticGenerator: HapticGeneratorProtocol

    init()
    {
        self.motionManager = CMMotionManager()
        self.motionDetector = DoubleShakeDetector(
            motionManager: motionManager,
            monitorAxis: .z
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
                    motionDetector: motionDetector
                )
            )
        }
    }
}
