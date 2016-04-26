//
//  WeatherCard.h
//  Marcel Voss
//
//  Created by Marcel Voß on 24.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class OWMObject;

@interface WeatherCard : UIView

@property (nonatomic) OWMObject *weatherObject;

- (instancetype)initWithLocation:(CLLocation *)location;

@end
