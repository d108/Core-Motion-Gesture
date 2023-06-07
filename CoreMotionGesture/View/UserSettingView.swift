/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import SwiftUI

struct UserSettingView: View
{
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appRunnerViewModel: AppRunnerViewModel
    @EnvironmentObject var detectorsViewModel: DetectorsViewModel
    @ObservedObject var userSettingViewModel: UserSettingViewModel
    let monitorAxis: MonitorAxisTab

    var body: some View
    {
        VStack(spacing: Setting.vspace)
        {
            Spacer()
            Text("Automatic App Running")
            Text("Reveal Flaws using Testing Patterns").padding()
            Group
            {
                Toggle(
                    "Open Settings on Start",
                    isOn: $userSettingViewModel.shouldOpenSettingsOnStart
                ).padding(.horizontal)
                Toggle(
                    "Tab View Runner",
                    isOn: $appRunnerViewModel.shouldRunTabView
                ).padding(.horizontal)
                Toggle(
                    "Detection View Runner",
                    isOn: $appRunnerViewModel.shouldRunDetectionView
                ).padding(.horizontal)
            }
            Text(
                "With only a detection view runner, views might get stuck on the test error view."
            )
            .font(.caption)
            .padding()
            .layoutPriority(2)
            .if(Setting.shouldDebugLayout) { $0.border(.green) }
            Text(
                "After pressing dismiss, slide to dismiss this view if needed on iOS 14. View regeneration interferes with the dismiss action."
            )
            .font(.caption)
            .padding()
            .layoutPriority(2)
            .if(Setting.shouldDebugLayout) { $0.border(.pink) }

            Spacer().layoutPriority(1)
            Button("Dismiss")
            {
                presentationMode.wrappedValue.dismiss()
            }
            Spacer().layoutPriority(1)
        }
        .onAppear
        {
            assert(type(of: appRunnerViewModel) == AppRunnerViewModel.self)
            assert(type(of: detectorsViewModel) == DetectorsViewModel.self)
        }
        .onChange(of: userSettingViewModel.shouldOpenSettingsOnStart)
        { openSettingsOnStart in
            userSettingViewModel
                .storeShouldOpenSettingsOnStart(
                    shouldOpenSettingsOnStart: openSettingsOnStart
                )
        }
    }
}

struct UserSettingView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let userSettingStorage =
            UserSettingStorage(defaults: MockUserDefaults())
        let appRunnerViewModel = AppRunnerViewModel()
        let detectorsViewModel = DetectorsViewModel()
        let userSettingViewModel =
            UserSettingViewModel(userSettingStorage: userSettingStorage)
        let mockAxis = MonitorAxis.x

        UserSettingView(
            userSettingViewModel: userSettingViewModel,
            monitorAxis: mockAxis
        )
        .environmentObject(appRunnerViewModel)
        .environmentObject(detectorsViewModel)
    }
}
