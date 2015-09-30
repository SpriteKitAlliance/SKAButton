//
//  ButtonGameScene.swift
//  SKAToolKit
//
//  Created by Marc Vandehey on 9/1/15.
//  Copyright © 2015 SpriteKit Alliance. All rights reserved.
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
    button = SKAButtonSprite(color: UIColor.greenColor(), size: CGSize(width: 126, height: 112))
    addChild(button)
    
    button.addTarget(self, selector: "touchUpInside:", forControlEvents: .TouchUpInside)
    button.addTarget(self, selector: "touchUpOutside:", forControlEvents: .TouchUpOutside)
    button.addTarget(self, selector: "dragOutside:", forControlEvents: .DragOutside)
    button.addTarget(self, selector: "dragInside:", forControlEvents: .DragInside)
    button.addTarget(self, selector: "dragEnter:", forControlEvents: .DragEnter)
    button.addTarget(self, selector: "dragExit:", forControlEvents: .DragExit)
    button.addTarget(self, selector: "touchDown:", forControlEvents: .TouchDown)
    
    button.setTexture(self.atlas.textureNamed("ska-stand"), forState: .Normal)
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