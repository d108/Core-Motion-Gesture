/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

protocol MotionEventViewRunnable
{
    var monitoringButtonState: MonitoringButtonState { get set }
    func updateDoubleShaked(doubleShaked: Bool)
    func pressTestError()
    func setMonitoringButtonState(monitoringButtonState: MonitoringButtonState)
}

extension MotionEventViewModel: MotionEventViewRunnable
{
    func updateDoubleShaked(doubleShaked: Bool)
    {
        self.doubleShaked = doubleShaked
    }

    func pressTestError()
    {
        motionDetector
            .motionEventStream?.sendMotionError(error: .testError)
    }

    func setMonitoringButtonState(monitoringButtonState: MonitoringButtonState)
    {
        self.monitoringButtonState = monitoringButtonState
    }
}
