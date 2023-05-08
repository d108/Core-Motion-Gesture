import Foundation

struct MockUserTabStorage: UserTabStorageProtocol
{
    var defaults: UserDefaults

    func storeTab(selectedTab: MonitorAxis)
    {
        // dummy implementation
    }

    func loadTab() throws -> MonitorAxis
    {
        Setting.defaultTab
    }
}
