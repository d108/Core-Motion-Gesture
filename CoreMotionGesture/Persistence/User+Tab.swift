/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import Foundation

protocol UserTabStorageProtocol
{
    var defaults: UserDefaults { get }

    func storeTab(selectedTab: MonitorAxisTab)
    func loadTab() throws -> MonitorAxisTab
}

struct UserTabStorage: UserTabStorageProtocol
{
    let defaults: UserDefaults
    let key = UserTab.selectedTab.key

    init(defaults: UserDefaults)
    {
        self.defaults = defaults
    }

    func storeTab(selectedTab: MonitorAxisTab)
    {
        defaults.setCodable(value: selectedTab, forKey: key)
    }

    func loadTab() throws -> MonitorAxisTab
    {
        let axis: MonitorAxisTab? = defaults.getCodable(forKey: key)
        guard let axis = axis else
        {
            throw UserError.noDataAvailable
        }

        return axis
    }
}
