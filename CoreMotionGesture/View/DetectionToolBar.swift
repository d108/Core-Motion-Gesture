/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import SwiftUI

struct DetectorToolBar: ToolbarContent
{
    @ObservedObject var userSettingViewModel: UserSettingViewModel
    @ObservedObject var tabSelectionViewModel: TabSelectionViewModel
    @StateObject var appRunnerViewModel: AppRunnerViewModel
    @StateObject var detectorsViewModel: DetectorsViewModel
    @Binding var showingSettingsSheet: Bool
    
    var body: some ToolbarContent
    {
        ToolbarItem(placement: .navigationBarTrailing)
        {
            Button
            {
                showingSettingsSheet.toggle()
            } label:
            {
                Image(systemName: Setting.SystemImage.infoCircle)
            }
            .sheet(
                isPresented: $showingSettingsSheet,
                onDismiss:
                {
                    showingSettingsSheet = false
                    detectorsViewModel.resetDetectorViewIDForError(
                        axis: tabSelectionViewModel.selectedTab
                    )
                }
            )
            {
                UserSettingView(
                    userSettingViewModel: userSettingViewModel,
                    monitorAxis: tabSelectionViewModel.selectedTab
                )
                .environmentObject(appRunnerViewModel)
                .environmentObject(detectorsViewModel)
            }
        }
    }
}
