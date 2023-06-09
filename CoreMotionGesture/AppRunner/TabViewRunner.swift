/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import Combine
import Foundation

final class TabViewRunner: TimeChangerProtocol
{
    typealias EventType = MonitorAxisTab

    var cancellables = Set<AnyCancellable>()
    var runnableViewModel: TabViewRunnable
    var subject = PassthroughSubject<EventType, Never>()
    let delay: TimeInterval = 3

    init(runnableViewModel: TabViewRunnable)
    {
        self.runnableViewModel = runnableViewModel
    }

    func cancelAll()
    {
        cancellables = Set<AnyCancellable>()
    }

    func runTimer()
    {
        subject
            .sink
            { tab in
                self.runnableViewModel.onTimeChange(tab: tab)
            }
            .store(in: &cancellables)

        var tabs = MonitorAxisTab.allCases
        let timer = Timer.publish(every: delay, on: .main, in: .common)
            .autoconnect()
        timer.sink
        { _ in
            if tabs.count <= 0
            {
                tabs = MonitorAxisTab.allCases
            }
            self.subject.send(tabs.remove(at: 0))
        }.store(in: &cancellables)
    }
}
