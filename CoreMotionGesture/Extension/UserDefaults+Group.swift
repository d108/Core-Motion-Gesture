/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import Foundation

extension UserDefaults
{
    static let group = UserDefaults(suiteName: Setting.suiteName)
}
