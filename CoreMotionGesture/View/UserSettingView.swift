import SwiftUI

struct UserSettingView: View
{
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appRunnerViewModel: AppRunnerViewModel
    @EnvironmentObject var detectorsViewModel: DetectorsViewModel
    let monitorAxis: MonitorAxisTab
    let userSettingStorage: UserSettingStorageProtocol

    var body: some View
    {
        VStack(spacing: Setting.vspace)
        {
            Spacer()
            Text("Automatic App Running")
            Text("Reveal Flaws with Testing Patterns").padding()
            Group
            {
                Toggle("Open Settings on Start", isOn: $appRunnerViewModel.shouldOpenSettingsOnStart).padding(.horizontal)                
                Toggle("Tab View Runner", isOn: $appRunnerViewModel.shouldRunTabView).padding(.horizontal)
                Toggle("Detection View Runner", isOn: $appRunnerViewModel.shouldRunDetectionView).padding(.horizontal)
            }
            Text("With only a detection view runner, views might get stuck on the test error view.")
                .font(.caption)
                .padding()
                .layoutPriority(2)
                .if(Setting.shouldDebugLayout) { $0.border(.green) }
            Text("After pressing dismiss, slide to dismiss this view if needed on iOS 14. View regeneration interferes with the dismiss action.")
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
                .onAppear
            {
                do
                {
                    let openSettingsOnStart = try userSettingStorage.loadShouldOpenSettingsOnStart()
                    appRunnerViewModel.shouldOpenSettingsOnStart = openSettingsOnStart
                } catch
                {
                    // TODO: Handle error
                }
            }
        }.onChange(of: appRunnerViewModel.shouldOpenSettingsOnStart)
        { openSettingsOnStart in
            print("will store \(openSettingsOnStart)")
            userSettingStorage.storeShouldOpenSettingsOnStart(openSettingsOnStart: openSettingsOnStart)
        }
    }
}

struct SheetView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let mockAxis = MonitorAxis.x
        let userSettingStorage = MockUserSettingStorage(defaults: MockUserDefaults())
        UserSettingView(
            monitorAxis: mockAxis,
            userSettingStorage: userSettingStorage
        )
    }
}
