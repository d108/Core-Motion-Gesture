// SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
// SPDX-License-Identifier: MIT License

enum UserSetting: String
{
    var key: String
    {
        return self.rawValue
    }

    case shouldOpenSettingsOnStart
    case shouldDebugLayout
}
