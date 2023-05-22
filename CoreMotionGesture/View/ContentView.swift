/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import SwiftUI
import CoreMotion
import Combine

struct ContentView: View
{
    @ObservedObject var detectorsViewModel: DetectorsViewModel =
        DetectorsViewModel()
    @ObservedObject var tabSelectionViewModel: TabSelectionViewModel
    @EnvironmentObject var appRunnerViewModel: AppRunnerViewModel
    @State var cancellables = Set<AnyCancellable>()
    @State private var showingSettingsSheet = false

    let tabLabel: (MonitorAxis) -> Label =
    { axis in
        Label(axis.asAxisText(), systemImage: axis.imageName())
    }
    let motionDetector: (MonitorAxis, MotionEventStreamProtocol)
        -> DoubleShakeDetectorProtocol =
    { axis, eventStream in
        DoubleShakeDetector(
            motionManager: CMMotionManager(),
            monitorAxis: axis,
            motionEventStream: eventStream
        )
    }
    let coreMotionGestureViewModel: (DoubleShakeDetectorProtocol)
        -> MotionEventViewModel =
    { detector in
        MotionEventViewModel(motionDetector: detector)
    }
    let hapticGenerator: HapticGeneratorProtocol?
    var tabViewTimeChanger: any TimeChangerProtocol
    let userSettingViewModel: UserSettingViewModel

    init(
        hapticGenerator: HapticGeneratorProtocol? = nil,
        tabSelectionViewModel: TabSelectionViewModel,
        userSettingViewModel: UserSettingViewModel
    )
    {
        self.hapticGenerator = hapticGenerator
        self.tabSelectionViewModel = tabSelectionViewModel
        self.tabViewTimeChanger =
            TabViewRunner(runnableViewModel: tabSelectionViewModel)
        self.userSettingViewModel = userSettingViewModel
    }

    // View factory
    func doubleShakeDetectionView(
        monitorAxis: MonitorAxis,
        motionEventStream: MotionEventStreamProtocol
    ) -> some View
    {
        DoubleShakeDetectionView(
            hapticGenerator: hapticGenerator,
            motionEventViewModel: coreMotionGestureViewModel(
                motionDetector(monitorAxis, motionEventStream)
            ),
            detectorsViewModel: detectorsViewModel
        )
        .environmentObject(appRunnerViewModel)
    }

    var body: some View
    {
        return NavigationView
        {
            TabView(selection: $tabSelectionViewModel.selectedTab)
            {
                ForEach(MonitorAxis.allCases)
                { axis in
                    doubleShakeDetectionView(
                        monitorAxis: axis,
                        motionEventStream: MotionEventStream()
                    )
                    .tabItem
                    { tabLabel(axis) }
                    .tag(axis)
                    .id(detectorsViewModel.detectionViewIDs[axis])
                }
            }.navigationBarTitle(
                Text("Core Motion Gesture Demo"),
                displayMode: .inline
            ).toolbar
            {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button
                    {
                        showingSettingsSheet.toggle()
                    } label:
                    {
                        Image(systemName: "info.circle")
                    }
                    .sheet(
                        isPresented: $showingSettingsSheet,
                        onDismiss:
                        {
                            showingSettingsSheet = false
                            detectorsViewModel
                                .resetDetectorViewIDForError(axis: tabSelectionViewModel.selectedTab)
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
        .onChange(of: tabSelectionViewModel.selectedTab)
        { selectedTab in
            detectorsViewModel.resetDetectorViewID(axis: selectedTab)
        }
        .onChange(of: appRunnerViewModel.shouldRunTabView)
        { shouldRun in
            tabViewTimeChanger.appRunnerShouldRun(shouldRun: shouldRun)
        }
        .onAppear
        {
            if userSettingViewModel.shouldOpenSettingsOnStart,
                    !userSettingViewModel.settingsShownOnStart
            {
                showingSettingsSheet = true
                userSettingViewModel.settingsShownOnStart = true
            }
            tabViewTimeChanger.appRunnerShouldRun(shouldRun: appRunnerViewModel.shouldRunTabView)
        }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let tabSelectionViewModel = TabSelectionViewModel(defaults: MockUserDefaults())
        let userSettingStorage = MockUserSettingStorage(defaults: MockUserDefaults())
        let appRunnerViewModel = AppRunnerViewModel()
        let userSettingViewModel = UserSettingViewModel(userSettingStorage: userSettingStorage)

        ContentView(
            tabSelectionViewModel: tabSelectionViewModel,
            userSettingViewModel: userSettingViewModel
        ).environmentObject(appRunnerViewModel)
    }
}
