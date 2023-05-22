/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

struct MockMotionDetector: DoubleShakeDetectorProtocol
{
    var monitorAxis: MonitorAxis
    var motionEventStream: MotionEventStreamProtocol?

    func startMonitoring()
    {
        // dummy implementation
    }

    func stopMonitoring()
    {
        // dummy implementation
    }
}
