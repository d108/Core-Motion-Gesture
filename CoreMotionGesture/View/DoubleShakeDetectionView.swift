import SwiftUI

struct DoubleShakeDetectionView: View
{
    let vspace: CGFloat = 20
    let padding: CGFloat = 20
    let visible: CGFloat = 100
    let invisible: CGFloat = 0
    let axisFontSize: CGFloat = 72
    let circleWidth: CGFloat = 200
    let circleLinewidth: CGFloat = 4
    let circleColor: Color = .orange
    let buttonLabel: (MonitoringButtonState) -> Label =
    { state in
        Label(state.buttonText(), systemImage: state.imageName())
    }
    let testErrorText = "Test Error"
    var errorAlertFactory: ErrorAlertFactory
    let hapticGenerator: HapticGeneratorProtocol?
    @ObservedObject var motionEventViewModel: MotionEventViewModel

    init(
        hapticGenerator: HapticGeneratorProtocol?,
        motionEventViewModel: MotionEventViewModel,
        detectorsViewModel: DetectorsViewModel
    ) {
        self.hapticGenerator = hapticGenerator
        self.motionEventViewModel = motionEventViewModel
        self.errorAlertFactory = ErrorAlertFactory(
            motionEventViewModel: motionEventViewModel,
            detectorsViewModel: detectorsViewModel
        )
    }

    var body: some View
    {
        print("button state is \(motionEventViewModel.monitoringButtonState)",
            "for axis \(motionEventViewModel.motionDetector.monitorAxis)")
        return GeometryReader
        { geo in
            VStack(spacing: vspace)
            {
                Text("Testing Accelerometer\nfor Double Shake Motion")
                    .multilineTextAlignment(.center)
                    .font(.title2)
                Text("The motion can be used as a non-screen-based gesture in apps.")
                    .font(.caption)
                    .padding(padding)
                Button
                {
                    motionEventViewModel.motionDetector
                        .motionEventStream?.sendMotionError(error: .testError)
                } label: {
                    Text(testErrorText)
                }
                ZStack
                {
                    Image(systemName: MonitoringSystemImage.doubleShaked.rawValue)
                        .resizable(resizingMode: .stretch)
                        .opacity(motionEventViewModel.doubleShaked ? visible : invisible)
                        .frame(maxHeight: geo.size.height * 0.5)
                        .frame(maxWidth: .infinity)
                    Text(motionEventViewModel.motionDetector.monitorAxis.asText())
                        .font(.system(size: axisFontSize))
                        .foregroundColor(circleColor)
                        .overlay(Circle()
                            .stroke(circleColor, lineWidth: circleLinewidth)
                            .frame(width: circleWidth))
                }
                    .frame(maxHeight: geo.size.height * 0.5)
                VStack
                {
                    Button
                    {
                        switch motionEventViewModel.monitoringButtonState
                        {
                        case .started: motionEventViewModel.monitoringButtonState = .notStarted
                        case .notStarted: motionEventViewModel.monitoringButtonState = .started
                        }
                    } label: {
                        switch motionEventViewModel.monitoringButtonState
                        {
                        case .started: buttonLabel(motionEventViewModel.monitoringButtonState)
                        case .notStarted: buttonLabel(motionEventViewModel.monitoringButtonState)
                        }
                    }
                }
            }
        }
            .padding()
            .onChange(of: motionEventViewModel.monitoringButtonState)
        { buttonState in
            motionEventViewModel.handleMonitoring(buttonState: buttonState)
        }
            .onChange(of: motionEventViewModel.doubleShaked)
        { doubleShaked in
            if doubleShaked
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
            .onDisappear()
        {
            motionEventViewModel.monitoringButtonState = .notStarted
        }
            .alert(isPresented: $motionEventViewModel.showErrorAlert)
        {
            return errorAlertFactory.errorAlert(
                axis: motionEventViewModel.motionDetector.monitorAxis
            )
        }
    }
}
