//
//  ImageViewer.swift
//  Marcel Voss
//
//  Created by Marcel Voß on 17.04.15.
//  Copyright (c) 2015 Marcel Voß. All rights reserved.
//

import UIKit

class ImageViewer: UIView, UIGestureRecognizerDelegate {
    
    var foregroundImageView : UIImageView?
    var aWindow : UIWindow?
    var effectView = UIVisualEffectView()
    var annotationLabel = UILabel()
    
    var constraintY : NSLayoutConstraint?
    var annotationConstraintY : NSLayoutConstraint?
    
    var theImage : UIImage?
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        aWindow = UIApplication.sharedApplication().keyWindow!
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

    func show(foregroundImage: UIImage) {
        
        theImage = foregroundImage;
        
        self.foregroundImageView = UIImageView()
        self.foregroundImageView?.image = foregroundImage
        self.setupViews()
        
        if ((annotationLabel.text) != nil) {
            
            annotationLabel.translatesAutoresizingMaskIntoConstraints = false
            annotationLabel.textColor = UIColor.whiteColor()
            annotationLabel.font = UIFont(name: "Avenir-Roman", size: 15)
            annotationLabel.numberOfLines = 0
            annotationLabel.textAlignment = .Center;
            self.addSubview(annotationLabel)
            
            self.addConstraint(NSLayoutConstraint(item: annotationLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20))
            
            self.addConstraint(NSLayoutConstraint(item: annotationLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: -40))
            
            self.addConstraint(NSLayoutConstraint(item: annotationLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: foregroundImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -10))
            
            self.layoutIfNeeded()
            
        }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.constraintY!.constant = 0
            self.effectView.alpha = 1
        })
        
        UIView.animateWithDuration(0.5, delay: 0.15, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            
            self.layoutIfNeeded()
        }) { (finished) -> Void in
            
        }
    }
    
    func hide() {
        UIView.animateWithDuration(0.5, delay: 0.15, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            let screenHeight = UIScreen.mainScreen().bounds.size.height
            self.constraintY!.constant = screenHeight
            self.layoutIfNeeded()
            }) { (finished) -> Void in
                
        }
        
        UIView.animateWithDuration(0.4, delay: 0.25, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.alpha = 0;
        }) { (finished) -> Void in
            self.removeFromSuperview()
        }
    }
    
    func setupViews() {
        aWindow?.addSubview(self)
        
        
        // TODO: Fix broken animation (NSLOG)
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        effectView = UIVisualEffectView(effect: blur)
        effectView.frame = self.frame
        effectView.alpha = 0
        self.addSubview(effectView)
        
        self.userInteractionEnabled = true
        
        foregroundImageView!.translatesAutoresizingMaskIntoConstraints = false
        foregroundImageView!.userInteractionEnabled = true
        foregroundImageView!.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(foregroundImageView!)
        
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        self.addConstraint(NSLayoutConstraint(item: foregroundImageView!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        // A required layout change if the image isn't a iPhone 5 screenshot
        if (theImage?.size.height != 568) {
            self.addConstraint(NSLayoutConstraint(item: foregroundImageView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        }
        
        self.addConstraint(NSLayoutConstraint(item: foregroundImageView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        constraintY = (NSLayoutConstraint(item: foregroundImageView!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: screenHeight))
        self.addConstraint(constraintY!)
        
        
        // Adds a tap gesture to dismiss the image view
        let tap = UITapGestureRecognizer(target: self, action: #selector(ImageViewer.hide))
        self.addGestureRecognizer(tap)
        
        self.layoutIfNeeded()
        
        // Parallax Effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -10
        verticalMotionEffect.maximumRelativeValue = 10
        
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        horizontalMotionEffect.minimumRelativeValue = -10
        horizontalMotionEffect.maximumRelativeValue = 10
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [verticalMotionEffect, horizontalMotionEffect]
        
        foregroundImageView?.addMotionEffect(group)
    }

}
