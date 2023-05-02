import SwiftUI
import CoreMotion

struct ContentView: View
{
    let tabLabel: (MonitorAxis) -> Label =
    { axis in
        Label(axis.asAxisText(), systemImage: axis.imageName())
    }
    let motionDetector: (MonitorAxis) -> DoubleShakeDetectorProtocol =
    { axis in
        DoubleShakeDetector(
            motionManager: CMMotionManager(),
            monitorAxis: axis
        )
    }
    let coreMotionGestureViewModel: (DoubleShakeDetectorProtocol)
        -> CoreMotionGestureViewModel =
    { detector in
        CoreMotionGestureViewModel(motionDetector: detector)
    }
    let hapticGenerator: HapticGeneratorProtocol?

    init(
        hapticGenerator: HapticGeneratorProtocol? = nil
    ) {
        self.hapticGenerator = hapticGenerator
    }

    func doubleShakeDetectionView(monitorAxis: MonitorAxis) -> some View
    {
        DoubleShakeDetectionView(
            hapticGenerator: hapticGenerator,
            motionEventViewModel: coreMotionGestureViewModel(
                motionDetector(monitorAxis)
            )
        )
    }

    var body: some View
    {
        TabView
        {
            doubleShakeDetectionView(monitorAxis: .x)
                .tabItem { tabLabel(.x) }
            doubleShakeDetectionView(monitorAxis: .y)
                .tabItem { tabLabel(.y) }
            doubleShakeDetectionView(monitorAxis: .z)
                .tabItem { tabLabel(.z) }
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
