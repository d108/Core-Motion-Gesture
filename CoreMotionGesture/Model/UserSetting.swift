enum UserSetting: String
{
    var key: String
    {
        return self.rawValue
    }

    case shouldOpenSettingsOnStart
    case shouldDebugLayout
    // TODO: Have view model for user settings
}
