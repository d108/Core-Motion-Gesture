/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

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
        let monitoring = "Monitoring"

        switch self
        {
        case .started: return "Stop " + monitoring
        case .notStarted: return "Start " + monitoring
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
