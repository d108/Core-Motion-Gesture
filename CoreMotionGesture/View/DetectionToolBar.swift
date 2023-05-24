/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import SwiftUI

struct DetectorToolBar: ToolbarContent
{
    let infoCircle = "info.circle"
    @EnvironmentObject var appRunnerViewModel: AppRunnerViewModel
    @EnvironmentObject var detectorsViewModel: DetectorsViewModel
    @ObservedObject var userSettingViewModel: UserSettingViewModel
    @ObservedObject var tabSelectionViewModel: TabSelectionViewModel
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
                Image(systemName: infoCircle)
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
