import SwiftUI

struct RoundedButton: ButtonStyle
{
    var isActivated: Bool

    func makeBody(configuration: Configuration) -> some View
    {
        configuration.label
            .padding()
            .background(isActivated ? Color.red : Color.clear)
            .foregroundColor(isActivated ? Color.black : Color.accentColor)
            .clipShape(Capsule())
            .frame(height: Setting.higButtonHeight)
    }
}
