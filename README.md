# BoundarySlider

[![Version](https://img.shields.io/cocoapods/v/BoundarySlider.svg?style=flat)](https://cocoapods.org/pods/BoundarySlider)
[![Licence](https://img.shields.io/cocoapods/l/BoundarySlider.svg?style=flat)](https://cocoapods.org/pods/BoundarySlider)
[![Platform](https://img.shields.io/cocoapods/p/BoundarySlider.svg?style=flat)](https://cocoapods.org/pods/BoundarySlider)

![Slider](Screenshot/slider.gif)

## Feature

 1. Multiple boundary
 2. Buffer view like youtube video buffer
 3. Seek support
 4. Customizable thumb image (Not yet)
 5. Haptic support if reach boundary (Not yet)
 6. Min, Max value label (Not yet)
 7. Min, Max value label position like top, middle, bottom (Not yet)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### CocoaPods

BoundarySlider is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BoundarySlider'
```

### Swift Package manager (SPM)

BoundarySlider is available through [SPM](https://github.com/AnbalaganD/BoundarySlider). Use below URL to add as a dependency

```swift
dependencies: [
    .package(url: "https://github.com/AnbalaganD/BoundarySlider", .upToNextMajor(from: "0.1.1"))
]
```

## Usage
```swift
import BoundarySlider

// Configure
let boundarySlider = BoundarySlider()
boundarySlider.minimumValue = 0.0
boundarySlider.maximumValue = 100.0
boundarySlider.trackColor = .gray
boundarySlider.fillTrackColor = .red
boundarySlider.bufferTrackColor = .init(white: 1.0, alpha: 0.6)
boundarySlider.boundaryColor = .yellow
boundarySlider.boundaries = [
    12, 33, 45, 60, 76, 90, 99
]

// Change fill tracker value
boundarySlider.value = 50.0

// Changes Buffer value
boundarySlider.bufferValue = 60.0
```

## Author

[Anbalagan D](mailto:anbu94p@gmail.com)

## License

BoundarySlider is available under the MIT license. See the LICENSE file for more info.
