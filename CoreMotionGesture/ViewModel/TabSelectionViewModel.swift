/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

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

protocol TabViewRunnable
{
    func onTimeChange(tab: MonitorAxisTab)
}

final class TabSelectionViewModel:
    ObservableObject,
    TabSelectionProtocol,
    TabSelectionStorageProtocol
{
    var userTabStorage: UserTabStorageProtocol
    @Published var selectedTab: MonitorAxisTab

    init(defaults: UserDefaults)
    {
        self.userTabStorage = UserTabStorage(defaults: defaults)
        do
        {
            _selectedTab = Published(initialValue: try userTabStorage.loadTab())
        } catch
        {
            _selectedTab = Published(initialValue: Setting.defaultTab)
        }
    }
}

extension TabSelectionViewModel: TabViewRunnable
{
    func onTimeChange(tab: MonitorAxisTab)
    {
        self.selectedTab = tab
    }
}
