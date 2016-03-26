//
//  SKAControlEvents.swift
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

extension SKAControlSprite {
  // MARK: - Selector Events

  /**
   Add target for a SKAControlEvent. You may call this multiple times and you can specify multiple targets for any event.
   - Parameter target: Object the selecter will be called on
   - Parameter selector: The chosen selector for the event that is a member of the target
   - Parameter events: SKAControlEvents that you want to register the selector to
   - Returns: void
   */
  func addTarget(target: AnyObject, selector: Selector, forControlEvents events: SKAControlEvent) {
    userInteractionEnabled = true
    
    let buttonSelector = SKASelector(target: target, selector: selector)
    addButtonSelector(buttonSelector, forControlEvents: events)
  }

  /**
   Add Selector(s) to our dictionary of actions based on the SKAControlEvent
   - Parameter buttonSelector: Internal struct containing the selector and the target
   - Parameter events: SKAControl event(s) associated to the selector
   - Returns: void
   */
  internal func addButtonSelector(buttonSelector: SKASelector, forControlEvents events: SKAControlEvent) {
    for option in SKAControlEvent.AllOptions where events.contains(option) {
      if var buttonSelectors = selectors[option] {
        buttonSelectors.append(buttonSelector)
        selectors[option] = buttonSelectors
      } else {
        selectors[option] = [buttonSelector]
      }
    }
  }

  /**
   Checks if there are any listed selectors for the control event, and performs them
   - Parameter event: Single control event
   - Returns: void
   */
  internal func performSelectorsForEvent(event:SKAControlEvent) {
    guard let selectors = selectors[event] else { return }
    performSelectors(selectors)
  }

  /*
   Loops through the selected actions and performs the selectors associated to them
   - Parameter buttonSelectors: buttonSelectors Array of button selectors to perform
   - Returns: void
   */
  internal func performSelectors(buttonSelectors: [SKASelector]) {
    for selector in buttonSelectors {
      selector.target.performSelector(selector.selector, withObject: self)
    }
  }

  /**
   Update the control based on the state.
   - Note: Override this in children
   - Returns: void
   */
  func updateControl() {
    //Override this in children
  }
}
