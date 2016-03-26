//
//  SKAEdgeInsets.swift
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

/**
 Insets for the texture/color of the node
 - Note: Inset direction will move the texture/color towards that edge at the given amount.

 - SKButtonEdgeInsets(top: 10, right: 0, bottom: 0, left: 0)
 Top will move the texture/color towards the top
 - SKButtonEdgeInsets(top: 10, right: 0, bottom: 10, left: 0)
 Top and Bottom will cancel each other out
 */
struct SKButtonEdgeInsets {
  let top:CGFloat
  let right:CGFloat
  let bottom:CGFloat
  let left:CGFloat

  init() {
    top = 0.0
    right = 0.0
    bottom = 0.0
    left = 0.0
  }

  init(top:CGFloat, right:CGFloat, bottom:CGFloat, left:CGFloat) {
    self.top = top
    self.right = right
    self.bottom = bottom
    self.left = left
  }
}
