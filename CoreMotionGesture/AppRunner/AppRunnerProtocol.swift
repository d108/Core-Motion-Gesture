import Combine

protocol AppRunnerProtocol
{
    var cancellables: Set<AnyCancellable> { get set }
    func cancelAll()
}

// The mutating default implementation does not play well with SwiftUI immutable views.
//
//    extension AppRunnerProtocol
//    {
//        mutating func cancelAll()
//        {
//            self.cancellables = Set<AnyCancellable>()
//        }
//    }
