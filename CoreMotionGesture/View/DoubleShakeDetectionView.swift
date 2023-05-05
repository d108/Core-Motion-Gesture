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
    let higButtonHeight: CGFloat = 44
    let buttonLabel: (MonitoringButtonState) -> Label =
    { state in
        Label(state.buttonText(), systemImage: state.imageName())
    }
    let testErrorText = "Test Error"
    let hapticGenerator: HapticGeneratorProtocol?
    @ObservedObject var motionEventViewModel: MotionEventViewModel
    @EnvironmentObject var detectorsViewModel: DetectorsViewModel
    let errorAlertFactory: (MotionEventViewModel, DetectorsViewModel)
        -> ErrorAlertFactory =
    {
        ErrorAlertFactory(motionEventViewModel: $0, detectorsViewModel: $1)
    }

    init(
        hapticGenerator: HapticGeneratorProtocol?,
        motionEventViewModel: MotionEventViewModel
    ) {
        self.hapticGenerator = hapticGenerator
        self.motionEventViewModel = motionEventViewModel
    }

    var body: some View
    {
        print("button state is \(motionEventViewModel.monitoringButtonState)",
            "for axis \(motionEventViewModel.motionDetector.monitorAxis)")
        return VStack(spacing: vspace)
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
            Spacer()
            ZStack
            {
                Image(systemName: MonitoringSystemImage.doubleShaked.rawValue)
                    .resizable(resizingMode: .stretch)
                    .opacity(motionEventViewModel.doubleShaked ? visible : invisible)
                    .frame(maxWidth: .infinity)
                Text(motionEventViewModel.motionDetector.monitorAxis.asText())
                    .font(.system(size: axisFontSize))
                    .foregroundColor(circleColor)
                    .overlay(Circle()
                        .stroke(circleColor, lineWidth: circleLinewidth)
                        .frame(width: circleWidth))
            }.if(Setting.debugLayout) { $0.border(.purple) }
            VStack
            {
                Spacer().frame(maxHeight: higButtonHeight)
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
                Spacer().frame(maxHeight: higButtonHeight)
            }.if(Setting.debugLayout) { $0.border(.pink) }
        }.if(Setting.debugLayout) { $0.border(.green) }
            .padding(.vertical)
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
            await motionEventViewModel.handleMonitoring(
                buttonState: motionEventViewModel.monitoringButtonState
            )
        }
            .onDisappear()
        {
            motionEventViewModel.monitoringButtonState = .notStarted
        }
            .alert(isPresented: $motionEventViewModel.showErrorAlert)
        {
            let factory = errorAlertFactory(motionEventViewModel, detectorsViewModel)
            return factory.errorAlert(
                axis: motionEventViewModel.motionDetector.monitorAxis
            )
        }
    }
}
