/*
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import SwiftUI

struct AxisView: View
{
    let visible: CGFloat = 100
    let invisible: CGFloat = 0
    let axisFontSize: CGFloat = 96
    let circleWidth: CGFloat = 200
    let circleLinewidth: CGFloat = 4
    let circleColor: Color = .orange
    let axis: MonitorAxis
    let waveHeightStart: CGFloat = 1.0
    let waveHeightEnd: CGFloat = 1.3
    @ObservedObject var motionEventViewModel: MotionEventViewModel

    init(
        motionEventViewModel: MotionEventViewModel
    )
    {
        self.motionEventViewModel = motionEventViewModel
        axis = motionEventViewModel.motionDetector.monitorAxis
    }

    var wave: some View
    {
        // Wave view
        Group
        {
            Image(systemName: MonitoringSystemImage.doubleShaked.rawValue)
                .resizable(resizingMode: .stretch)
                .scaleEffect(motionEventViewModel.doubleShaked
                    ? CGSize(width: 1.0, height: waveHeightStart) :
                    CGSize(width: 1.0, height: waveHeightEnd))
                .animation(AnimationFactory.moreBounce().delay(0.2)
                    .repeatForever())
        }.opacity(motionEventViewModel.doubleShaked ? visible : invisible)
    }

    var axisLabel: some View
    {
        // Axis label view
        Text(motionEventViewModel.motionDetector.monitorAxis.asText())
            .font(.system(size: axisFontSize))
            .foregroundColor(circleColor)
            .overlay(Circle()
                .stroke(circleColor, lineWidth: circleLinewidth)
                .frame(width: circleWidth))
    }

    var body: some View
    {
        ZStack
        {
            wave
            axisLabel
        }.if(Setting.shouldDebugLayout) { $0.border(.purple) }
    }
}
