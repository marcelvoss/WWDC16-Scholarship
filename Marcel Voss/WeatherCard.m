//
//  WeatherCard.m
//  Marcel Voss
//
//  Created by Marcel Voß on 24.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "WeatherCard.h"

#import "OWMManager.h"
#import "OWMObject.h"
#import "Constants.h"

#define WEATHER_RAIN 🌧
#define WEATHER_RAIN_SUN 🌦
#define WEATHER_CLEAR ☀️
#define WEATHER_SUN 🌤
#define WEATHER_SNOW 🌨
#define WEATHER_CLOUD ☁️

@implementation WeatherCard
{
    UILabel *weatherLabel;
    
    UILabel *minLabel;
    UILabel *maxLabel;
}

- (instancetype)initWithLocation:(CLLocation *)location
{
    self = [super init];
    if (self) {
        // TODO: Finish card and add better description
        
        // TODO: Add metric and imperial system
        
        weatherLabel = [[UILabel alloc] init];
        weatherLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:weatherLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:weatherLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:weatherLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self layoutIfNeeded];
        
        CLLocationCoordinate2D tempCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,
                                                                           location.coordinate.longitude);
        
        OWMManager *manager = [OWMManager sharedManager];
        [manager retrieveForecastForCoordinates:tempCoordinate success:^(OWMObject *weatherObject, NSHTTPURLResponse *response) {
            
            self.weatherObject = weatherObject;
            weatherLabel.text = [weatherObject.mainTemperature stringValue];
            
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            
        }];
        
    }
    return self;
}


@end
