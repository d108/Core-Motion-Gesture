import XCTest
import CoreMotion
@testable import CoreMotionGesture

final class CoreMotionGestureTests: XCTestCase
{
    func test_detector_creation() throws
    {
        let motionManager = CMMotionManager()
        _ = DoubleZShakeDetector(motionManager: motionManager)
    }
}
