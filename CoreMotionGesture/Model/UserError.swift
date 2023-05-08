import Foundation

enum UserError: LocalizedError
{
    case noDataAvailable

    var failureReason: String?
    {
        switch self
        {
        case .noDataAvailable:
            return "Expected user data is not available."
        }
    }
}
