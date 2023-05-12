import SwiftUI

typealias MonitorAxisTab = MonitorAxis

protocol TabSelectionProtocol
{
    var selectedTab: MonitorAxisTab { get set }
}

protocol TabSelectionStorageProtocol
{
    var userTabStorage: UserTabStorageProtocol { get }
}

final class TabSelectionViewModel: ObservableObject, TabSelectionProtocol, TabSelectionStorageProtocol
{
    var userTabStorage: UserTabStorageProtocol
    @Published var selectedTab: MonitorAxisTab 

    init(defaults: UserDefaults)
    {
        self.userTabStorage = UserTabStorage(defaults: defaults)
        do
        {
            _selectedTab = Published(initialValue: try userTabStorage.loadTab())
        } catch {
            _selectedTab = Published(initialValue: Setting.defaultTab)
        }
    }
}
