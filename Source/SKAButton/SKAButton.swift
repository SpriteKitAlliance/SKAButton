//
//  SKAButton.swift
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
 SKSpriteNode set up to mimic the utility of UIButton
 - Note: Supports Texture per state, normal Texture per state, and color per state
 */
class SKAButtonSprite : SKAControlSprite {
  internal var textures = [SKAControlState: SKTexture]()
  internal var normalTextures = [SKAControlState: SKTexture]()
  internal var colors = [SKAControlState: SKColor]()
  internal var colorBlendFactors = [SKAControlState: CGFloat]()
  internal var backgroundColor = SKColor.clearColor()
  internal var childNode: SKSpriteNode //Child node to act as our real node, the child node gets all of the updates the normal node would, and we keep the actual node as a clickable area only.
  
  /// Will restore the size of the texture node to the button size every time the button is updated
  var restoreSizeAfterAction = true
  var touchTarget:CGSize

  var darkenAmount:CGFloat = 0.2 {
    didSet {
      if darkenAmount < 0 {
        darkenAmount = abs(darkenAmount)
      }
    }
  }

  var lightenAmount:CGFloat = 0.2 {
    didSet {
      if lightenAmount < 0 {
        lightenAmount = abs(lightenAmount)
      }
    }
  }
  
  // MARK: - Initializers
  
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    childNode = SKSpriteNode(texture: nil, color: color, size: size)
    touchTarget = size

    super.init(texture: texture, color: color, size: size)
    
