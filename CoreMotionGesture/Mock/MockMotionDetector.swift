struct MockMotionDetector: DoubleShakeDetectorProtocol
{
    var monitorAxis: MonitorAxis
    var motionEventStream: MotionEventStreamProtocol?

    func startMonitoring()
    {
        // dummy implementation
    }

    func stopMonitoring()
    {
        // dummy implementation
    }
}
