import SwiftUI
import CoreMotion

struct ContentView: View
{
    @StateObject var detectorsViewModel: DetectorsViewModel =
        DetectorsViewModel()
    @ObservedObject var tabSelectionViewModel: TabSelectionViewModel

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
        hapticGenerator: HapticGeneratorProtocol? = nil,
        tabSelectionViewModel:TabSelectionViewModel
    ) {
        self.hapticGenerator = hapticGenerator
        self.tabSelectionViewModel = tabSelectionViewModel
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
            )
        ).environmentObject(detectorsViewModel)
    }

    var body: some View
    {
        return TabView(selection: $tabSelectionViewModel.selectedTab)
        {
            ForEach(MonitorAxis.allCases)
            { axis in
                doubleShakeDetectionView(
                    monitorAxis: axis,
                    motionEventStream: MotionEventStream()
                )
                    .tabItem { tabLabel(axis) }
                    .tag(axis)
                    .id(detectorsViewModel.detectionViewIDs[axis])
            }
        }
        .onChange(of: tabSelectionViewModel.selectedTab)
        { selectedTab in
            detectorsViewModel.resetDetectorViewID(axis: selectedTab)
        }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let tabSelectionViewModel = TabSelectionViewModel(defaults: MockUserDefaults())
        ContentView(
            tabSelectionViewModel: tabSelectionViewModel
        )
    }
}
