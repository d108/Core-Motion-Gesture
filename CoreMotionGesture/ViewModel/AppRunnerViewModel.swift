// SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
// SPDX-License-Identifier: MIT License

import SwiftUI

final class AppRunnerViewModel: ObservableObject
{
    @Published var shouldRunTabView = false
    @Published var shouldRunDetectionView = false
}
