import UIKit

protocol HapticGeneratorProtocol
{
    func generateFeedback()
}

struct HapticGenerator: HapticGeneratorProtocol
{
    let generator: UINotificationFeedbackGenerator

    init(generator: UINotificationFeedbackGenerator)
    {
        self.generator = generator
    }

    func generateFeedback()
    {
        generator.notificationOccurred(.success)
    }
}
