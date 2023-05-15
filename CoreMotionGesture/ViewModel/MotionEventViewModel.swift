import Foundation
import Combine

// We can eventually process multiple errors.
protocol MotionEventViewModelErrorAlertProtocol
{
    var showErrorAlert: Bool { get set }
    var motionErrors: [LocalizedError]? { get }
}

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
    let fatalErrorText = "Missing Publisher: Should Not Happen"
    var cancellables = Set<AnyCancellable>()

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
                        Setting.unknownErrorText)
                    self.appendMotionError(motionError: motionError)
                }
            }, receiveValue: { motionEvent in
                self.doubleShaked = true
                DispatchQueue.main.asyncAfter(deadline: .now() + Setting.waveImageDelay)
                {
                    self.doubleShaked = false
                }
                // Our data stream is designed to receive events continuously, but it completes on
                // an error, according to the Publisher contract. The timing of responses to state
                // changes is also crucial. We have a published property called `doubleShaked`,
                // which is a Bool that toggles with a predefined delay. As a result, multiple
                // events that occur within this window will not trigger extra user interface
                // responses.
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
