import SwiftUI

struct DoubleShakeDetectionView: View
{
    let vspace: CGFloat = 20
    let padding: CGFloat = 20
    let axisScaleStart: CGFloat = 0.25
    let axisScaleEnd: CGFloat = 1
    let axisExpandAfter: TimeInterval = 0.1
    let axis: MonitorAxis
    let buttonLabel: (MonitoringButtonState) -> Label =
    { state in
        Label(state.buttonText(), systemImage: state.imageName())
    }
    let testErrorText = "Test Error"
    let hapticGenerator: HapticGeneratorProtocol?
    let errorAlertFactory: (MotionEventViewModel, DetectorsViewModel)
        -> ErrorAlertFactory =
    {
        ErrorAlertFactory(motionEventViewModel: $0, detectorsViewModel: $1)
    }
    let newViewWasForError: (DetectorsViewModel, MonitorAxis) -> Bool =
    { viewModel, axis in
        viewModel.lastDetectionViewIDForError == viewModel.detectionViewIDs[axis]
    }
    @ObservedObject var motionEventViewModel: MotionEventViewModel
    @EnvironmentObject var detectorsViewModel: DetectorsViewModel
    @State private var shouldExpand: Bool
    @State private var animationValue: Int

    init(
        hapticGenerator: HapticGeneratorProtocol?,
        motionEventViewModel: MotionEventViewModel
    ) {
        self.hapticGenerator = hapticGenerator
        self.motionEventViewModel = motionEventViewModel
        self.axis = motionEventViewModel.motionDetector.monitorAxis
        _shouldExpand = State(initialValue: true)
        _animationValue = State(initialValue: 0)
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
            // Test error button
            Button
            {
                motionEventViewModel.motionDetector
                    .motionEventStream?.sendMotionError(error: .testError)
            } label: {
                Text(testErrorText)
            }
            Spacer()
            // Axis view
            AxisView(motionEventViewModel: motionEventViewModel)
                .id(detectorsViewModel.axisViewIDs[axis])
                .scaleEffect(shouldExpand &&
                    !newViewWasForError(detectorsViewModel, axis)
                    ? axisScaleStart : axisScaleEnd
                )
                .animation(AnimationFactory.lessBounce(), value: animationValue)
                .onAppear
            {
                shouldExpand = true
                DispatchQueue.main.asyncAfter(deadline: .now() + axisExpandAfter)
                {
                    self.shouldExpand = false
                    let skipAnimation = newViewWasForError(detectorsViewModel, axis)
                    if !skipAnimation
                    {
                        animationValue = 1
                    }
                }
            }
            // Monitoring button
            VStack
            {
                Spacer().frame(maxHeight: Setting.higButtonHeight)
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
                Spacer().frame(maxHeight: Setting.higButtonHeight)
            }.if(Setting.debugLayout) { $0.border(.pink) }
                .buttonStyle(RoundedButton(
                isActivated: motionEventViewModel.monitoringButtonState == .started)
            )
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
