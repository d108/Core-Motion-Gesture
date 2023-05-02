enum MonitoringSystemImage: String
{
    case doubleShaked = "waveform.path"
}

enum MonitoringButtonState
{
    case started
    case notStarted

    func buttonText() -> String
    {
        switch self
        {
        case .started: return "Stop Monitoring"
        case .notStarted: return "Start Monitoring"
        }
    }

    func imageName() -> String
    {
        switch self
        {
        case .started: return "stop"
        case .notStarted: return "play"
        }
    }
}
