//
//  OWMObject.m
//  Marcel Voss
//
//  Created by Marcel Voß on 24.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "OWMObject.h"

@implementation OWMObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSDictionary *weather = dictionary[@"weather"];
        NSDictionary *wind = dictionary[@"wind"];
        NSDictionary *sys = dictionary[@"sys"];
        NSDictionary *main = dictionary[@"main"];
        NSDictionary *coordinates = dictionary[@"coord"];
        NSDictionary *clouds = dictionary[@"clouds"];
        
        
        NSNumber *longtitude = coordinates[@"lat"];
        NSNumber *latitude = coordinates[@"lon"];
        
        CLLocationDegrees longtitudeDegrees = [longtitude floatValue];
        CLLocationDegrees latitudeDegrees = [latitude floatValue];
        
        _coordinate = CLLocationCoordinate2DMake(latitudeDegrees, longtitudeDegrees);
        
        _cityName = dictionary[@"name"];
        _weatherDescription = weather[@"description"];
        _countryCode = sys[@"country"];
        _weatherID = weather[@"id"];
        _weatherMain = weather[@"main"];
        _message = sys[@"message"];
        
        _sunriseTime = sys[@"sunrise"];
        _sunsetTime = sys[@"sunset"];
        _cityID = dictionary[@"id"];
        _cloudiness = clouds[@"all"];
        
        _humidity = main[@"humidity"];
        _mainTemperature = main[@"temp"];
        _temperatureMin = main[@"temp_min"];
        _temperatureMax = main[@"temp_max"];
        
        _windSpeed = wind[@"deg"];
        _windDirections = wind[@"speed"];
    }
    return self;
}

@end
