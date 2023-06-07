/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import CoreMotion
import SwiftUI

enum AppError: LocalizedError
{
    case storageFailedToInitialize(String)

    var failureReason: String?
    {
        switch self
        {
        case let .storageFailedToInitialize(suiteName):
            return "🚨UserDefaults with suite name \(suiteName) failed to initialize."
        }
    }
}

@main
struct CoreMotionGestureApp: App
{
    let hapticGenerator: HapticGeneratorProtocol
    let userSettingStorage: UserSettingStorageProtocol
    let tabSelectionViewModel: TabSelectionViewModel
    let appRunnerViewModel: AppRunnerViewModel
    let userSettingViewModel: UserSettingViewModel

    init()
    {
        hapticGenerator = HapticGenerator(
            generator: UINotificationFeedbackGenerator()
        )
        guard let defaults = UserDefaults.group else
        {
            fatalError(
                AppError
                    .storageFailedToInitialize(Setting.suiteName)
                    .failureReason ??
                    Setting.unknownErrorText
            )
        }
        userSettingStorage = UserSettingStorage(defaults: defaults)
        tabSelectionViewModel = TabSelectionViewModel(defaults: defaults)
        appRunnerViewModel = AppRunnerViewModel()
        userSettingViewModel =
            UserSettingViewModel(userSettingStorage: userSettingStorage)
    }

    var body: some Scene
    {
        WindowGroup
        {
            ContentView(
                hapticGenerator: hapticGenerator,
                tabSelectionViewModel: tabSelectionViewModel,
                userSettingViewModel: userSettingViewModel
            ).environmentObject(appRunnerViewModel)
        }
    }
}
