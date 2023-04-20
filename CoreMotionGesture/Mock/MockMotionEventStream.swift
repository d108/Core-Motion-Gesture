import Foundation
import Combine

struct MockMotionEventStream: MotionEventStreamProtocol
{
    var motionEventPublisher: AnyPublisher<MotionEvent, Never>?

    func sendMotionEvent(event: MotionEvent)
    {
        // dummy implementation
    }
}
