//
//  SKAControl.swift
//  SKAButton
//
//  Created by Marc Vandehey on 10/5/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation
import SpriteKit

/// SKAControlEvent Mimics the usefulness of UIControl class
/// - Note: None - Used internally only
///
/// TouchDown - User Touches Down on the button
///
/// TouchUpInside - User releases Touch inside the bounds of the button
///
/// TouchUpOutside - User releases Touch outside the bounds of the button
///
/// DragOutside - User Drags touch from outside the bounds of the button and stays outside
///
/// DragInside - User Drags touch from inside the bounds of the button and stays inside
///
/// DragEnter - User Drags touch from outside the bounds of the button to inside the bounds of the button
///
/// DragExit - User Drags touch from inside the bounds of the button to outside the bounds of the button
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

/// Container for SKAControl Selectors
/// - Parameter target: target Object to call the selector on
/// - Parameter selector: Selector to call
struct SKASelector {
  let target: AnyObject
  let selector: Selector
}

/// SKSpriteNode set up to mimic the utility of UIControl
class SKAControlSprite : SKSpriteNode {
  private var selectors = [SKAControlEvent: [SKASelector]]()
  
  /// Current State of the button
  /// - Note: ReadOnly
  private(set) var controlState:SKAControlState = .Normal {
    didSet {
      if oldValue != controlState {
        updateControl()
      }
    }
  }
  
  /// Sets the button to the selected state
  /// - Note: If an SKAction is taking place, the selected state may not show properly
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
  
  /// Sets the button to the enabled/disabled state. In a disabled state, the button will not trigger selectors
  /// - Note: If an SKAction is taking place, the disabled state may not show properly
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

  // MARK: - Selector Events
  
  /// Add target for a SKAControlEvent. You may call this multiple times and you can specify multiple targets for any event.
  /// - Parameter target: Object the selecter will be called on
  /// - Parameter selector: The chosen selector for the event that is a member of the target
  /// - Parameter events: SKAControlEvents that you want to register the selector to
  /// - Returns: void
  func addTarget(target: AnyObject, selector: Selector, forControlEvents events: SKAControlEvent) {
    userInteractionEnabled = true
    let buttonSelector = SKASelector(target: target, selector: selector)
    addButtonSelector(buttonSelector, forControlEvents: events)
  }
  
  /// Add Selector(s) to our dictionary of actions based on the SKAControlEvent
  /// - Parameter buttonSelector: Internal struct containing the selector and the target
  /// - Parameter events: SKAControl event(s) associated to the selector
  /// - Returns: void
  private func addButtonSelector(buttonSelector: SKASelector, forControlEvents events: SKAControlEvent) {
    for option in SKAControlEvent.AllOptions where events.contains(option) {
      if var buttonSelectors = selectors[option] {
        buttonSelectors.append(buttonSelector)
        selectors[option] = buttonSelectors
      } else {
        selectors[option] = [buttonSelector]
      }
    }
  }
  
  /// Checks if there are any listed selectors for the control event, and performs them
  /// - Parameter event: Single control event
  /// - Returns: void
  private func performSelectorsForEvent(event:SKAControlEvent) {
    guard let selectors = selectors[event] else { return }
    performSelectors(selectors)
  }
  
  /// Loops through the selected actions and performs the selectors associated to them
  /// - Parameter buttonSelectors: buttonSelectors Array of button selectors to perform
  /// - Returns: void
  private func performSelectors(buttonSelectors: [SKASelector]) {
    for selector in buttonSelectors {
      selector.target.performSelector(selector.selector, withObject: self)
    }
  }
  
  /// Update the control based on the state.
  /// - Note: Override this in children
  /// - Returns: void
  func updateControl() {
    //Override this in children
  }
  
  /// Save a touch to help determine if the touch just entered or exited the node
  private var lastEvent:SKAControlEvent = .None
  
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
    if let touch = touches.first as UITouch?, scene = scene where enabled {
      let currentLocation = (touch.locationInNode(scene))
      
      if lastEvent == .DragInside && !containsPoint(currentLocation) {
        //Touch Moved Outside Node
        controlState.subtractInPlace(.Highlighted)
        performSelectorsForEvent(.DragExit)
        lastEvent = .DragExit
      } else if lastEvent == .DragOutside && containsPoint(currentLocation) {
        //Touched Moved Inside Node
        controlState.insert(.Highlighted)
        performSelectorsForEvent(.DragEnter)
        lastEvent = .DragEnter
      } else if !containsPoint(currentLocation) {
        // Touch stayed Outside Node
        performSelectorsForEvent(.DragOutside)
        lastEvent = .DragOutside
      } else if containsPoint(currentLocation) {
        //Touch Stayed Inside Node
        performSelectorsForEvent(.DragInside)
        lastEvent = .DragInside
      }
    }
    
    super.touchesMoved(touches, withEvent: event)
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    lastEvent = .None
    if let touch = touches.first as UITouch?, scene = scene where enabled {
      if containsPoint(touch.locationInNode(scene)) {
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