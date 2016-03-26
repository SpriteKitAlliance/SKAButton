//
//  SKAControl.swift
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
import SpriteKit

/// SKSpriteNode set up to mimic the utility of UIControl
class SKAControlSprite : SKSpriteNode {
  internal var selectors = [SKAControlEvent: [SKASelector]]()

  /// Save a touch to help determine if the touch just entered or exited the node
  internal var lastEvent:SKAControlEvent = .None

  /**
   Current State of the button
   - Note: ReadOnly
   */
  internal(set) var controlState:SKAControlState = .Normal {
    didSet {
      if oldValue != controlState {
        updateControl()
      }
    }
  }
  
  /**
   Sets the button to the selected state
   - Note: If an SKAction is taking place, the selected state may not show properly
   */
  var selected:Bool {
    get {
      return controlState.contains(.Selected)
    }
    set(newValue) {
      if newValue {
        controlState.insert(.Selected)
      } else {
        controlState.subtractInPlace(.Selected)
      }
    }
  }
  
  /**
   Sets the button to the enabled/disabled state. In a disabled state, the button will not trigger selectors
   - Note: If an SKAction is taking place, the disabled state may not show properly
   */
  var enabled:Bool {
    get {
      return !controlState.contains(.Disabled)
    }
    set(newValue) {
      if newValue {
        controlState.subtractInPlace(.Disabled)
      } else {
        controlState.insert(.Disabled)
      }
    }
  }
}