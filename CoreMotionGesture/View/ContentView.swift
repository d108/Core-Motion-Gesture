import SwiftUI
import CoreMotion

struct ContentView: View
{
    @State private var selectedTab: MonitorAxis
    @StateObject var detectorsViewModel: DetectorsViewModel =
        DetectorsViewModel()
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
    let userTabStorage: UserTabStorageProtocol

    init(
        hapticGenerator: HapticGeneratorProtocol? = nil,
        userTabStorage: UserTabStorageProtocol
    ) {
        self.hapticGenerator = hapticGenerator
        self.userTabStorage = userTabStorage
        do
        {
            _selectedTab = State(initialValue: try userTabStorage.loadTab())
        } catch {
            _selectedTab = State(initialValue: Setting.defaultTab)
        }
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
        return TabView(selection: $selectedTab)
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
            .onChange(of: selectedTab)
        { selectedTab in
            userTabStorage.storeTab(selectedTab: selectedTab)
            detectorsViewModel.resetDetectorViewID(axis: selectedTab)
        }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView(
            userTabStorage: MockUserTabStorage(defaults: MockUserDefaults())
        )
    }
}
