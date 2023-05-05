import SwiftUI

// For future error management.
struct ErrorAlert: Identifiable
{
    var id = UUID()
    var message: String
}

protocol MotionEventViewModelErrorAlertProtocol
{
    var showErrorAlert: Bool { get set }
    var motionErrors: [LocalizedError]? { get }
}

// For managing detector view IDs.
protocol DetectorViewIDsProtocol
{
    func resetDetectorViewID(axis: MonitorAxis)
}

struct ErrorAlertFactory
{
    var errorTitle = "An Error Occurred"
    var unknownError = "Detection has stopped"
    var okay = "Okay"
    var motionEventViewModel: MotionEventViewModelErrorAlertProtocol
    var detectorsViewModel: DetectorsViewModel

    init(
        motionEventViewModel: MotionEventViewModelErrorAlertProtocol,
        detectorsViewModel: DetectorsViewModel
    ) {
        self.motionEventViewModel = motionEventViewModel
        self.detectorsViewModel = detectorsViewModel
    }

    func errorAlert(message: String = "", axis: MonitorAxis) -> Alert
    {
        return Alert(
            title: Text(errorTitle),
            message: Text(
                motionEventViewModel.motionErrors?
                    .first?.failureReason ?? unknownError),
            dismissButton: .default(Text(okay))
            {
                self.detectorsViewModel.resetDetectorViewID(axis: axis)
            }
        )
    }
}
