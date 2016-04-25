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

@implementation WeatherCard
{
    UILabel *weatherLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // FIXME: Crashes when used
        
        
        /*
        [self fetchWeather];
        
        
        weatherLabel = [[UILabel alloc] init];
        weatherLabel.translatesAutoresizingMaskIntoConstraints = NO;
        weatherLabel.text = [_weatherObject.mainTemperature stringValue];
        [self addSubview:weatherLabel];
         */
        
        
        
    }
    return self;
}

- (OWMObject *)fetchWeather
{
    CLLocationCoordinate2D heideCoordinate = CLLocationCoordinate2DMake(HEIDE_LATITUDE, HEIDE_LONGTITUDE);
    
    
    OWMManager *manager = [OWMManager sharedManager];
    [manager retrieveForecastForCoordinates:heideCoordinate success:^(OWMObject *weatherObject, NSHTTPURLResponse *response) {
        
        self.weatherObject = weatherObject;
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        
    }];
    
    return self.weatherObject;
}



@end
