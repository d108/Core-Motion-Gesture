import SwiftUI

final class UserSettingViewModel: ObservableObject
{
    @Published var shouldOpenSettingsOnStart: Bool
    @Published var settingsShownOnStart = false

    private let userSettingStorage: UserSettingStorageProtocol

    init(userSettingStorage: UserSettingStorageProtocol)
    {
        self.userSettingStorage = userSettingStorage
        do
        {
            shouldOpenSettingsOnStart = try userSettingStorage.loadShouldOpenSettingsOnStart()
        } catch
        {
            shouldOpenSettingsOnStart = false
        }

    }

    func storeShouldOpenSettingsOnStart(shouldOpenSettingsOnStart: Bool)
    {
        userSettingStorage
            .storeShouldOpenSettingsOnStart(
                shouldOpenSettingsOnStart: shouldOpenSettingsOnStart
            )
    }
}
