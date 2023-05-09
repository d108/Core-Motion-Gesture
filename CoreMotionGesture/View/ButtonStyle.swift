import SwiftUI

struct RoundedButton: ButtonStyle
{
    var activated: Bool

    func makeBody(configuration: Configuration) -> some View
    {
        configuration.label
            .padding()
            .background(activated ? Color.red : Color.clear)
            .foregroundColor(activated ? Color.black : Color.accentColor)
            .clipShape(Capsule())
            .frame(height: Setting.higButtonHeight)
    }
}
