/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import Combine
import Foundation

protocol MotionEventStreamProtocol
{
    var motionEventPublisher: AnyPublisher<MotionEvent, MotionError>? { get }
    func sendMotionEvent(event: MotionEvent)
    func sendMotionError(error: MotionError)
}

struct MotionEventStream: MotionEventStreamProtocol
{
    var motionEventPublisher: AnyPublisher<MotionEvent, MotionError>?
    private var motionEventPassthroughSubject =
        PassthroughSubject<MotionEvent, MotionError>()

    init()
    {
        motionEventPublisher = motionEventPassthroughSubject
            .eraseToAnyPublisher()
    }

    func sendMotionEvent(event: MotionEvent)
    {
        motionEventPassthroughSubject.send(event)
    }

    func sendMotionError(error: MotionError)
    {
        motionEventPassthroughSubject.send(completion: .failure(error))
    }
}
