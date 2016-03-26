//
//  SKAControl+Touch.swift
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

extension SKAControlSprite {
  // MARK: - Touch Methods

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let _ = touches.first as UITouch? where enabled {
      performSelectorsForEvent(.TouchDown)
      lastEvent = .TouchDown
      controlState.insert(.Highlighted)
    }
    super.touchesBegan(touches , withEvent:event)
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first as UITouch?, parent = parent where enabled {
      let currentLocation = (touch.locationInNode(parent))

      if lastEvent == .DragInside && !containsPoint(currentLocation) {
        ///Touch Moved Outside Node
        controlState.subtractInPlace(.Highlighted)
        performSelectorsForEvent(.DragExit)
        lastEvent = .DragExit
      } else if lastEvent == .DragOutside && containsPoint(currentLocation) {
        ///Touched Moved Inside Node
        controlState.insert(.Highlighted)
        performSelectorsForEvent(.DragEnter)
        lastEvent = .DragEnter
      } else if !containsPoint(currentLocation) {
        /// Touch stayed Outside Node
        performSelectorsForEvent(.DragOutside)
        lastEvent = .DragOutside
      } else if containsPoint(currentLocation) {
        ///Touch Stayed Inside Node
        performSelectorsForEvent(.DragInside)
        lastEvent = .DragInside
      }
    }

    super.touchesMoved(touches, withEvent: event)
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    lastEvent = .None
    if let touch = touches.first as UITouch?, parent = parent where enabled {
      if containsPoint(touch.locationInNode(parent)) {
        performSelectorsForEvent(.TouchUpInside)
      } else {
        performSelectorsForEvent(.TouchUpOutside)
      }

      controlState.subtractInPlace(.Highlighted)
    }

    super.touchesEnded(touches, withEvent: event)
  }

  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    lastEvent = .None
    if let _ = touches?.first as UITouch? {
      performSelectorsForEvent(.TouchCancelled)
    }

    super.touchesCancelled(touches, withEvent: event)
  }
}