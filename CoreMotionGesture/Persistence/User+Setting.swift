import Foundation

protocol UserSettingStorageProtocol
{
    var defaults: UserDefaults { get }

    func storeShouldOpenSettingsOnStart(shouldOpenSettingsOnStart: Bool)
    func loadShouldOpenSettingsOnStart() throws -> Bool
    func storeShouldDebugLayout(shouldDebugLayout: Bool)
    func loadShouldDebugLayout() throws -> Bool
}

struct UserSettingStorage: UserSettingStorageProtocol
{
    let defaults: UserDefaults

    init(defaults: UserDefaults)
    {
        self.defaults = defaults
    }

    func storeShouldOpenSettingsOnStart(shouldOpenSettingsOnStart: Bool)
    {
        defaults.setCodable(
            value: shouldOpenSettingsOnStart,
            forKey: UserSetting.shouldOpenSettingsOnStart.key
        )
    }

    func loadShouldOpenSettingsOnStart() throws -> Bool
    {
        let shouldOpenSettingsOnStart: Bool? = defaults
            .getCodable(forKey: UserSetting.shouldOpenSettingsOnStart.key)
        guard let shouldOpenSettingsOnStart = shouldOpenSettingsOnStart
            else { throw UserError.noDataAvailable }

        return shouldOpenSettingsOnStart
    }

    func storeShouldDebugLayout(shouldDebugLayout: Bool)
    {
        defaults.setCodable(
            value: shouldDebugLayout,
            forKey: UserSetting.shouldDebugLayout.key
        )
    }

    func loadShouldDebugLayout() throws -> Bool
    {
        let shouldDebugLayout: Bool? = defaults
            .getCodable(forKey: UserSetting.shouldDebugLayout.key)
        guard let shouldDebugLayout = shouldDebugLayout
            else { throw UserError.noDataAvailable }

        return shouldDebugLayout
    }
}
