import Foundation
import Combine

class TabViewRunner: AppRunnerProtocol
{
    var cancellables = Set<AnyCancellable>()
    let tabSelectionViewModel: TabSelectionViewModel
    let delay: TimeInterval = 2

    init(
        tabSelectionViewModel: TabSelectionViewModel,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    )
    {
        self.tabSelectionViewModel = tabSelectionViewModel
        self.cancellables = cancellables
    }

    func cancelAll()
    {
        cancellables = Set<AnyCancellable>()
    }

    func switchTabs()
    {
        let tabSwitcher = PassthroughSubject<MonitorAxisTab, Never>()
        tabSwitcher
            .sink(receiveValue:
            { tab in
                print("◻️tab \(tab)")
                self.tabSelectionViewModel.selectedTab = tab
            })
            .store(in: &cancellables)
        var tabs = MonitorAxisTab.allCases
        let timer = Timer.publish(every: delay, on: .main, in: .common)
            .autoconnect()
        timer.sink
        { _ in
            if tabs.count > 0
            {
                tabSwitcher.send(tabs.remove(at: 0))
            } else
            {
                tabs = MonitorAxisTab.allCases
                // We don't finish here with the following code:
                //     tabSwitcher.send(completion: .finished)
                // It is an intentional decision matching our app's design state.
            }
        }
            .store(in: &cancellables)
    }
}
