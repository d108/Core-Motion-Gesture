import SwiftUI
import Combine
import CoreMotion

enum MotionError: Error
{
    case noDataAvailable
}

protocol DoubleShakeDetectorProtocol
{
    var motionEventStream: MotionEventStreamProtocol? { get }
    var monitorAxis: MonitorAxis { get }
    func startMonitoring()
    func stopMonitoring()
}

// Detect a double shake gesture.
//
// Z-axis example:
// The Z-axis is the up and down direction according to a phone's screen aligned parallel to the ground, like a tabletop.
//
// Only a limited number, keepValueCount, of readings are kept to prevent using more memory.
// The motionCutoff is the strength of the detected motion according to the standard deviation of readings.
struct DoubleShakeDetector: DoubleShakeDetectorProtocol
{
    let motionManager: CMMotionManager
    let motionCutoff: Double = 0.55
    let readingMinimum = 3
    let keepValueCount = 2
    let shakeDetectionMinimum = 4
    let timeWindowMin: TimeInterval = 0.3
    let timeWindowMax: TimeInterval = 0.8
    let accelerometerUpdateInterval: TimeInterval = 1 / 100 // 100 Hz
    let motionEventStream: MotionEventStreamProtocol?
    let monitorAxis: MonitorAxis

    init(motionManager: CMMotionManager, monitorAxis: MonitorAxis)
    {
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

        if motionManager.isAccelerometerAvailable
        {
            queue = .main
            // We read CMAccelerometerData below.
            motionManager.startAccelerometerUpdates(to: queue)
            { data, error in
                guard error == nil else { fatalError(error!.localizedDescription) }
                guard let data = data else { fatalError(MotionError.noDataAvailable.localizedDescription) }
                let value = accelerationValue(data: data)

                // When not using the main queue, EXC_BAD_ACCESS happens here.
                motionValues.append(value)

                if readingCount <= readingMinimum
                {
                    readingCount += 1
                    startTime = Date()
                    print("\tread")
                }

                // We seed readingMinimum readings to ensure detection is active.
                if readingCount > readingMinimum
                {
                    if fabs(standardDeviation(values: motionValues)) > motionCutoff
                    {
                        shakeCount += 1
                    }
                    if shakeCount > shakeDetectionMinimum
                    {
                        endTime = Date()
                        let interval = endTime.timeIntervalSince(startTime)
                        if interval <= timeWindowMax && interval >= timeWindowMin
                        {
                            print("double shake, interval: \(interval)")
                            sendMotionEvent()
                        }
                        resetReadings()
                    }
                }
                while motionValues.count > keepValueCount
                {
                    motionValues.remove(at: motionValues.count - 1)
                }
                let interval = endTime.timeIntervalSince(startTime)
                if interval > timeWindowMax
                {
                    startTime = Date()
                }
            }
        }

        func resetReadings()
        {
            readingCount = 0
            shakeCount = 0
            startTime = Date()
        }
    }

    func stopMonitoring()
    {
        motionManager.stopAccelerometerUpdates()
    }

    private func sendMotionEvent()
    {
        var event: MotionEvent = .none
        switch monitorAxis
        {
        case .x: event = .doubleXShake
        case .y: event = .doubleYShake
        case .z: event = .doubleZShake
        }
        motionEventStream?.sendMotionEvent(event: event)
    }

    private func accelerationValue(data: CMAccelerometerData) -> Double
    {
        var accelerationValue: Double?
        switch monitorAxis
        {
        case .x:
            accelerationValue = data.acceleration.x
        case .y:
            accelerationValue = data.acceleration.y
        case .z:
            accelerationValue = data.acceleration.z
        }
        if let accelerationValue = accelerationValue
        {
            return accelerationValue
        }
        
        return 0.0
    }
}

extension DoubleShakeDetector
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
