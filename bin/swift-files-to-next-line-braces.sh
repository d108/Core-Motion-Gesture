#!/bin/bash
# With https://github.com/nicklockwood/SwiftFormat
find . -iname *.swift -exec swiftformat --config .swiftformat {} \;