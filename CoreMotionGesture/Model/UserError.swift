/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import Foundation

enum UserError: LocalizedError
{
    case noDataAvailable

    var failureReason: String?
    {
        switch self
        {
        case .noDataAvailable:
            return "Expected user data is not available."
        }
    }
}
