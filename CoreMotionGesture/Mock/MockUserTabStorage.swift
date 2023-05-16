// SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
// SPDX-License-Identifier: MIT License

import Foundation

struct MockUserTabStorage: UserTabStorageProtocol
{
    var defaults: UserDefaults

    func storeTab(selectedTab: MonitorAxis)
    {
        // dummy implementation
    }

    func loadTab() throws -> MonitorAxis
    {
        Setting.defaultTab
    }
}
