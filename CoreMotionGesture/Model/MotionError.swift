import Foundation

enum MotionError: LocalizedError
{
    case mismatchedAxis
    case noDataAvailable
    case testError

    var failureReason: String?
    {
        switch self
        {
        case .mismatchedAxis:
            return "Axis does not match what is set in the detector."
        case .noDataAvailable:
            return "Expected accelerometer data is not available."
        case .testError:
            return "User forced completion by failure."
        }
    }
}
