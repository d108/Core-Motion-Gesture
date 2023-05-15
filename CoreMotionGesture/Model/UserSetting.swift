enum UserSetting: String
{
    var key: String
    {
        return self.rawValue
    }

    case shouldOpenSettingsOnStart
    case shouldDebugLayout
}
