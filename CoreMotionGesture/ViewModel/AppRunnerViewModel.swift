import SwiftUI

// TODO: Separate App Runner view model and User Setting view model.
final class AppRunnerViewModel: ObservableObject
{
    @Published var settingsShownOnStart = false
    @Published var shouldOpenSettingsOnStart: Bool
    @Published var shouldRunTabView = false
    @Published var shouldRunDetectionView = false

    var userSettingStorage: UserSettingStorageProtocol

    init(userSettingStorage: UserSettingStorageProtocol)
    {
        self.userSettingStorage = userSettingStorage
        do
        {
            _shouldOpenSettingsOnStart = Published(
                initialValue: try userSettingStorage.loadShouldOpenSettingsOnStart()
            )
        } catch
        {
            _shouldOpenSettingsOnStart = Published(initialValue: false)
        }
    }
}
