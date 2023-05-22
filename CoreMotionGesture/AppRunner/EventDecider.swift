/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

typealias Probability = Float

struct EventDecider
{
    static func random(with probability: Probability) -> Bool
    {
        return Float.random(in: 0...1) <= probability
    }
}
