protocol TimeChangerProtocol: AppRunnerProtocol
{
    associatedtype EventType

    func appRunnerShouldRun(shouldRun: Bool)
    func runTimer()
    func cancelAll()
}

extension TimeChangerProtocol
{
    func appRunnerShouldRun(shouldRun: Bool)
    {
        if shouldRun { self.runTimer() }
        else { self.cancelAll() }
    }
}
