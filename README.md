![Sprite Kit Alliance presents: SKAButton](https://raw.githubusercontent.com/SpriteKitAlliance/SKAButton/master/Documentation/SKAButtonBanner.png)


SKAButton is a simple button class for Sprite Kit that mimics the usefulness of UIButton. SKAButton is in the SKAToolKit family created by the Sprite Kit Alliance to be used with Apples Sprite Kit framework.  

The Sprite Kit Alliance is happy to provide the SKAButton and SKAToolKit free of charge without any warranty or guarantee (see license below for more info). If there is a feature missing or you would like added please email us at join@spritekitalliance.com

[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/SKAButton.svg)](https:img.shields.io/cocoapods/v/SKAButton.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/SKAButton.svg)](http://cocoadocs.org/docsets/SKAButton)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SpriteKitAlliance/SKAButton/blob/master/LICENSE)
[![Twitter](https://img.shields.io/badge/twitter-@SKADevs-55ACEE.svg)](http://twitter.com/SKADevs)

##SKAToolKit Install Instructions

###Using Cocoapods
```ogdl
pod 'SKAButton''~> 1.0'
```

###Using Carthage
```ogdl
github "SpriteKitAlliance/SKAButton" ~> 1.0
```
##Useful Methods
    //Add Targets to the button
    button.addTarget(self, selector: "buttonDoneWasTouched:", forControlEvents: .TouchUpInside)
    
    //Add target for multiple events
    button.addTarget(self, selector: "moreThanOneEvent:", forControlEvents: SKAControlEvent.DragEnter.union(.DragExit))

    //Set button target size independently of the button texture size
    button.setButtonTargetSize(CGSize(width: 300, height: 60))

###Edge Cases
A SKAButton can hold more than one state, but will show them in order of importance
Disabled > Highlighted > Selected > Normal

SKActions added to the button can override the texture for the state. In the example clicking the SKA button, but then disabling it will not show the disabled state, but will keep showing the SKAction until it is removed.
        
##Contact Info
If you would like to get in contact with the SKA, email us at join@spritekitalliance.com
    
##License
Copyright (c) 2015 Sprite Kit Alliance

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#Happy Clicking!
