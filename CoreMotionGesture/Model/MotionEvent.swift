enum MotionEvent
{
    case doubleXShake
    case doubleYShake
    case doubleZShake
    case none
}

enum MonitorAxis: CaseIterable
{
    case x, y, z

    func asText() -> String
    {
        switch self
        {
        case .x: return "X"
        case .y: return "Y"
        case .z: return "Z"
        }
    }
}
