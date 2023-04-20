import SwiftUI

extension View
{
    // From https://stackoverflow.com/questions/72169600/swift-task-before-ios-15
    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func task(priority: TaskPriority = .userInitiated, _ action: @escaping @Sendable () async -> Void) -> some View
    {
        self.onAppear
        {
            Task(priority: priority)
            {
                await action()
            }
        }
    }
}
