import Foundation

protocol UserTabStorageProtocol
{
    var defaults: UserDefaults { get }

    func storeTab(selectedTab: MonitorAxis)
    func loadTab() throws -> MonitorAxis
}

struct UserTabStorage: UserTabStorageProtocol
{
    let defaults: UserDefaults
    let key = UserTab.selectedTab.key

    init(defaults: UserDefaults)
    {
        self.defaults = defaults
    }

    func storeTab(selectedTab: MonitorAxis)
    {
        defaults.setCodable(value: selectedTab, forKey: key)
    }

    func loadTab() throws -> MonitorAxis
    {
        let axis: MonitorAxis? = defaults.getCodable(forKey: key)
        guard let axis = axis
            else { throw UserError.noDataAvailable }
        
        return axis
    }
}
