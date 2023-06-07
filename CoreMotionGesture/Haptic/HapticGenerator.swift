/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

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
