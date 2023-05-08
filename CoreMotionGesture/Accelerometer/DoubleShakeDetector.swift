import SwiftUI
import Combine
import CoreMotion

protocol DoubleShakeDetectorProtocol
{
    var motionEventStream: MotionEventStreamProtocol? { get }
    var monitorAxis: MonitorAxis { get }
    func startMonitoring()
    func stopMonitoring()
}

// Detect a double shake gesture.
//
// Only a limited number, keepValueCount, of readings are kept to prevent using more
// memory. The motionCutoff is the strength of the detected motion according to the
// standard deviation of readings.
//
// We have two distinct detection states during our shake monitoring process:
//
// A. The detection process from the beginning of monitoring.
// B. The detection process while monitoring is ongoing.
//
// Although we aim to detect double shakes within a single window, the high rate of
// incoming data makes it challenging. To ensure greater consistency, we have developed an
// alternative method.
//
// Without this implementation, we may encounter problems such as a strong shake
// triggering as a double shake during condition (A) at the start of monitoring or
// inconsistent detection of double shake events.
struct DoubleShakeDetector: DoubleShakeDetectorProtocol
{
    let motionManager: CMMotionManager
    let motionCutoff: Double = 0.55
    let readingMinimum = 10 // Lower value is more sensitive
    let keepValueCount = 4
    let shakeDetectionMinimum = 2

    let timeWindowMin: TimeInterval = 0.18
    let timeWindowMax: TimeInterval = 0.65
    let accelerometerUpdateInterval: TimeInterval = 1 / 100 // 100 Hz
    let motionEventStream: MotionEventStreamProtocol?
    let monitorAxis: MonitorAxis
    let fatalErrorText = "⚠️ Missing Stream: Should Not Happen"

    init(
        motionManager: CMMotionManager,
        monitorAxis: MonitorAxis,
        motionEventStream: MotionEventStreamProtocol
    ) {
        self.motionManager = motionManager
        motionManager.accelerometerUpdateInterval = accelerometerUpdateInterval
        self.motionEventStream = MotionEventStream()
        self.monitorAxis = monitorAxis
    }

    func startMonitoring()
    {
        var readingCount = 0
        var shakeCount = 0
        var motionValues = [Double]()
        var queue: OperationQueue
        var startTime = Date()
        var endTime = Date()
        var shouldIncrementShakeCount = true
        var outsideWindowCount = 0  // Data received outside the detection window

        if motionManager.isAccelerometerAvailable
        {
            queue = .main
            // We read CMAccelerometerData below.
            motionManager.startAccelerometerUpdates(to: queue)
            { data, error in
                guard error == nil else
                {
                    sendMotionError(error: .accelerometerFailed(error?.localizedDescription))
                    return
                }
                guard let data = data else
                {
                    sendMotionError(error: .noDataAvailable)
                    return
                }
                let value = accelerationValue(data: data)

                // When not using the main queue, EXC_BAD_ACCESS happens here.
                motionValues.append(value)

                // Start detection of the first shake.
                if readingCount <= readingMinimum, shakeCount < 1
                {
                    readingCount += 1
                }

                // Start detection of the second shake.
                if readingCount <= readingMinimum, shakeCount >= 1
                {
                    readingCount += 1
                    if readingCount > readingMinimum - 2
                    {
                        shouldIncrementShakeCount = true
                    }
                }

                // We seed readingMinimum readings to ensure detection is active and stable.
                if readingCount > readingMinimum
                {
                    if fabs(standardDeviation(values: motionValues)) > motionCutoff
                    {
                        if shouldIncrementShakeCount
                        {
                            shakeCount += 1
                            if shakeCount > 0, shakeCount < shakeDetectionMinimum
                            {
                                startTime = Date()
                            }
                            shouldIncrementShakeCount = false
                            readingCount = 0
                        }
                    }
                    let insideTimeWindow: (Date, Date, TimeInterval, TimeInterval) -> Bool =
                    { start, end, min, max in
                        let interval = end.timeIntervalSince(start)
                        return interval >= min && interval <= max
                    }
                    if shakeCount >= shakeDetectionMinimum || outsideWindowCount >= shakeDetectionMinimum
                    {
                        endTime = Date()
                        assert(startTime < endTime)
                        if insideTimeWindow(startTime, endTime, timeWindowMin, timeWindowMax)
                        {
                            sendMotionEvent()
                            outsideWindowCount = 0
                        }
                        else
                        {
                            shouldIncrementShakeCount = true
                            outsideWindowCount += 1
                            if outsideWindowCount > shakeDetectionMinimum
                            {
                                outsideWindowCount = 0
                            }
                        }
                        resetReadings()
                    }
                }

                while motionValues.count > keepValueCount
                {
                    motionValues.remove(at: motionValues.count - 1)
                }
            }
        }

        func resetReadings()
        {
            readingCount = 0
            shakeCount = 0
            shouldIncrementShakeCount = true

            // Resetting motion values here does not work to make detection
            // more consistent like with the following code:
            //
            //     motionValues = [Double]()
        }
    }

    func stopMonitoring()
    {
        motionManager.stopAccelerometerUpdates()
    }
}
