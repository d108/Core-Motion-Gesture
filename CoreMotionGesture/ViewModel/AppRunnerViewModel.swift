import SwiftUI

final class AppRunnerViewModel: ObservableObject
{
    @Published var shouldRunTabView = false
    @Published var shouldRunDetectionView = false
}
