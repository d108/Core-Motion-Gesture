import SwiftUI
import Combine
import CoreMotion

protocol DoubleZShakeDetectorProtocol
{
    var motionEventStream: MotionEventStreamProtocol? { get }
    func startMonitoring()
    func stopMonitoring()
}

// Detect a double Z-shake gesture.
// The Z-axis is the up and down direction according to a phone's screen aligned parallel to the ground, like a tabletop.
// Only a limited number, keepZValueCount, of readings are kept to prevent using more memory.
struct DoubleZShakeDetector: DoubleZShakeDetectorProtocol
{
    let motionManager: CMMotionManager
    let zMotionCutoff = 0.55 // the strength of the detected motion according to the standard deviation of readings
    let readingMinimum = 3
    let keepZValueCount = 2
    let zShakeDetectionMinimum = 4
    let timeWindowMin: TimeInterval = 0.3
    let timeWindowMax: TimeInterval = 0.8
    let accelerometerUpdateInterval: TimeInterval = 1 / 100 // 100 Hz
    let motionEventStream: MotionEventStreamProtocol?

    init(motionManager: CMMotionManager)
    {
        self.motionManager = motionManager
        motionManager.accelerometerUpdateInterval = accelerometerUpdateInterval
        self.motionEventStream = MotionEventStream()
    }

    func startMonitoring()
    {
        var readingCount = 0
        var zShakeCount = 0
        var zMotionValues = [Double]()
        var queue: OperationQueue
        var startTime = Date()
        var endTime = Date()

        if motionManager.isAccelerometerAvailable
        {
            queue = .main
            // We read CMAccelerometerData below.
            motionManager.startAccelerometerUpdates(to: queue) { data, error in
                guard error == nil else { fatalError(error!.localizedDescription) }
                if let zValue = data?.acceleration.z
                {
                    zMotionValues.append(zValue) // when not using the main queue, EXC_BAD_ACCESS happens here
                    if readingCount <= readingMinimum
                    {
                        readingCount += 1
                        startTime = Date()
                        print("\tread")
                    }
                }
                if readingCount > readingMinimum
                {
                    if fabs(standardDeviation(values: zMotionValues)) > zMotionCutoff
                    {
                        zShakeCount += 1
                    }
                    if zShakeCount > zShakeDetectionMinimum
                    {
                        endTime = Date()
                        let interval = endTime.timeIntervalSince(startTime)
                        if interval <= timeWindowMax && interval >= timeWindowMin
                        {
                            print("double z shake, interval: \(interval)")
                            motionEventStream?.sendMotionEvent(event: .doubleZShake)
                        }
                        readingCount = 0
                        zShakeCount = 0
                        startTime = Date()
                    }
                }
                while zMotionValues.count > keepZValueCount
                {
                    zMotionValues.remove(at: zMotionValues.count - 1)
                }
                let interval = endTime.timeIntervalSince(startTime)
                if interval > timeWindowMax {
                    startTime = Date()
                }
            }
        }
    }

    func stopMonitoring()
    {
        motionManager.stopAccelerometerUpdates()
    }
}

extension DoubleZShakeDetector
{
    func mean(values: [Double]) -> Double
    {
        var total = 0.0
        for value in values
        {
            total += value
        }

        return total / Double(values.count)
    }

    func standardDeviation(values: [Double]) -> Double
    {
        let mean = mean(values: values)
        var sumOfSquaredDifferences = 0.0
        var difference = 0.0

        for value in values
        {
            difference = value - mean
            sumOfSquaredDifferences += difference * difference
        }

        return sqrt(sumOfSquaredDifferences / Double(values.count))
    }
}
