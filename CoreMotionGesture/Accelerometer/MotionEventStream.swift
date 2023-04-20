import Foundation
import Combine

protocol MotionEventStreamProtocol
{
    var motionEventPublisher: AnyPublisher<MotionEvent, Never>? { get }
    func sendMotionEvent(event: MotionEvent)
}

struct MotionEventStream: MotionEventStreamProtocol
{
    var motionEventPublisher: AnyPublisher<MotionEvent, Never>?
    private var motionEventPassthroughSubject = PassthroughSubject<MotionEvent, Never>()

    init()
    {
        self.motionEventPublisher = self.motionEventPassthroughSubject.eraseToAnyPublisher()
    }

    func sendMotionEvent(event: MotionEvent)
    {
        motionEventPassthroughSubject.send(event)
    }
}
