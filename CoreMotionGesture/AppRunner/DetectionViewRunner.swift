import Foundation
import Combine

// Getting a DetectorsViewModel doesn't work through the environment object when we need
// it at init time. However, we don't need it here because of the explanation below.
//
// View generation using resetDetectorViewIDForError() in DetectorsViewModel interferes
// with the testing process. We start getting an overrun of views associated with the
// TabViewRunner.
class DetectionViewRunner: AppRunnerProtocol
{
    let errorClearDeadline: DispatchTime = .now() + 1
    var cancellables = Set<AnyCancellable>()
    let motionEventViewModel: MotionEventViewModel

    init(
        motionEventViewModel: MotionEventViewModel
    )
    {
        self.motionEventViewModel = motionEventViewModel
    }

    func cancelAll()
    {
        cancellables = Set<AnyCancellable>()
    }

    func runDetectionView()
    {
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
                {
                    self.motionEventViewModel.doubleShaked = false
                }
            })
            .store(in: &cancellables)
        let timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
        timer.sink
        { _ in
            var isMonitoring = self.motionEventViewModel.monitoringButtonState == .started
            if EventDecider.randomInPercent(percent: 0.1)
            {
                self.motionEventViewModel.motionDetector
                    .motionEventStream?.sendMotionError(error: .testError)
                DispatchQueue.main.asyncAfter(deadline: self.errorClearDeadline)
                {
                    // Not causing view regeneration here is necessary to prevent unwanted
                    // TabViewRunner instances. Therefore, we have disabled the following
                    // code.
                    //    self.detectorsViewModel.resetDetectorViewIDForError(
                    //        axis: self.motionEventViewModel.motionDetector.monitorAxis
                    //    )
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
                // We should not create a new view using the detectors view model
                // according to the following code.
                //     self.detectorsViewModel.resetDetectorViewIDForError(
                //         axis:  self.motionEventViewModel.motionDetector.monitorAxis
                //     )
            }
        }
            .store(in: &cancellables)
    }
}
