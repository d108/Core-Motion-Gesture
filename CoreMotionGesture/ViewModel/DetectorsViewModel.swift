/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import SwiftUI

/// For managing detector view IDs.
protocol DetectorViewIDsProtocol
{
    func resetDetectorViewID(axis: MonitorAxis)
}

/// Track IDs for detector views.
final class DetectorsViewModel: ObservableObject, DetectorViewIDsProtocol
{
    @Published var detectionViewIDs: [MonitorAxis: UUID]
    @Published var axisViewIDs: [MonitorAxis: UUID]
    @Published var lastDetectionViewIDForError: UUID?

    let idsDictionary: ()
        -> [MonitorAxis: UUID] =
        {
            var ids = [MonitorAxis: UUID]()

            MonitorAxis.allCases.forEach
            {
                ids[$0] = UUID()
            }

            return ids
        }

    init()
    {
        _detectionViewIDs = Published(initialValue: idsDictionary())
        _axisViewIDs = Published(initialValue: idsDictionary())
    }

    func resetDetectorViewID(axis: MonitorAxis)
    {
        print("reset detector view")
        detectionViewIDs[axis] = UUID()
    }

    /// Record the last detector view ID used to display an error.
    /// It allows us to disable animation when the view is reloaded.
    func resetDetectorViewIDForError(axis: MonitorAxis)
    {
        let id = UUID()
        detectionViewIDs[axis] = id
        lastDetectionViewIDForError = id
    }
}
