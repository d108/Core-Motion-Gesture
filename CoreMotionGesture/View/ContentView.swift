import SwiftUI
import CoreMotion

struct ContentView: View
{
    @State private var selectedTab: MonitorAxis = .x
    @ObservedObject var detectorsViewModel: DetectorsViewModel
    let tabLabel: (MonitorAxis) -> Label =
    { axis in
        Label(axis.asAxisText(), systemImage: axis.imageName())
    }
    let motionDetector: (MonitorAxis, MotionEventStreamProtocol)
        -> DoubleShakeDetectorProtocol =
    { axis, eventStream in
        DoubleShakeDetector(
            motionManager: CMMotionManager(),
            monitorAxis: axis,
            motionEventStream: eventStream
        )
    }
    let coreMotionGestureViewModel: (DoubleShakeDetectorProtocol)
        -> MotionEventViewModel =
    { detector in
        MotionEventViewModel(motionDetector: detector)
    }
    let hapticGenerator: HapticGeneratorProtocol?

    init(
        hapticGenerator: HapticGeneratorProtocol? = nil
    ) {
        self.hapticGenerator = hapticGenerator
        self.detectorsViewModel = DetectorsViewModel()
    }

    // View factory
    func doubleShakeDetectionView(
        monitorAxis: MonitorAxis,
        motionEventStream: MotionEventStreamProtocol
    ) -> some View
    {
        DoubleShakeDetectionView(
            hapticGenerator: hapticGenerator,
            motionEventViewModel: coreMotionGestureViewModel(
                motionDetector(monitorAxis, motionEventStream)
            ),
            detectorsViewModel: detectorsViewModel
        )
    }

    var body: some View
    {
        return TabView(selection: $selectedTab)
        {
            doubleShakeDetectionView(
                monitorAxis: .x,
                motionEventStream: MotionEventStream()
            )
                .tabItem { tabLabel(.x) }
                .tag(MonitorAxis.x)
                .id(detectorsViewModel.detectionViewIDs[.x])
            doubleShakeDetectionView(
                monitorAxis: .y,
                motionEventStream: MotionEventStream()
            )
                .tabItem { tabLabel(.y) }
                .tag(MonitorAxis.y)
                .id(detectorsViewModel.detectionViewIDs[.y])
            doubleShakeDetectionView(
                monitorAxis: .z,
                motionEventStream: MotionEventStream()
            )
                .tabItem { tabLabel(.z) }
                .tag(MonitorAxis.z)
                .id(detectorsViewModel.detectionViewIDs[.z])
        }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
    }
}
