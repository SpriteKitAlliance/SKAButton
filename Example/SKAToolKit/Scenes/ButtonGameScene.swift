//
//  ButtonGameScene.swift
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

class ButtonGameScene: SKScene {
  var button: SKAButtonSprite!
  var disableButton: SKAButtonSprite!
  var danceAction: SKAction!
  
  let danceKey = "action-dance"
  let shakeKey = "action-shake"
  let shakeHarderKey = "action-shake-harder"
  let atlas = SKTextureAtlas(named: "Textures")
  
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    
    //Setup The Disable Button
    disableButton = SKAButtonSprite(color: UIColor.redColor(), size: CGSize(width: 260, height: 44))
    disableButton.setTexture(self.atlas.textureNamed("disable"), forState: .Normal)
    disableButton.setTexture(self.atlas.textureNamed("enabled"), forState: .Selected)
    disableButton.position = CGPoint(x: view.center.x, y: UIScreen.mainScreen().bounds.height - 100)
    disableButton.addTarget(self, selector: "disableSKA:", forControlEvents: .TouchUpInside)
    disableButton.setButtonTargetSize(CGSize(width: 300, height: 60))
    
    addChild(disableButton)
    
    //Dance Action
    let textures = [self.atlas.textureNamed("ska-dance1"), self.atlas.textureNamed("ska-dance2"), self.atlas.textureNamed("ska-dance1"), self.atlas.textureNamed("ska-dance3")]
    
    let dance = SKAction.animateWithTextures(textures, timePerFrame: 0.12, resize: true, restore: true)
    danceAction = SKAction.repeatActionForever(dance)
    
    //SKA Button
    //This also sets the .Normal texture as the stand and clear color
    button = SKAButtonSprite(texture: self.atlas.textureNamed("ska-stand"), color: UIColor.clearColor(), size: CGSize(width: 126, height: 112))
    addChild(button)
        
    button.addTarget(self, selector: "touchUpInside:", forControlEvents: .TouchUpInside)
    button.addTarget(self, selector: "touchUpOutside:", forControlEvents: .TouchUpOutside)
    button.addTarget(self, selector: "dragOutside:", forControlEvents: .DragOutside)
    button.addTarget(self, selector: "dragInside:", forControlEvents: .DragInside)
    button.addTarget(self, selector: "dragEnter:", forControlEvents: .DragEnter)
    button.addTarget(self, selector: "dragExit:", forControlEvents: .DragExit)
    button.addTarget(self, selector: "touchDown:", forControlEvents: .TouchDown)

    button.setTexture(self.atlas.textureNamed("ska-pressed"), forState: .Highlighted)
    button.setTexture(self.atlas.textureNamed("ska-disabled"), forState: .Disabled)
    button.position = CGPoint(x: view.center.x, y: 200)
  }
  
  func touchUpInside(sender:AnyObject) {
    print("SKABUTTON: touchUpInside")
    
    //Remove the shake action
    button.removeActionForKey(shakeKey)
    
    if button.selected {
      button.selected = false
      button.removeActionForKey(danceKey)
      
      //Remove shake harder if not dancing
      button.removeActionForKey(shakeHarderKey)
    } else {
      button.selected = true
      button.runAction(danceAction, withKey: danceKey)
    }
  }
  
  func touchUpOutside(sender:AnyObject) {
    print("SKABUTTON: touchUpOutside")
    
    button.removeActionForKey(shakeKey)
    button.removeActionForKey(shakeHarderKey)
  }
  
  func dragOutside(sender:AnyObject) {
    print("SKABUTTON: dragOutside")
  }
  
  func dragInside(sender:AnyObject) {
    print("SKABUTTON: dragInside")
  }
  
  func dragEnter(sender:AnyObject) {
    print("SKABUTTON: dragEnter")
    
    button.removeActionForKey(danceKey)
    
    //Shake a lot
    button.runAction(makeNewShakeAction(4), withKey: shakeHarderKey)
  }
  
  func dragExit(sender:AnyObject) {
    print("SKABUTTON: dragExit")
    button.removeActionForKey(shakeKey)
    button.removeActionForKey(shakeHarderKey)
    
    if button.selected ?? false {
      button.selected = true
      
      button.runAction(danceAction, withKey: danceKey)
    }
  }
  
  func touchDown(sender:AnyObject) {
    print("SKABUTTON: touchDown")
    
    button.removeActionForKey(danceKey)
    button.removeActionForKey(shakeHarderKey)
    
    //Shake a little
    button.runAction(makeNewShakeAction(2), withKey: shakeKey)
  }
  
  func disableSKA(sender:AnyObject) {
    button.enabled = !button.enabled
    disableButton.selected = !button.enabled
  }
  
  //Set up a new shake action with random movements horizontally
  func makeNewShakeAction(shakeAmount:Int) -> SKAction {
    let shakeLeft = CGFloat(-(random() % shakeAmount + 1))
    let shakeRight = CGFloat(random() % shakeAmount + 1)
    
    let shake1 = SKAction.moveByX(shakeLeft, y: 0, duration: 0.02)
    let shake2 = SKAction.moveByX(-shakeLeft, y: 0, duration: 0.01)
    let shake3 = SKAction.moveByX(shakeRight, y: 0, duration: 0.02)
    let shake4 = SKAction.moveByX(-shakeRight, y: 0, duration: 0.01)
    
    let shakes = SKAction.sequence([shake1, shake2, shake3, shake4])
    
    return SKAction.repeatActionForever(shakes)
  }
}
