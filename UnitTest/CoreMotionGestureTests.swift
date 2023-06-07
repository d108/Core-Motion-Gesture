/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import CoreMotion
import XCTest
@testable import CoreMotionGesture

final class CoreMotionGestureTests: XCTestCase
{
    func test_detector_creation() throws
    {
        let motionManager = CMMotionManager()
        let motionEventStream = MockMotionEventStream()
        MonitorAxis.allCases.forEach
        {
            _ = DoubleShakeDetector(
                motionManager: motionManager,
                monitorAxis: $0,
                motionEventStream: motionEventStream
            )
        }
    }
}
