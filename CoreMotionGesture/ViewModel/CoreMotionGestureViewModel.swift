import Foundation
import Combine

protocol MotionDetectorHandlerProtocol
{
    func handleMonitoring(buttonState: MonitoringButtonState)
}

final class CoreMotionGestureViewModel: ObservableObject, MotionDetectorHandlerProtocol
{
    @Published var motionEvent: MotionEvent
    @Published var doubleZShaked: Bool
    @Published var monitoringButtonState: MonitoringButtonState
    let motionDetector: DoubleShakeDetectorProtocol
    let waveImageDelay: TimeInterval = 1.5
    var cancellables = [AnyCancellable]()

    init(motionDetector: DoubleShakeDetectorProtocol)
    {
        self.motionEvent = .none
        self.doubleZShaked = false
        self.monitoringButtonState = .started
        self.motionDetector = motionDetector
        self.handleStreamEvents()
    }

    func handleMonitoring(buttonState: MonitoringButtonState)
    {
        switch buttonState
        {
        case .started: motionDetector.startMonitoring()
        case .notStarted: motionDetector.stopMonitoring()
        }
    }

    func handleStreamEvents()
    {
        motionDetector.motionEventStream?.motionEventPublisher?
            .receive(on: DispatchQueue.main)
            .sink
        { motionEvent in
            self.doubleZShaked = true
            DispatchQueue.main.asyncAfter(deadline: .now() + self.waveImageDelay)
            {
                self.doubleZShaked = false
            }
        }
            .store(in: &cancellables)
    }
}
