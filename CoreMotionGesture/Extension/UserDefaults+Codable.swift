/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import Foundation

// Enable storage and retrieval of Codable data types.
extension UserDefaults
{
    func setCodable<Element: Codable>(value: Element, forKey key: String)
    {
        let data = try? JSONEncoder().encode(value)
        setValue(data, forKey: key)
    }

    func getCodable<Element: Codable>(forKey key: String) -> Element?
    {
        guard let data = data(forKey: key) else
        {
            return nil
        }
        let element = try? JSONDecoder().decode(Element.self, from: data)

        return element
    }
}
