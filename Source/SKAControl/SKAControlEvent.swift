//
//  SKAControlEvent.swift
//  SKAButton
//
//  Copyright (c) 2015 Sprite Kit Alliance
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import Foundation

/**
 SKAControlEvent Mimics the usefulness of UIControl class
 - Note: None - Used internally only

 TouchDown - User Touches Down on the button

 TouchUpInside - User releases Touch inside the bounds of the button

 TouchUpOutside - User releases Touch outside the bounds of the button

 DragOutside - User Drags touch from outside the bounds of the button and stays outside

 DragInside - User Drags touch from inside the bounds of the button and stays inside

 DragEnter - User Drags touch from outside the bounds of the button to inside the bounds of the button

 DragExit - User Drags touch from inside the bounds of the button to outside the bounds of the button
 */
struct SKAControlEvent: OptionSetType, Hashable {
  let rawValue: Int
  init(rawValue: Int) { self.rawValue = rawValue }

  static var None:           SKAControlEvent   { return SKAControlEvent(rawValue: 0) }
  static var TouchDown:      SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 0) }
  static var TouchUpInside:  SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 1) }
  static var TouchUpOutside: SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 2) }
  static var DragOutside:    SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 3) }
  static var DragInside:     SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 4) }
  static var DragEnter:      SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 5) }
  static var DragExit:       SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 6) }
  static var TouchCancelled: SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 7) }
  static var AllOptions:     [SKAControlEvent] {
    return [.TouchDown, .TouchUpInside, .TouchUpOutside, .DragOutside, .DragInside, .DragEnter, .DragExit, .TouchCancelled]
  }

  var hashValue: Int {
    return rawValue.hashValue
  }
}