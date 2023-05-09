import SwiftUI

struct AnimationFactory
{
    static func lessBounce() -> Animation
    {
        Animation.interpolatingSpring(stiffness: 300, damping: 15)
    }

    static func moreBounce() -> Animation
    {
        Animation.interpolatingSpring(stiffness: 300, damping: 5)
    }
}
