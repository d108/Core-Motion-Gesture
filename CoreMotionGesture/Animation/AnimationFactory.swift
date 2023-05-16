// SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
// SPDX-License-Identifier: MIT License

import SwiftUI

struct AnimationFactory
{
    static func lessBounce() -> Animation
    {
        Animation.interpolatingSpring(stiffness: 300, damping: 15)
    }

    static func moreBounce() -> Animation
    {
        Animation.interpolatingSpring(stiffness: 300, damping: 5)
    }
}
