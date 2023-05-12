import Combine

protocol AppRunnerProtocol
{
    var cancellables:Set<AnyCancellable> { get set }
    func cancelAll()
}
