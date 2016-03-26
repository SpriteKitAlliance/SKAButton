//
//  SKAButton+Color.swift
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

extension SKAButtonSprite {
  /**
   Takes a color and slightly darkens it (if it can)
   - Parameter color: Color to darken
   - Returns: UIColor - Darkened Color
   */
  internal func darkenColor(color: SKColor) -> SKColor {
    var redComponent: CGFloat = 0.0
    var blueComponent: CGFloat = 0.0
    var greenComponent: CGFloat = 0.0
    var alphaComponent: CGFloat = 0.0

    if color.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent) {
      let defaultValue: CGFloat = 0.0

      redComponent = max(redComponent - 0.2, defaultValue)
      blueComponent = max(blueComponent - 0.2, defaultValue)
      greenComponent = max(greenComponent - 0.2, defaultValue)
      alphaComponent = max(alphaComponent - 0.2, defaultValue)

      return UIColor(colorLiteralRed: Float(redComponent),
                     green: Float(greenComponent),
                     blue: Float(blueComponent),
                     alpha: Float(alphaComponent))
    } else {
      return color
    }
  }

  /**
   Takes a color and slightly lightens it (if it can)
   - Parameter color: Color to darken
   - Returns: UIColor - Lightened Color
   */
  internal func lightenColor(color: SKColor) -> SKColor {
    var redComponent: CGFloat = 1.0
    var blueComponent: CGFloat = 1.0
    var greenComponent: CGFloat = 1.0
    var alphaComponent: CGFloat = 1.0

    if color.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent) {
      let defaultValue: CGFloat = 1.0

      redComponent = min(redComponent + 0.2, defaultValue)
      blueComponent = min(blueComponent + 0.2, defaultValue)
      greenComponent = min(greenComponent + 0.2, defaultValue)
      alphaComponent = min(alphaComponent + 0.2, defaultValue)

      return UIColor(colorLiteralRed: Float(redComponent),
                     green: Float(greenComponent),
                     blue: Float(blueComponent),
                     alpha: Float(alphaComponent))
    } else {
      return color
    }
  }
}
