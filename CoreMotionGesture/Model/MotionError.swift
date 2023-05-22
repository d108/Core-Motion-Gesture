/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import Foundation

enum MotionError: LocalizedError
{
    case mismatchedAxis
    case noDataAvailable
    case testError
    case accelerometerFailed(String?)

    var failureReason: String?
    {
        switch self
        {
        case .mismatchedAxis:
            return "Axis does not match what is set in the detector."
        case .noDataAvailable:
            return "Expected accelerometer data is not available."
        case .testError:
            return "User forced completion by failure."
        case .accelerometerFailed(let description):
            let fatalError = "Accelerometer failed"
            if let description = description
            {
                return fatalError + ": " + description
            } else {
                return fatalError
            }
        }
    }
}
