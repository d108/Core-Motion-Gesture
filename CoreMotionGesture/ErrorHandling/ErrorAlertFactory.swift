// SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
// SPDX-License-Identifier: MIT License

import SwiftUI

// For future error management.
struct ErrorAlert: Identifiable
{
    var id = UUID()
    var message: String
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
    )
    {
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
                self.detectorsViewModel.resetDetectorViewIDForError(axis: axis)
            }
        )
    }
}
