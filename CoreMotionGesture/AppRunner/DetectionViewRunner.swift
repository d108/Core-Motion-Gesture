import Foundation
import Combine

// Getting DetectorsViewModel doesn't work through the environment object
// due to Variable 'self.detectionViewRunner' used before being initialized
class DetectionViewRunner: AppRunnerProtocol
{
    var cancellables = Set<AnyCancellable>()
    let motionEventViewModel: MotionEventViewModel
//    let detectorsViewModel: DetectorsViewModel

    init(
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        motionEventViewModel: MotionEventViewModel
//        detectorsViewModel: DetectorsViewModel
    )
    {
        self.cancellables = cancellables
        self.motionEventViewModel = motionEventViewModel
//        self.detectorsViewModel = detectorsViewModel
    }

    func cancelAll()
    {
        cancellables = Set<AnyCancellable>()
    }

    func runDetectionView()
    {
        var isMonitoring = motionEventViewModel.monitoringButtonState == .started
        let buttonPresser = PassthroughSubject<ButtonPress, Never>()
        buttonPresser
            .sink(receiveValue:
            { event in
                print("press \(event)")
                if self.motionEventViewModel.monitoringButtonState == .started
                {
                    if EventDecider.randomInPercent(percent: 0.8)
                    {
                        self.motionEventViewModel.doubleShaked = true
                    }
                } else
                { self.motionEventViewModel.doubleShaked = false }
            })
            .store(in: &cancellables)
        let timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
        timer.sink
        { _ in
            if EventDecider.randomInPercent(percent: 0.1)
            {
                self.motionEventViewModel.motionDetector
                    .motionEventStream?.sendMotionError(error: .testError)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                {
                    // TODO: Clear the error
                    // detectorsViewModel.resetDetectorViewIDForError(axis: axis)
                }
            }
            if EventDecider.randomInPercent(percent: 0.6)
            {
                isMonitoring.toggle()
            }
            if isMonitoring
            {
                self.motionEventViewModel.monitoringButtonState = .started
                buttonPresser.send(1)
            } else
            {
                self.motionEventViewModel.monitoringButtonState = .notStarted
                buttonPresser.send(completion: .finished)
                // TODO: Create a new view using the detectors view model
            }
        }
            .store(in: &cancellables)
    }
}
