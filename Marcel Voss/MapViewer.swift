//
//  MapViewer.swift
//  Marcel Voss
//
//  Created by Marcel Voß on 18.04.15.
//  Copyright (c) 2015 Marcel Voß. All rights reserved.
//

import UIKit
import MapKit

class MapViewer: UIView, UIScrollViewDelegate, CLLocationManagerDelegate {
    
    var mapView : MKMapView?
    var effectView = UIVisualEffectView()
    var aWindow : UIWindow?
    var closeButton = UIButton()
    var constraintY : NSLayoutConstraint?
    var cardConstraintY : NSLayoutConstraint?
    
    var locationManager : CLLocationManager?
    var scrollView : UIScrollView?
    var pageControl : UIPageControl?
    
    var cardView1 : UIView?
    var cardView2 : UIView?
    
    let locationLabel = UILabel()
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        aWindow = UIApplication.sharedApplication().keyWindow!
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func show() {
        self.setupViews()
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.effectView.effect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            self.closeButton.alpha = 1
        })
        
        UIView.animateWithDuration(0.4, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .TransitionNone, animations: { () -> Void in
            self.constraintY!.constant = -10 // TODO: Find a better value / UI
            self.layoutIfNeeded()
        }) { (finished) -> Void in
            UIView.animateWithDuration(0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .TransitionNone, animations: {
                    self.cardConstraintY?.constant = -30
                    self.layoutIfNeeded()
                }, completion: { (finished) in
                    
            })
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func hide() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .TransitionNone, animations: { () -> Void in
            self.constraintY!.constant = -self.frame.size.height
            self.cardConstraintY?.constant = self.frame.size.height
            self.layoutIfNeeded()
        }) { (finished) -> Void in
            self.mapView?.removeFromSuperview()
        }
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.effectView.effect = nil
            self.closeButton.alpha = 0
        }) { (finished) -> Void in
            self.scrollView = nil
            self.mapView!.mapType = .Standard
            self.mapView!.delegate = nil;
            self.mapView!.removeFromSuperview()
            self.mapView = nil;
            
            
            self.locationManager?.delegate = nil
            self.locationManager = nil
            
            self.effectView.removeFromSuperview()
            self.removeFromSuperview()
        }
        
        
    }
    
    func setupViews () {
        aWindow?.addSubview(self)
        
        // TODO: Fix broken blur animation
        effectView = UIVisualEffectView()
        effectView.frame = self.frame
        self.addSubview(effectView)
        
        closeButton = UIButton()
        closeButton.alpha = 0
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(self.hide), forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.setImage(UIImage(named: "CloseIcon"), forState: UIControlState.Normal)
        self.addSubview(closeButton)
        
        self.addConstraint(NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20))
        
        self.addConstraint(NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 20))
        
        // Map
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mapView!)
        
        self.addConstraint(NSLayoutConstraint(item: mapView!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        constraintY = NSLayoutConstraint(item: mapView!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -self.frame.size.height)
        self.addConstraint(constraintY!)
        
        self.addConstraint(NSLayoutConstraint(item: mapView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: mapView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        
        
        // FIXME: Missing option to dismiss view
        /*
        var tap = UITapGestureRecognizer(target: self, action: "hide")
        effectView.addGestureRecognizer(tap)
 */
        
        // Widget Scroll View
        scrollView = UIScrollView()
        scrollView?.pagingEnabled = true
        scrollView?.delegate = self
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.contentSize = CGSizeMake(self.frame.size.width * 3, 100)
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView!)
        
        self.addConstraint(NSLayoutConstraint(item: scrollView!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        cardConstraintY = NSLayoutConstraint(item: scrollView!, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: self.frame.size.height)
        self.addConstraint(cardConstraintY!)
        
        self.addConstraint(NSLayoutConstraint(item: scrollView!, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: scrollView!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 100))
        
        self.layoutIfNeeded()
        
        
        let canvasPageView = UIView()
        canvasPageView.backgroundColor = UIColor.purpleColor()
        canvasPageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(canvasPageView)
        
        let dis = self.frame.size.height - CGRectGetMaxY(scrollView!.bounds)
        
        self.addConstraint(NSLayoutConstraint(item: canvasPageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: canvasPageView, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Bottom, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: canvasPageView, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: canvasPageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: dis))
        

        self.layoutIfNeeded()
        
        
        // TODO: page control doesn't show up?!
        // Page Control
        pageControl = UIPageControl()
        pageControl?.addTarget(self, action: #selector(self.changePage), forControlEvents: UIControlEvents.ValueChanged)
        pageControl?.currentPage = 0
        pageControl?.numberOfPages = 3
        pageControl?.backgroundColor = UIColor.redColor()
        pageControl?.tintColor = UIColor.whiteColor()
        pageControl?.translatesAutoresizingMaskIntoConstraints = false
        canvasPageView.addSubview(pageControl!)
        
        canvasPageView.addConstraint(NSLayoutConstraint(item: pageControl!, attribute: .CenterX, relatedBy: .Equal, toItem: canvasPageView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        canvasPageView.addConstraint(NSLayoutConstraint(item: pageControl!, attribute: .CenterY, relatedBy: .Equal, toItem: canvasPageView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        
        self.layoutIfNeeded()
        
        
        self .setupCards()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl?.currentPage = Int(pageNumber)
        
    }
    
    func changePage() {
        let x = CGFloat(pageControl!.currentPage) * scrollView!.frame.size.width
        scrollView!.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func setupCards() {
        
        // Get width of screen
        let width = UIScreen.mainScreen().bounds.size.width
        
        cardView1 = UIView()
        cardView1?.translatesAutoresizingMaskIntoConstraints = false
        cardView1?.backgroundColor = UIColor.whiteColor()
        cardView1?.layer.cornerRadius = 6
        scrollView?.addSubview(cardView1!)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView1!, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView1!, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView1!, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: -20))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView1!, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: 0))
        
        
        
        let cardView2 = WeatherCard()
        cardView2.translatesAutoresizingMaskIntoConstraints = false
        cardView2.backgroundColor = UIColor.whiteColor()
        cardView2.layer.cornerRadius = 6
        scrollView!.addSubview(cardView2)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView2, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1.0, constant: width))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView2, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView2, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: -20))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView2, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: 0))
        
        
        let cardView3 = UIView()
        cardView3.translatesAutoresizingMaskIntoConstraints = false
        cardView3.backgroundColor = UIColor.whiteColor()
        cardView3.layer.cornerRadius = 6
        scrollView!.addSubview(cardView3)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView3, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1.0, constant: width * 2))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView3, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView3, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: -20))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView3, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: 0))
        
        
        self.layoutIfNeeded()
        
    }
    
    func distanceForLocale(distance: CLLocationDistance) -> String {
        let lengthFormatter = NSLengthFormatter()
        lengthFormatter.numberFormatter.maximumFractionDigits = 2
        
        let locale = NSLocale.currentLocale()
        let isMetric = locale.objectForKey(NSLocaleUsesMetricSystem) as! Bool
        
        if isMetric {
            return lengthFormatter.stringFromValue(round(distance / 1000), unit: .Kilometer)
        } else {
            return lengthFormatter.stringFromValue(round(distance / 1609.34), unit: .Mile)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        // TODO: Move this to either a seperate view or create the labels before
        
        locationManager?.stopUpdatingLocation()
        
    
        // Retrieve location name for coordinates
        let reverseGeoCoder = CLGeocoder()
        reverseGeoCoder.reverseGeocodeLocation(newLocation) { (placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                self.displayLocationInformation(placemarks![0])
            }
        }
        
        // TODO: Placemark also supports timezone; use for time difference card

        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView1?.addSubview(locationLabel)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: locationLabel, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: locationLabel, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: -10))
        
        
        
        let myLocation = CLLocation(latitude: 54.196111, longitude: 9.093333)
        let distance = newLocation.distanceFromLocation(myLocation)
        
        let distanceLabel = UILabel()
        distanceLabel.text = String(format: "We're about %@ away. ✈️", self.distanceForLocale(distance)) // TODO: Change text
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView1?.addSubview(distanceLabel)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 10))
    }
    
    func displayLocationInformation(placemark: CLPlacemark?) {
        locationLabel.text = String(format: "You're in %@, %@", (placemark?.locality)!, (placemark?.administrativeArea)!)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // TODO: Add error handling
    }
    
    func setupDistanceCard(userLocation: CLLocation) {
        // TODO: implement
    }
    
}


    


