struct MockMotionDetector: DoubleZShakeDetectorProtocol
{
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
