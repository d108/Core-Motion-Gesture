# Core Motion Double Z-Shake Gesture Detection Demo

![double-z-shake-demo.png](image%2Fdouble-z-shake-demo.png)

We use the accelerometer to detect a custom gesture of a user shaking their device in a double Z-shaking motion.
The Z-axis for an iPhone or iPad corresponds to a perpendicular line projected through the face of the screen when it is positioned parallel to the ground, like a tabletop.
We require a double motion to identify a user's signal in a noisy background of detections sensitive to small movements.

- We show a waveform image when we detect a double Z-shake motion.
- The motion can be made with a crisp, double wrist flick, with the final move a little snappier, within a given time window.
- We generate haptic feedback when a gesture is successfully detected.

Please find some notes about the detector listed below.

- The detector has parameters for fine-tuning the gesture.
- Continuously monitoring the accelerometer results in constant CPU usage, about 6%, as measured by Xcode's CPU monitor.

## Install

    $ git clone https://github.com/d108/CoreMotionGesture.git
    $ cd CoreMotionGesture
    $ open CoreMotionGesture.xcodeproj

## Project notes

- SwiftUI and Combine
- MVVM
- Minimum deployment = iOS 14.0

## License

Copyright (c) 2023 Daniel Zhang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
