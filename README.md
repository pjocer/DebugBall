# DebugBall

[![CI Status](http://img.shields.io/travis/pjocer/DebugBall.svg?style=flat)](https://travis-ci.org/pjocer/DebugBall)
[![Version](https://img.shields.io/cocoapods/v/DebugBall.svg?style=flat)](http://cocoapods.org/pods/DebugBall)
[![License](https://img.shields.io/cocoapods/l/DebugBall.svg?style=flat)](http://cocoapods.org/pods/DebugBall)
[![Platform](https://img.shields.io/cocoapods/p/DebugBall.svg?style=flat)](http://cocoapods.org/pods/DebugBall)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DebugBall is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DebugBall"
```

## Usage

```objc
#ifdef DEBUG
DebugView.debugView.commitTapAction(kDebugViewTapActionDisplayBorder).show();
#endif
```

**Discussion**

I recommend using the default values I used above.

## Author

pjocer, pjocer@outlook.com

## License

DebugBall is available under the MIT license. See the LICENSE file for more info.
