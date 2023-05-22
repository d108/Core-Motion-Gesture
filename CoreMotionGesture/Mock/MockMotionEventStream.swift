/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import Foundation
import Combine

struct MockMotionEventStream: MotionEventStreamProtocol
{
    var motionEventPublisher: AnyPublisher<MotionEvent, MotionError>?

    func sendMotionEvent(event: MotionEvent)
    {
        // dummy implementation
    }

    func sendMotionError(error: MotionError)
    {
        // dummy implementation
    }
}
