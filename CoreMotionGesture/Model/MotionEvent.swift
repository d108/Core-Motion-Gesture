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
        switch self
        {
        case .x: return self.id
        case .y: return self.id
        case .z: return self.id
        }
    }

    func asAxisText() -> String
    {
        let axis = "-Axis"
        switch self
        {
        case .x, .y, .z: return self.asText() + axis
        }
    }

    func imageName() -> String
    {
        switch self
        {
        case .x: return "x.circle"
        case .y: return "y.circle"
        case .z: return "z.circle"
        }
    }
}
