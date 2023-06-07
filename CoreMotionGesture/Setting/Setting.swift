/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import Foundation

struct Setting
{
    static var shouldDebugLayout = false
    static var defaultTab = MonitorAxis.x
    static var waveImageDelay: TimeInterval = 1.5
    static let vspace: CGFloat = 20

    struct SystemImage
    {
        static let infoCircle = "info.circle"
    }
}

extension Setting
{
    /// When sharing data among apps, the suite name should match the app group in
    /// entitlements. However, it cannot be the bundle identifier. Other than that, the
    /// suite name can be arbitrary.
    ///
    /// The purpose of using an app group is to ensure more reliable synchronization of
    /// UserDefaults, especially when terminating the app during debugging.
    static var suiteName = "group.H8GGCD3NY7.com.ikiapps.CoreMotionGesture"
}

extension Setting
{
    static let unknownErrorText = "⚠️ Unknown Error: Should Not Be Seen"
}
