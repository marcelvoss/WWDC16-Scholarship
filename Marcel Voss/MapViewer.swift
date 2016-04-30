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
    var pageControl = UIPageControl()
    
    var cardView1 : WeatherCard?
    var cardView2 : UIView?
    
    // Distance
    let locationLabel = UILabel()
    let distanceLabel = UILabel()
    
    
    let introHeadLabel = UILabel()
    let introSubLabel = UILabel()
    
    // Time Zone
    //let distanceLabel = UILabel()
    
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
            self.constraintY!.constant = -0 // TODO: Find a better value / UI
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
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .TransitionNone, animations: { () -> Void in
            self.constraintY!.constant = -self.frame.size.height
            self.cardConstraintY?.constant = self.frame.size.height
            self.layoutIfNeeded()
        }) { (finished) -> Void in
            self.mapView?.removeFromSuperview()
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.effectView.effect = nil
                self.closeButton.alpha = 0
            }) { (finished) -> Void in
                self.scrollView = nil
                
                
                
                
                self.locationManager?.delegate = nil
                self.locationManager = nil
                
                self.mapView!.mapType = .Standard
                self.mapView!.showsUserLocation = false
                self.mapView!.delegate = nil
                self.mapView!.removeFromSuperview()
                self.mapView = nil
                
                self.effectView.removeFromSuperview()
                self.removeFromSuperview()
            }
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
        
        let mapBackgroundCanvas = UIView()
        mapBackgroundCanvas.translatesAutoresizingMaskIntoConstraints = false
        mapBackgroundCanvas.backgroundColor = UIColor.whiteColor()
        mapBackgroundCanvas.layer.cornerRadius = 12
        self.addSubview(mapBackgroundCanvas)
        
        self.addConstraint(NSLayoutConstraint(item: mapBackgroundCanvas, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        constraintY = NSLayoutConstraint(item: mapBackgroundCanvas, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -self.frame.size.height)
        self.addConstraint(constraintY!)
        
        self.addConstraint(NSLayoutConstraint(item: mapBackgroundCanvas, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: mapBackgroundCanvas, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: -20))
        
        self.layoutIfNeeded()
        
        // Map
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        mapView?.layer.cornerRadius = 6
        mapBackgroundCanvas.addSubview(mapView!)
        
        self.addConstraint(NSLayoutConstraint(item: mapView!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: mapBackgroundCanvas, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: mapView!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: mapBackgroundCanvas, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: mapView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: mapBackgroundCanvas, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: mapView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: mapBackgroundCanvas, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        
        
        
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
        canvasPageView.backgroundColor = UIColor.clearColor()
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
        pageControl.addTarget(self, action: #selector(self.changePage), forControlEvents: UIControlEvents.ValueChanged)
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.backgroundColor = UIColor.clearColor()
        pageControl.tintColor = UIColor.whiteColor()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        canvasPageView.addSubview(pageControl)
        
        canvasPageView.addConstraint(NSLayoutConstraint(item: pageControl, attribute: .CenterX, relatedBy: .Equal, toItem: canvasPageView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        canvasPageView.addConstraint(NSLayoutConstraint(item: pageControl, attribute: .Top, relatedBy: .Equal, toItem: canvasPageView, attribute: .Top, multiplier: 1.0, constant: 0))
        
        
        self.layoutIfNeeded()
        self .setupCards()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
    }
    
    func changePage() {
        let x = CGFloat(pageControl.currentPage) * scrollView!.frame.size.width
        scrollView!.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func setupCards() {
        
        // Get width of screen
        let width = UIScreen.mainScreen().bounds.size.width
        
        let HEIDE_LATITUDE = 54.196111 // Latitude of my hometown
        let HEIDE_LONGTITUDE = 9.093333 // Longtitude of my hometown
        
        let cardView0 = UIView()
        cardView0.translatesAutoresizingMaskIntoConstraints = false
        cardView0.backgroundColor = UIColor.whiteColor()
        cardView0.layer.cornerRadius = 6
        scrollView!.addSubview(cardView0)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView0, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView0, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView0, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: -20))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView0, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: 0))
        
        
        introHeadLabel.text = "Facts & Stats"
        introHeadLabel.translatesAutoresizingMaskIntoConstraints = false
        introHeadLabel.font = UIFont.boldSystemFontOfSize(20)
        scrollView!.addSubview(introHeadLabel)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: introHeadLabel, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: introHeadLabel, attribute: .Bottom, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        
        introSubLabel.text = "Want to learn a bit more?"
        introSubLabel.translatesAutoresizingMaskIntoConstraints = false
        introSubLabel.font = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
        scrollView!.addSubview(introSubLabel)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: introSubLabel, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: introSubLabel, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        
        
        let tempLocation = CLLocation(latitude: HEIDE_LATITUDE, longitude: HEIDE_LONGTITUDE)
        cardView1 = WeatherCard(location:tempLocation)
        cardView1?.translatesAutoresizingMaskIntoConstraints = false
        cardView1?.backgroundColor = UIColor.whiteColor()
        cardView1?.layer.cornerRadius = 6
        scrollView?.addSubview(cardView1!)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView1!, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1.0, constant: width))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView1!, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView1!, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: -20))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView1!, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: 0))
        
        
        
        let cardView2 = UIView()
        cardView2.translatesAutoresizingMaskIntoConstraints = false
        cardView2.backgroundColor = UIColor.whiteColor()
        cardView2.layer.cornerRadius = 6
        scrollView!.addSubview(cardView2)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView2, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1.0, constant: width * 2))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView2, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView2, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: -20))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView2, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: 0))
        
        
        // Distance Headline
        let distanceHeadlineLabel = UILabel()
        distanceHeadlineLabel.text = "Distance".uppercaseString
        distanceHeadlineLabel.textAlignment = .Center
        distanceHeadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceHeadlineLabel.font = UIFont.boldSystemFontOfSize(15)
        cardView2.addSubview(distanceHeadlineLabel)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: distanceHeadlineLabel, attribute: .CenterX, relatedBy: .Equal, toItem: cardView2, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: distanceHeadlineLabel, attribute: .Top, relatedBy: .Equal, toItem: cardView2, attribute: .Top, multiplier: 1.0, constant: 5))
        
        
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.text = "Location Label"
        cardView2.addSubview(locationLabel)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: locationLabel, attribute: .CenterX, relatedBy: .Equal, toItem: cardView2, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: locationLabel, attribute: .Bottom, relatedBy: .Equal, toItem: cardView2, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        
        distanceLabel.text = "Distance Label"
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView2.addSubview(distanceLabel)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: .CenterX, relatedBy: .Equal, toItem: cardView2, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: .Top, relatedBy: .Equal, toItem: cardView2, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        
        
        let cardView3 = UIView()
        cardView3.translatesAutoresizingMaskIntoConstraints = false
        cardView3.backgroundColor = UIColor.whiteColor()
        cardView3.layer.cornerRadius = 6
        scrollView!.addSubview(cardView3)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: cardView3, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1.0, constant: width * 3))
        
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
        
        
        let myLocation = CLLocation(latitude: 54.196111, longitude: 9.093333)
        let distance = newLocation.distanceFromLocation(myLocation)
        
        distanceLabel.text = String(format: "That's about %@ away from here. ✈️", self.distanceForLocale(distance)) // TODO: Change text

    }
    
    func displayLocationInformation(placemark: CLPlacemark?) {
        locationLabel.text = String(format: "You're in %@, %@", (placemark?.locality)!, (placemark?.administrativeArea)!)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // TODO: Add error handling
        /*
        introHeadLabel.text = "Oh, no."
        introSubLabel.text = "Something went wrong. 😟"
         */
    }
    
}


    


