// SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
// SPDX-License-Identifier: MIT License

import Foundation

extension DoubleShakeDetector
{
    func mean(values: [Double]) -> Double
    {
        var total = 0.0

        for value in values
        {
            total += value
        }

        return total / Double(values.count)
    }

    func standardDeviation(values: [Double]) -> Double
    {
        let mean = mean(values: values)
        var sumOfSquaredDifferences = 0.0
        var difference = 0.0

        for value in values
        {
            difference = value - mean
            sumOfSquaredDifferences += difference * difference
        }

        return sqrt(sumOfSquaredDifferences / Double(values.count))
    }
}
