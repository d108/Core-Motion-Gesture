/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

protocol TimeChangerProtocol: AppRunnerProtocol
{
    associatedtype EventType

    func appRunnerShouldRun(shouldRun: Bool)
    func runTimer()
    func cancelAll()
}

extension TimeChangerProtocol
{
    func appRunnerShouldRun(shouldRun: Bool)
    {
        if shouldRun
        {
            runTimer()
        } else
        {
            cancelAll()
        }
    }
}
