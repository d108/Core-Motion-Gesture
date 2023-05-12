import Foundation

struct MockUserSettingStorage: UserSettingStorageProtocol
{
    var defaults: UserDefaults

    func storeShouldOpenSettingsOnStart(openSettingsOnStart: Bool)
    {
        // dummy implementation
    }

    func loadShouldOpenSettingsOnStart() throws -> Bool
    {
        return false
    }

    func storeShouldDebugLayout(shouldDebugLayout: Bool)
    {
        // dummy implementation
    }

    func loadShouldDebugLayout() throws -> Bool
    {
        return false
    }
}