    ///Set the default color and texture for Normal State
    setColor(color, forState: .Normal)
    setTexture(texture, forState: .Normal)
    setColorBlendFactor(0.0, forState: .Normal)
    self.addChild(childNode)
  }
  
  /**
   Use this method for initing with normal Map textures, SKSpriteNode's version will not persist the .Normal Textures correctly
   */
  convenience init(texture: SKTexture?, normalMap: SKTexture?) {
    self.init(texture: texture, color: UIColor.clearColor(), size: texture?.size() ?? CGSize())
    setNormalTexture(normalMap, forState: .Normal)
  }
  
  required init?(coder aDecoder: NSCoder) {
    childNode = SKSpriteNode()
    touchTarget = CGSize()

    super.init(coder: aDecoder)

    self.addChild(childNode)
  }
  
  /**
   Update the button based on the state of the button. Since the button can hold more than one state at a time,
   determine the most important state and display the correct texture/color
   - Note: Disabled > Highlighted > Selected > Normal
   - Warning: SKActions can override setting the textures
   - Returns: void
   */
  override func updateControl() {
    var newNormalTexture:SKTexture?
    var newTexture:SKTexture?
    var newColor = childNode.color
    var newColorBlendFactor = colorBlendFactors[.Normal] ?? colorBlendFactor
    
    if controlState.contains(.Disabled) {
      if let disabledNormal = normalTextures[.Disabled] {
        newNormalTexture = disabledNormal
      }
      
      if let disabled = textures[.Disabled] {
        newTexture = disabled
      }
      
      if let disabledColor = colors[.Disabled] {
        newColor = disabledColor
      }
      
      if let colorBlend = colorBlendFactors[.Disabled] {
        newColorBlendFactor = colorBlend
      }
    } else if controlState.contains(.Highlighted){
      if let highlightedNormal = normalTextures[.Highlighted] {
        newNormalTexture = highlightedNormal
      }
      
      if let highlighted = textures[.Highlighted] {
        newTexture = highlighted
      }
      
      if let highlightedColor = colors[.Highlighted] {
        newColor = highlightedColor
      }
      
      if let colorBlend = colorBlendFactors[.Highlighted] {
        newColorBlendFactor = colorBlend
      }
    } else if controlState.contains(.Selected) {
      if let selectedNormal = normalTextures[.Selected] {
        newNormalTexture = selectedNormal
      }
      
      if let selected = textures[.Selected] {
        newTexture = selected
      }
      
      if let selectedColor = colors[.Selected] {
        newColor = selectedColor
      }
      
      if let colorBlend = colorBlendFactors[.Selected] {
        newColorBlendFactor = colorBlend
      }
    }  else {
      //If .Normal
      if let normalColor = colors[.Normal] {
        newColor = normalColor
      }
      
      if let colorBlend = colorBlendFactors[.Normal] {
        newColorBlendFactor = colorBlend
      }
    }
    
    //Don't need to check if .Normal for textures, if nil set to .Normal textures
    if newNormalTexture == nil {
      newNormalTexture = normalTextures[.Normal]
    }
    
    if newTexture == nil {
      newTexture = textures[.Normal]
    }
    
    childNode.normalTexture = newNormalTexture
    childNode.texture = newTexture
    childNode.color = newColor
    childNode.colorBlendFactor = newColorBlendFactor
    
    if restoreSizeAfterAction {
      childNode.size = childNode.size
    }
  }

  /// Private variable to tell us when to update the button size or the child size
  private var updatingTargetSize = false
  
  /**
   Insets for the texture/color of the node
   
   - Note: Inset direction will move the texture/color towards that edge at the given amount.
   
   - SKButtonEdgeInsets(top: 10, right: 0, bottom: 0, left: 0)
   Top will move the texture/color towards the top
   - SKButtonEdgeInsets(top: 10, right: 0, bottom: 10, left: 0)
   Top and Bottom will cancel each other out
   */
  var insets = SKButtonEdgeInsets() {
    didSet{
      childNode.position = CGPoint(x: -insets.left + insets.right, y: -insets.bottom + insets.top)
    }
  }
  
  /**
   Sets the touchable area for the button
   - Parameter size: The size of the touchable area
   - Returns: void
   */
  func setButtonTargetSize(size:CGSize) {
    updatingTargetSize = true
    self.size = size
  }
  
  /**
   Sets the touchable area for the button
   - Parameter size: The size of the touchable area
   - Parameter insets: The edge insets for the texture/color of the node
   - Returns: void
   - Note: Inset direction will move the texture/color towards that edge at the given amount.
   */
  func setButtonTargetSize(size:CGSize, insets:SKButtonEdgeInsets) {
    self.insets = insets
    self.setButtonTargetSize(size)
  }
  
  // MARK: Shortcuts
  
  /**
  Shortcut to handle button highlighting
  
  Sets the colorBlendFactor to 0.2 for the Hightlighted State
  Sets the color to a slightly lighter version of the Normal State color for the Highlighted State
  */
  func setAdjustsSpriteOnHighlight() {
    setColorBlendFactor(0.2, forState: .Highlighted)
    setColor(lightenColor(colors[.Normal] ?? color), forState: .Highlighted)
  }
  
  /**
   Shortcut to handle button disabling
   
   Sets the colorBlendFactor to 0.2 for the Disabled State
   Sets the color to a slightly darker version of the Normal State color for the Disabled State
   */
  func setAdjustsSpriteOnDisable() {
    setColorBlendFactor(0.2, forState: .Disabled)
    setColor(darkenColor(colors[.Normal] ?? color), forState: .Disabled)
  }
  
  // MARK: Override basic functions and pass them to our child node
  
  override func actionForKey(key: String) -> SKAction? {
    return childNode.actionForKey(key)
  }
  
  override func runAction(action: SKAction) {
    childNode.runAction(action)
  }
  
  override func runAction(action: SKAction, completion block: () -> Void) {
    childNode.runAction(action, completion: block)
  }
  
  override func runAction(action: SKAction, withKey key: String) {
    childNode.runAction(action, withKey: key)
  }
  
  override func removeActionForKey(key: String) {
    childNode.removeActionForKey(key)
    updateControl()
  }
  
  override func removeAllActions() {
    childNode.removeAllActions()
    updateControl()
  }
  
  override func removeAllChildren() {
    childNode.removeAllChildren()
  }
  
  override var texture: SKTexture? {
    get {
      return childNode.texture
    }

    set {
      childNode.texture = newValue
    }
  }
  
  override var normalTexture: SKTexture? {
    get {
      return childNode.normalTexture
    }

    set {
      childNode.normalTexture = newValue
    }
  }
  
  override var color: SKColor {
    get {
      return childNode.color
    }

    set {
      super.color = SKColor.clearColor()
      childNode.color = newValue
    }
  }
  
  override var colorBlendFactor: CGFloat {
    get {
      return childNode.colorBlendFactor
    }
    
    set {
      super.colorBlendFactor = 0.0
      childNode.colorBlendFactor = newValue
    }
  }
  
  override var size: CGSize {
    willSet {
      if updatingTargetSize {
        if self.size != newValue {
          super.size = newValue
        }
        
        updatingTargetSize = false
      } else {
        childNode.size = newValue
      }
    }
  }
    
  /// Remove unneeded textures
  deinit {
    textures.removeAll()
    normalTextures.removeAll()
    removeAllChildren()
  }
}
