/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import Combine
import Foundation

struct MockMotionEventStream: MotionEventStreamProtocol
{
    var motionEventPublisher: AnyPublisher<MotionEvent, MotionError>?

    func sendMotionEvent(event _: MotionEvent)
    {
        // dummy implementation
    }

    func sendMotionError(error _: MotionError)
    {
        // dummy implementation
    }
}
