// SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
// SPDX-License-Identifier: MIT License

import Foundation
import Combine

final class MotionEventViewRunner: TimeChangerProtocol
{
    typealias EventType = ButtonPress

    var cancellables = Set<AnyCancellable>()
    var runnableViewModel: MotionEventViewRunnable
    var subject = PassthroughSubject<EventType, Never>()
    let delay: TimeInterval = 1

    init(runnableViewModel: MotionEventViewRunnable)
    {
        self.runnableViewModel = runnableViewModel
    }

    func cancelAll()
    {
        cancellables = Set<AnyCancellable>()
    }

    // While the subject below is not strictly needed, it serves to decouple double shake
    // event simulation from the timer.
    func runTimer()
    {
        subject
            .sink(receiveValue:
            { event in
                print("press \(event)")
                self.simulateDoubleShaked(with: 0.8)
            })
            .store(in: &cancellables)

        let timer = Timer.publish(every: delay, on: .main, in: .common)
            .autoconnect()
        timer.sink
        { _ in
            var isMonitoring = false
            if EventDecider.random(with: 0.1)
            {
                self.runnableViewModel.pressTestError()

                // Not causing view regeneration here is necessary to prevent unwanted
                // TabViewRunner instances. Therefore, we have disabled the following
                // code:
                // DispatchQueue.main.asyncAfter(deadline: self.errorClearDeadline)
                // {
                //    self.detectorsViewModel.resetDetectorViewIDForError(
                //        axis: self.motionEventViewModel.motionDetector.monitorAxis
                //    )
                // }
            }
            if EventDecider.random(with: 0.6)
            {
                isMonitoring.toggle()
            }
            if isMonitoring
            {
                self.runnableViewModel.setMonitoringButtonState(monitoringButtonState: .started)
                self.subject.send(1)
            } else
            {
                self.runnableViewModel.setMonitoringButtonState(monitoringButtonState: .notStarted)
                self.subject.send(completion: .finished)

                // We should not create a new view using the detectors view model
                // according to the following code.
                //     self.detectorsViewModel.resetDetectorViewIDForError(
                //         axis:  self.motionEventViewModel.motionDetector.monitorAxis
                //     )
            }
        }.store(in: &cancellables)
    }

    private func simulateDoubleShaked(with probability: Probability)
    {
        if self.runnableViewModel.monitoringButtonState == .started
        {
            if EventDecider.random(with: 0.8)
            {
                self.runnableViewModel.updateDoubleShaked(doubleShaked: true)
            }
        } else
        {
            self.runnableViewModel.updateDoubleShaked(doubleShaked: false)
        }
    }
}
