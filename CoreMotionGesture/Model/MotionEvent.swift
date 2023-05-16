// SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
// SPDX-License-Identifier: MIT License

enum MotionEvent
{
    case doubleXShake
    case doubleYShake
    case doubleZShake
    case none
}

enum MonitorAxis: CaseIterable, Codable, Identifiable
{
    var id: String
    {
        switch self
        {
        case .x: return "X"
        case .y: return "Y"
        case .z: return "Z"
        }
    }

    case x, y, z

    func asText() -> String
    {
        self.id
    }

    func asAxisText() -> String
    {
        let axis = "-Axis"

        return self.asText() + axis
    }

    func imageName() -> String
    {
        self.id.lowercased() + ".circle"
    }
}
