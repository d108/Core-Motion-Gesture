enum MotionEvent
{
    case doubleXShake
    case doubleYShake
    case doubleZShake
    case none
}

enum MonitorAxis: CaseIterable, Identifiable
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
