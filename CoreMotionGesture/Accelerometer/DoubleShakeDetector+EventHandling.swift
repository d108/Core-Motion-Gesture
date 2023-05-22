/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import CoreMotion

extension DoubleShakeDetector
{
    func sendMotionEvent()
    {
        var event: MotionEvent = .none

        switch monitorAxis
        {
        case .x: event = .doubleXShake
        case .y: event = .doubleYShake
        case .z: event = .doubleZShake
        }

        if !axisMatchesEvent(motionEvent: event)
        {
            sendMotionError(error: .mismatchedAxis)
        }
        if let motionEventStream = motionEventStream
        {
            motionEventStream.sendMotionEvent(event: event)
        }
        else
        {
            fatalError(fatalErrorText)
        }
    }

    func sendMotionError(
        error: MotionError,
        description: String = ""
    )
    {
        stopMonitoring()
        motionEventStream?.sendMotionError(error: error)
    }

    private func axisMatchesEvent(motionEvent: MotionEvent) -> Bool
    {
        var matches = true

        switch motionEvent
        {
        case .doubleXShake: matches = monitorAxis == .x
        case .doubleYShake: matches = monitorAxis == .y
        case .doubleZShake: matches = monitorAxis == .z
        case .none: break
        }

        return matches
    }

    private func sendMotionError(motionError: MotionError)
    {
        motionEventStream?.sendMotionError(error: motionError)
    }
}
