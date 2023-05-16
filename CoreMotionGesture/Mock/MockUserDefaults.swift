// SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
// SPDX-License-Identifier: MIT License

import Foundation

class MockUserDefaults: UserDefaults
{
    convenience init()
    {
        self.init(suiteName: "Mock User Defaults")!
    }

    override init?(suiteName suitename: String?)
    {
        UserDefaults().removePersistentDomain(forName: suitename!)
        super.init(suiteName: suitename)
    }
}
