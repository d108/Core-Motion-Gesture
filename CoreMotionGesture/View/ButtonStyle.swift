/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import SwiftUI

struct RoundedButton: ButtonStyle
{
    var isActivated: Bool

    func makeBody(configuration: Configuration) -> some View
    {
        configuration.label
            .padding()
            .background(isActivated ? Color.red : Color.clear)
            .foregroundColor(isActivated ? Color.black : Color.accentColor)
            .clipShape(Capsule())
            .frame(height: Setting.higButtonHeight)
    }
}
