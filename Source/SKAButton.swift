//
//  SKAButton.swift
//  SKAToolKit
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

/// SKAControlState Possible states for the SKAButton
/// - Note: Normal - No States are active on the button
///
/// Highlighted - Button is being touched
///
/// Selected - Button in selected state
///
/// Disabled - Button in disabled state, will ignore SKAControlEvents
struct SKAControlState: OptionSetType, Hashable {
  let rawValue: Int
  let key: String
  init(rawValue: Int) {
    self.rawValue = rawValue
    self.key = "\(rawValue)"
  }
  
  static var Normal:       SKAControlState { return SKAControlState(rawValue: 0 << 0) }
  static var Highlighted:  SKAControlState { return SKAControlState(rawValue: 1 << 0) }
  static var Selected:     SKAControlState { return SKAControlState(rawValue: 1 << 1) }
  static var Disabled:     SKAControlState { return SKAControlState(rawValue: 1 << 2) }
  static var AllOptions: [SKAControlState] {
    return [.Normal, .Highlighted, .Selected, .Disabled]
  }
  var hashValue: Int {
    return rawValue.hashValue
  }
}

/// Insets for the texture/color of the node
///
/// - Note: Inset direction will move the texture/color towards that edge at the given amount.
///
/// - SKButtonEdgeInsets(top: 10, right: 0, bottom: 0, left: 0)
///   Top will move the texture/color towards the top
/// - SKButtonEdgeInsets(top: 10, right: 0, bottom: 10, left: 0)
///   Top and Bottom will cancel each other out
struct SKButtonEdgeInsets {
  let top:CGFloat
  let right:CGFloat
  let bottom:CGFloat
  let left:CGFloat
  
  init() {
    top = 0
    right = 0
    bottom = 0
    left = 0
  }
  
  init(top:CGFloat, right:CGFloat, bottom:CGFloat, left:CGFloat) {
    self.top = top
    self.right = right
    self.bottom = bottom
    self.left = left
  }
}

/// SKSpriteNode set up to mimic the utility of UIButton
/// - Note: Supports Texture per state, normal Texture per state, and color per state
class SKAButtonSprite : SKAControlSprite {
  private var textures = [SKAControlState: SKTexture]()
  private var normalTextures = [SKAControlState: SKTexture]()
  private var colors = [SKAControlState: SKColor]()
  private var backgroundColor = SKColor.clearColor()
  private var childNode: SKSpriteNode //Child node to act as our real node, the child node gets all of the updates the normal node would, and we keep the actual node as a clickable area only.
  
  /// Will restore the size of the texture node to the button size every time the button is updated
  var restoreSizeAfterAction = true
  var touchTarget:CGSize
  
  // MARK: - Initializers
  
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    childNode = SKSpriteNode(texture: nil, color: color, size: size)
    touchTarget = size
    super.init(texture: texture, color: color, size: size)
    self.addChild(childNode)
  }
  
  required init?(coder aDecoder: NSCoder) {
    childNode = SKSpriteNode()
    touchTarget = CGSize()
    super.init(coder: aDecoder)
    self.addChild(childNode)
  }
  
  /// Update the button based on the state of the button. Since the button can hold more than one state at a time,
  /// determine the most important state and display the correct texture/color
  /// - Note: Disabled > Highlighted > Selected > Normal
  /// - Warning: SKActions will override setting the textures
  /// - Returns: void
  override func updateControl() {
    var newNormalTexture:SKTexture?
    var newTexture:SKTexture?
    var newColor = childNode.color
    
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
    }  else if let normalColor = colors[.Normal] {
      newColor = normalColor
    }
    
    if newNormalTexture == nil {
      newNormalTexture = normalTextures[.Normal]
    }
    
    if newTexture == nil {
      newTexture = textures[.Normal]
    }
    childNode.normalTexture = newNormalTexture
    childNode.texture = newTexture
    childNode.color = newColor
    
    if restoreSizeAfterAction {
      childNode.size = childNode.size
    }
  }
  
  // MARK: - Control States
  
  /// Sets the node's background color for the specified control state
  /// - Parameter color: The specified color
  /// - Parameter state: The specified control state to trigger the color change
  /// - Returns: void
  func setColor(color:SKColor, forState state:SKAControlState) {
    colors[state] = color
    updateControl()
  }
  
  /// Sets the node's texture for the specified control state
  /// - Parameter texture: The specified texture, if nil it clears the texture for the control state
  /// - Parameter state: The specified control state to trigger the texture change
  /// - Returns: void
  func setTexture(texture:SKTexture?, forState state:SKAControlState) {
    if let texture = texture {
      textures[state] = texture
    } else {
      textures.removeValueForKey(state)
    }
    
    updateControl()
  }
  
  /// Sets the node's normal texture for the specified control state
  /// - Parameter texture: The specified texture, if nil it clears the texture for the control state
  /// - Parameter state: The specified control state to trigger the normal texture change
  /// - Returns: void
  func setNormalTexture(texture:SKTexture?, forState state:SKAControlState) {
    if let texture = texture {
      normalTextures[state] = texture
    } else {
      normalTextures.removeValueForKey(state)
    }
    
    updateControl()
  }
  
  /// Private variable to tell us when to update the button size or the child size
  private var updatingTargetSize = false
  
  /// Insets for the texture/color of the node
  ///
  /// - Note: Inset direction will move the texture/color towards that edge at the given amount.
  ///
  /// - SKButtonEdgeInsets(top: 10, right: 0, bottom: 0, left: 0)
  ///   Top will move the texture/color towards the top
  /// - SKButtonEdgeInsets(top: 10, right: 0, bottom: 10, left: 0)
  ///   Top and Bottom will cancel each other out
  var insets = SKButtonEdgeInsets() {
    didSet{
      childNode.position = CGPoint(x: -insets.left + insets.right, y: -insets.bottom + insets.top)
    }
  }
  
  /// Sets the touchable area for the button
  /// - Parameter size: The size of the touchable area
  /// - Returns: void
  func setButtonTargetSize(size:CGSize) {
    updatingTargetSize = true
    self.size = size
  }
  
  /// Sets the touchable area for the button
  /// - Parameter size: The size of the touchable area
  /// - Parameter insets: The edge insets for the texture/color of the node
  /// - Returns: void
  /// - Note: Inset direction will move the texture/color towards that edge at the given amount.
  func setButtonTargetSize(size:CGSize, insets:SKButtonEdgeInsets) {
    self.insets = insets
    self.setButtonTargetSize(size)
  }
  
  /// MARK: Override basic functions and pass them to our child node, this leaves the button as a colorless touchable area
  
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
