protocol MotionEventViewRunnable
{
    var monitoringButtonState: MonitoringButtonState { get set }
    func updateDoubleShaked(doubleShaked: Bool)
    func pressTestError()
    func setMonitoringButtonState(monitoringButtonState: MonitoringButtonState)
}

extension MotionEventViewModel: MotionEventViewRunnable
{
    func updateDoubleShaked(doubleShaked: Bool)
    {
        self.doubleShaked = doubleShaked
    }

    func pressTestError()
    {
        self.motionDetector
            .motionEventStream?.sendMotionError(error: .testError)
    }

    func setMonitoringButtonState(monitoringButtonState: MonitoringButtonState)
    {
        self.monitoringButtonState = monitoringButtonState
    }
}
