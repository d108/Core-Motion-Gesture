/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import Foundation

struct MockUserSettingStorage: UserSettingStorageProtocol
{
    var defaults: UserDefaults

    func storeShouldOpenSettingsOnStart(shouldOpenSettingsOnStart: Bool)
    {
        // dummy implementation
    }

    func loadShouldOpenSettingsOnStart() throws -> Bool
    {
        return false
    }

    func storeShouldDebugLayout(shouldDebugLayout: Bool)
    {
        // dummy implementation
    }

    func loadShouldDebugLayout() throws -> Bool
    {
        return false
    }
}
