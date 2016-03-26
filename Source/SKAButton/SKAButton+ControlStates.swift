//
//  SKAButtonControlStates.swift
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
   Sets the node's background color for the specified control state
   - Parameter color: The specified color
   - Parameter state: The specified control state to trigger the color change
   - Returns: void
   */
  func setColor(color:SKColor?, forState state:SKAControlState) {
    if let color = color {
      colors[state] = color
    } else {
      for controlState in SKAControlState.AllOptions {
        if colors.keys.contains(controlState) {
          colors.removeValueForKey(controlState)
        }
      }
    }

    updateControl()
  }

  /**
   Sets the node's colorBlendFactor for the specified control state
   - Parameter colorBlend: The specified colorBlendFactor
   - Parameter state: The specefied control state to trigger the color change
   - Returns: void
   */
  func setColorBlendFactor(colorBlend:CGFloat?, forState state:SKAControlState){
    if let colorBlend = colorBlend {
      colorBlendFactors[state] = colorBlend
    } else {
      for controlState in SKAControlState.AllOptions {
        if colorBlendFactors.keys.contains(controlState) {
          colorBlendFactors.removeValueForKey(controlState)
        }
      }
    }

    updateControl()
  }

  /**
   Sets the node's texture for the specified control state
   - Parameter texture: The specified texture, if nil it clears the texture for the control state
   - Parameter state: The specified control state to trigger the texture change
   - Returns: void
   */
  func setTexture(texture:SKTexture?, forState state:SKAControlState) {
    if let texture = texture {
      textures[state] = texture
    } else {
      for controlState in SKAControlState.AllOptions {
        if textures.keys.contains(controlState) {
          textures.removeValueForKey(controlState)
        }
      }
    }

    updateControl()
  }

  /**
   Sets the node's normal texture for the specified control state
   - Parameter texture: The specified texture, if nil it clears the texture for the control state
   - Parameter state: The specified control state to trigger the normal texture change
   - Returns: void
   */
  func setNormalTexture(texture:SKTexture?, forState state:SKAControlState) {
    if let texture = texture {
      normalTextures[state] = texture
    } else {
      for controlState in SKAControlState.AllOptions {
        if normalTextures.keys.contains(controlState) {
          normalTextures.removeValueForKey(controlState)
        }
      }
    }

    updateControl()
  }
}