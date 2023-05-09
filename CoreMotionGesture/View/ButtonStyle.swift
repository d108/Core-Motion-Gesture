import SwiftUI

struct RoundedButton: ButtonStyle
{
    var activated: Bool

    func makeBody(configuration: Configuration) -> some View
    {
        configuration.label
            .padding()
            .background(activated ? Color.red:
                Setting.debugLayout ? Color.red : Color.clear)
            .foregroundColor(activated ? Color.black:
                Setting.debugLayout ? Color.black : Color.accentColor)
            .clipShape(Capsule())
            .frame(height: Setting.higButtonHeight)
    }
}
