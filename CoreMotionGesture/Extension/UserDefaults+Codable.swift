import Foundation

// Enable storage and retrieval of Codable data types.
extension UserDefaults
{
    func setCodable<Element: Codable>(value: Element, forKey key: String)
    {
        let data = try? JSONEncoder().encode(value)
        UserDefaults.standard.setValue(data, forKey: key)
    }

    func getCodable<Element: Codable>(forKey key: String) -> Element?
    {
        guard let data = UserDefaults.standard.data(forKey: key)
            else { return nil }
        let element = try? JSONDecoder().decode(Element.self, from: data)

        return element
    }
}
