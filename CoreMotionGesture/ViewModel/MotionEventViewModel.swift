import Foundation
import Combine

protocol MotionDetectorHandlerProtocol
{
    func handleMonitoring(buttonState: MonitoringButtonState)
}

final class MotionEventViewModel:
    ObservableObject,
    MotionDetectorHandlerProtocol,
    MotionEventViewModelErrorAlertProtocol
{
    @Published var motionEvent: MotionEvent
    @Published var doubleShaked: Bool
    @Published var monitoringButtonState: MonitoringButtonState
    @Published var motionErrors: [LocalizedError]?
    @Published var showErrorAlert: Bool = false
    private var _errorAlert: ErrorAlert?
    var errorAlert: ErrorAlert?
    {
        get { return _errorAlert }
        set
        {
            _errorAlert = newValue
            if _errorAlert != nil { showErrorAlert = true }
            else { showErrorAlert = false }
        }
    }
    let motionDetector: DoubleShakeDetectorProtocol
    let waveImageDelay: TimeInterval = 1.5
    let unknownErrorText = "⚠️ Unknown Error: Should Not Be Seen"
    let fatalErrorText = "Missing Publisher: Should Not Happen"
    var cancellables = [AnyCancellable]()

    init(motionDetector: DoubleShakeDetectorProtocol)
    {
        self.motionEvent = .none
        self.doubleShaked = false
        self.monitoringButtonState = .notStarted
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
        guard let motionEventStream = motionDetector.motionEventStream,
            let motionEventPublisher = motionEventStream.motionEventPublisher
            else { fatalError(fatalErrorText) }
        motionEventPublisher
            .sink(
            receiveCompletion:
            { completion in
                switch completion
                {
                case .finished: break
                case .failure(let motionError):
                    self.errorAlert = ErrorAlert(message: motionError.failureReason ??
                        self.unknownErrorText)
                    self.appendMotionError(motionError: motionError)
                }
            }, receiveValue: { motionEvent in
                self.doubleShaked = true
                DispatchQueue.main.asyncAfter(deadline: .now() + self.waveImageDelay)
                {
                    self.doubleShaked = false
                }
            })
            .store(in: &cancellables)
    }

    func appendMotionError(motionError: MotionError)
    {
        monitoringButtonState = .notStarted
        if motionErrors == nil
        {
            motionErrors = [MotionError]()
        }
        motionErrors?.append(motionError)
    }
}
