import SwiftUI

// For managing detector view IDs.
protocol DetectorViewIDsProtocol
{
    func resetDetectorViewID(axis: MonitorAxis)
}

// Track IDs for detector views.
final class DetectorsViewModel: ObservableObject, DetectorViewIDsProtocol
{
    @Published var detectionViewIDs: [MonitorAxis: UUID]

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
    }

    func resetDetectorViewID(axis: MonitorAxis)
    {
        detectionViewIDs[axis] = UUID()
    }
}
