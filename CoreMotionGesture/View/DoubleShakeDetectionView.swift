// SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
// SPDX-License-Identifier: MIT License

import SwiftUI
import Combine

typealias ButtonPress = Int

struct DoubleShakeDetectionView: View
{
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
    @ObservedObject var detectorsViewModel: DetectorsViewModel
    @EnvironmentObject var appRunnerViewModel: AppRunnerViewModel
    @State private var shouldExpand: Bool
    @State private var animationValue: Int
    @State var cancellables = Set<AnyCancellable>()
    let motionEventViewRunner: any TimeChangerProtocol

    init(
        hapticGenerator: HapticGeneratorProtocol?,
        motionEventViewModel: MotionEventViewModel,
        detectorsViewModel: DetectorsViewModel
    )
    {
        self.hapticGenerator = hapticGenerator
        self.motionEventViewModel = motionEventViewModel
        self.axis = motionEventViewModel.motionDetector.monitorAxis
        _shouldExpand = State(initialValue: true)
        _animationValue = State(initialValue: 0)
        self.detectorsViewModel = detectorsViewModel
        self.motionEventViewRunner =
            MotionEventViewRunner(runnableViewModel: motionEventViewModel)
    }

    var descriptiveText: some View
    {
        Text("Testing Accelerometer\nfor Double Shake Motion")
            .multilineTextAlignment(.center)
            .font(.title2)
    }

    var secondaryDescriptiveText: some View
    {
        Text("The motion can be used as a non-screen-based gesture in apps.")
            .font(.caption)
            .padding(padding)
    }

    var testErrorButton: some View
    {
        // Test error button
        Button
        {
            motionEventViewModel.motionDetector
                .motionEventStream?.sendMotionError(error: .testError)
        } label:
        {
            Text(testErrorText)
        }
    }

    var monitoringButton: some View
    {
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
            } label:
            {
                switch motionEventViewModel.monitoringButtonState
                {
                case .started: buttonLabel(motionEventViewModel.monitoringButtonState)
                case .notStarted: buttonLabel(motionEventViewModel.monitoringButtonState)
                }
            }
            Spacer().frame(maxHeight: Setting.higButtonHeight)
        }.if(Setting.shouldDebugLayout) { $0.border(.pink) }
        .buttonStyle(RoundedButton(
            isActivated: motionEventViewModel.monitoringButtonState == .started)
        )
    }

    var body: some View
    {
        print("button state is \(motionEventViewModel.monitoringButtonState)",
            "for axis \(motionEventViewModel.motionDetector.monitorAxis)")
        return VStack(spacing: Setting.vspace)
        {
            Spacer()
            descriptiveText
            secondaryDescriptiveText
            testErrorButton
            Spacer()
            // Axis view
            AxisView(
                motionEventViewModel: motionEventViewModel
            )
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
            monitoringButton
        }.if(Setting.shouldDebugLayout) { $0.border(.green) }
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
        .onChange(of: appRunnerViewModel.shouldRunDetectionView)
        { shouldRun in
            motionEventViewRunner.appRunnerShouldRun(shouldRun: shouldRun)
        }
        .onAppear()
        {
            motionEventViewRunner.appRunnerShouldRun(
                shouldRun: appRunnerViewModel.shouldRunDetectionView
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
