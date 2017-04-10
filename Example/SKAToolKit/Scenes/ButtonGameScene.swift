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
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    //Setup The Disable Button
    disableButton = SKAButtonSprite(color: UIColor.red, size: CGSize(width: 260, height: 44))
    disableButton.setTexture(self.atlas.textureNamed("disable"), forState: .Normal)
    disableButton.setTexture(self.atlas.textureNamed("enabled"), forState: .Selected)
    disableButton.position = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height - 100)
    disableButton.addTarget(self, selector: #selector(ButtonGameScene.disableSKA(_:)), forControlEvents: .TouchUpInside)
    disableButton.setButtonTargetSize(CGSize(width: 300, height: 60))
    disableButton.setAdjustsSpriteOnHighlight()
    
    addChild(disableButton)
    
    //Dance Action
    let textures = [self.atlas.textureNamed("ska-dance1"), self.atlas.textureNamed("ska-dance2"), self.atlas.textureNamed("ska-dance1"), self.atlas.textureNamed("ska-dance3")]
    
    let dance = SKAction.animate(with: textures, timePerFrame: 0.12, resize: true, restore: true)
    danceAction = SKAction.repeatForever(dance)
    
    //SKA Button
    //This also sets the .Normal texture as the stand and clear color
    button = SKAButtonSprite(texture: self.atlas.textureNamed("ska-stand"), color: UIColor.clear, size: CGSize(width: 126, height: 112))
    addChild(button)
        
    button.addTarget(self, selector: #selector(ButtonGameScene.touchUpInside(_:)), forControlEvents: .TouchUpInside)
    button.addTarget(self, selector: #selector(ButtonGameScene.touchUpOutside(_:)), forControlEvents: .TouchUpOutside)
    button.addTarget(self, selector: #selector(ButtonGameScene.dragOutside(_:)), forControlEvents: .DragOutside)
    button.addTarget(self, selector: #selector(ButtonGameScene.dragInside(_:)), forControlEvents: .DragInside)
    button.addTarget(self, selector: #selector(ButtonGameScene.dragEnter(_:)), forControlEvents: .DragEnter)
    button.addTarget(self, selector: #selector(ButtonGameScene.dragExit(_:)), forControlEvents: .DragExit)
    button.addTarget(self, selector: #selector(ButtonGameScene.touchDown(_:)), forControlEvents: .TouchDown)

    button.setTexture(self.atlas.textureNamed("ska-pressed"), forState: .Highlighted)
    button.setTexture(self.atlas.textureNamed("ska-disabled"), forState: .Disabled)
    button.position = CGPoint(x: view.center.x, y: 200)
    
    button.setAdjustsSpriteOnDisable()
  }
  
  func touchUpInside(_ sender:Any) {
    print("SKABUTTON: touchUpInside")
    
    //Remove the shake action
    button.removeAction(forKey: shakeKey)
    
    if button.selected {
      button.selected = false
      button.removeAction(forKey: danceKey)
      
      //Remove shake harder if not dancing
      button.removeAction(forKey: shakeHarderKey)
    } else {
      button.selected = true
      button.run(danceAction, withKey: danceKey)
    }
  }
  
  func touchUpOutside(_ sender:Any) {
    print("SKABUTTON: touchUpOutside")
    
    button.removeAction(forKey: shakeKey)
    button.removeAction(forKey: shakeHarderKey)
  }
  
  func dragOutside(_ sender:Any) {
    print("SKABUTTON: dragOutside")
  }
  
  func dragInside(_ sender:Any) {
    print("SKABUTTON: dragInside")
  }
  
  func dragEnter(_ sender:Any) {
    print("SKABUTTON: dragEnter")
    
    button.removeAction(forKey: danceKey)
    
    //Shake a lot
    button.run(makeNewShakeAction(4), withKey: shakeHarderKey)
  }
  
  func dragExit(_ sender:Any) {
    print("SKABUTTON: dragExit")
    button.removeAction(forKey: shakeKey)
    button.removeAction(forKey: shakeHarderKey)
    
    if button.selected {
      button.selected = true
      
      button.run(danceAction, withKey: danceKey)
    }
  }
  
  func touchDown(_ sender:Any) {
    print("SKABUTTON: touchDown")
    
    button.removeAction(forKey: danceKey)
    button.removeAction(forKey: shakeHarderKey)
    
    //Shake a little
    button.run(makeNewShakeAction(2), withKey: shakeKey)
  }
  
  func disableSKA(_ sender:Any?) {
    button.enabled = !button.enabled
    disableButton.selected = !button.enabled
  }
  
  //Set up a new shake action with random movements horizontally
  func makeNewShakeAction(_ shakeAmount:Int) -> SKAction {
    let shakeLeft = CGFloat(-(Int(arc4random()) % shakeAmount + 1))
    let shakeRight = CGFloat(Int(arc4random()) % shakeAmount + 1)
    
    let shake1 = SKAction.moveBy(x: shakeLeft, y: 0, duration: 0.02)
    let shake2 = SKAction.moveBy(x: -shakeLeft, y: 0, duration: 0.01)
    let shake3 = SKAction.moveBy(x: shakeRight, y: 0, duration: 0.02)
    let shake4 = SKAction.moveBy(x: -shakeRight, y: 0, duration: 0.01)
    
    let shakes = SKAction.sequence([shake1, shake2, shake3, shake4])
    
    return SKAction.repeatForever(shakes)
  }
}
