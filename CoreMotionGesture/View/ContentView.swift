import SwiftUI
import Combine

struct ContentView: View
{
    let vspace: CGFloat = 20
    let padding: CGFloat = 20
    let visible: CGFloat = 100
    let invisible: CGFloat = 0
    let label: (MonitoringButtonState) -> Label =
    { state in
        Label(state.buttonText(), systemImage: state.imageName())
    }
    let hapticGenerator: HapticGeneratorProtocol?
    @ObservedObject var motionEventViewModel: CoreMotionGestureViewModel

    init(
        hapticGenerator: HapticGeneratorProtocol? = nil,
        motionEventViewModel: CoreMotionGestureViewModel
    ) {
        self.hapticGenerator = hapticGenerator
        self.motionEventViewModel = motionEventViewModel
    }

    var body: some View
    {
        print("detector \(motionEventViewModel.monitoringButtonState)")
        return VStack(spacing: vspace)
        {
            Text("Testing Accelerometer\nfor Double Z-Shake Motion")
                .multilineTextAlignment(.center)
                .font(.title2)
            Text("The action can be used as a non-screen-based gesture in apps.")
                .font(.caption)
                .padding(padding)
            Spacer()
            Image(systemName: MonitoringSystemImage.doubleZShaked.rawValue)
                .resizable()
                .scaledToFill()
                .opacity(motionEventViewModel.doubleZShaked ? visible : invisible)
            Spacer()
            Button
            {
                switch motionEventViewModel.monitoringButtonState
                {
                case .started: motionEventViewModel.monitoringButtonState = .notStarted
                case .notStarted: motionEventViewModel.monitoringButtonState = .started
                }
            }
            label:
            {
                switch motionEventViewModel.monitoringButtonState
                {
                case .started: label(motionEventViewModel.monitoringButtonState)
                case .notStarted: label(motionEventViewModel.monitoringButtonState)
                }
            }
        }
            .padding()
            .onChange(of: motionEventViewModel.monitoringButtonState)
        { buttonState in
            motionEventViewModel.handleMonitoring(buttonState: buttonState)
        }
            .onChange(of: motionEventViewModel.doubleZShaked)
        { doubleZShaked in
            if doubleZShaked
            {
                hapticGenerator?.generateFeedback()
            }
        }
            .task
        {
            await motionEventViewModel
                .handleMonitoring(
                    buttonState: motionEventViewModel.monitoringButtonState
                )
        }

    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView(
            motionEventViewModel: CoreMotionGestureViewModel(
                motionDetector: MockMotionDetector()
            )
        )
    }
}
