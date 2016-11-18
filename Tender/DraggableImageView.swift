//
//  DraggableImageView.swift
//  Tender
//
//  Created by Bill Luoma on 11/9/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class DraggableImageView: UIView {

    var centerPoint: CGPoint = CGPoint(x: 0, y: 0)
    var originalCenterPoint: CGPoint = CGPoint(x: 0, y: 0)
    var originalTransform: CGAffineTransform = CGAffineTransform.identity
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    //@IBOutlet weak var captionedLabel: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    
    func initSubviews() {
        
        let nib = UINib(nibName: "DraggableImageView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        originalCenterPoint = self.center
        dlog("center: \(originalCenterPoint)")
        
    }
    
    //var caption: String? {
    //    get { return captionedLabel?.text }
    //    set { captionedLabel.text = newValue }
    //}
    
    var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }

    
    @IBAction func proflleImageDidPan(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.superview)
        let velocity = sender.velocity(in: self.superview)
        let touchPoint = sender.location(in: self)
        
        if sender.state == .began {
            centerPoint = self.center
            dlog("began")
            originalTransform = self.transform
            dlog("center: \(centerPoint), transform: \(originalTransform)")

        }
        else if sender.state == .changed {
            dlog("translation.x: \(translation.x)")
            
            if fabs(translation.x) > 10.0 {
            let rotationAngle = rotationAngleForTranslation(translationX: translation.x, velocityX: velocity.x, touchInView: touchPoint)
            var trans = CGAffineTransform(rotationAngle: rotationAngle)
            trans = trans.translatedBy(x: translation.x, y: 0.0)
            self.transform = originalTransform.concatenating(trans)
            }
            //self.center.x = centerPoint.x + translation.x
            
            
            //let trans: CGAffineTransform = CGAffineTransform(rotationAngle: rotation)
            //self.transform = trans

        }
        else if sender.state == .ended {
            if translation.x > 50 {
                
                UIView.animate(withDuration: 1.0, animations: { 
                    
                    let screenWidth = UIScreen.main.bounds.width
                    let offScreenCenter = CGPoint(x: screenWidth + self.bounds.width / 2.0, y: self.center.y)
                    self.center = offScreenCenter
                    
                })
                
            }
            else if translation.x < -50 {
                UIView.animate(withDuration: 1.0, animations: {
                    let offScreenCenter = CGPoint(x: -self.bounds.width, y: self.center.y)
                    self.center = offScreenCenter
                })
            }
            else {
                self.center = originalCenterPoint
                self.transform = CGAffineTransform.identity
            }
        }
        
    }
    
    
    func rotationAngleForTranslation(translationX: CGFloat, velocityX: CGFloat, touchInView: CGPoint) -> CGFloat {
        
        var rotationAngle: CGFloat = 0.0
        var signMultiplier: CGFloat = 0.0
        
        if velocityX > 0 {
            signMultiplier = 1.0
        }
        else if velocityX < 0 {
            signMultiplier = -1.0
        }
        else {
            signMultiplier = 0.0
        }
        
        if touchInView.y > self.bounds.height / 2.0 {
            signMultiplier = -signMultiplier
        }
        
        let mul = 1.0 - fabs(translationX) / self.bounds.width
        let maxAngle = CGFloat.pi / 2
        rotationAngle = (maxAngle / 5.0) * mul
        rotationAngle = rotationAngle * signMultiplier
        
        let rotationDegrees = rotationAngle.radiansToDegrees
        dlog("mul: \(mul), angle: \(rotationDegrees) deg")
        
        return rotationAngle
    }
    
    
    @IBAction func profileImageDidRotate(_ sender: UIRotationGestureRecognizer) {
    
        let rotation = sender.rotation
        
        // Begins:  when two touches have moved enough to be considered a rotation
        if sender.state == .began {
            dlog("rotation began: \(rotation)")

        }
        // Changes: when a finger moves while two fingers are down
        else if sender.state == .changed {
            dlog("rotation changed: \(rotation)")
            
            
        }
        // Ends:    when both fingers have lifted
        else if sender.state == .ended {
            dlog("rotation ended: \(rotation)")

        }
    }
}

extension DraggableImageView: UIGestureRecognizerDelegate {
    
    
    // called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
    //func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    
    
    // called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
    // return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
    //
    // note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

/*
 
 
 func onPinnedFacePinch(_ pinchGestureRecognizer: UIPinchGestureRecognizer) {
 NSLog("Pinch scale: \(pinchGestureRecognizer.scale)")
 
 let scale = pinchGestureRecognizer.scale
 pinchGestureRecognizer.scale = 1
 
 var transform = pinchGestureRecognizer.view!.transform
 transform = transform.scaledBy(x: scale, y: scale)
 pinchGestureRecognizer.view!.transform = transform
 }
 
 func onPinnedFaceRotation(_ rotationGestureRecognizer: UIRotationGestureRecognizer) {
 NSLog("Rotation: \(rotationGestureRecognizer.rotation)")
 
 var transform = rotationGestureRecognizer.view!.transform
 transform = transform.rotated(by: rotationGestureRecognizer.rotation)
 rotationGestureRecognizer.view!.transform = transform
 rotationGestureRecognizer.rotation = 0
 }
 
 
*/

