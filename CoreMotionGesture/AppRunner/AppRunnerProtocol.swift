// SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
// SPDX-License-Identifier: MIT License

import Combine

protocol AppRunnerProtocol
{
    var cancellables: Set<AnyCancellable> { get set }
    func cancelAll()
}

// The mutating default implementation does not play well with SwiftUI immutable views.
//
//    extension AppRunnerProtocol
//    {
//        mutating func cancelAll()
//        {
//            self.cancellables = Set<AnyCancellable>()
//        }
//    }
