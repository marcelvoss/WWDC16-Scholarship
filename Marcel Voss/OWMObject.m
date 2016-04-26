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
        // FIXME: Fix crashes
        
        NSDictionary *weather = [self objectForKeyOrNil:dictionary[@"weather"]];
        NSDictionary *wind = [self objectForKeyOrNil:dictionary[@"wind"]];
        NSDictionary *sys = [self objectForKeyOrNil:dictionary[@"sys"]];
        NSDictionary *main = [self objectForKeyOrNil:dictionary[@"main"]];
        NSDictionary *coordinates = [self objectForKeyOrNil:dictionary[@"coord"]];
        NSDictionary *clouds = [self objectForKeyOrNil:dictionary[@"clouds"]];
        
        
        NSNumber *longtitude = coordinates[@"lat"];
        NSNumber *latitude = coordinates[@"lon"];
        
        CLLocationDegrees longtitudeDegrees = [longtitude floatValue];
        CLLocationDegrees latitudeDegrees = [latitude floatValue];
        
        
        //_coordinate = CLLocationCoordinate2DMake(latitudeDegrees, longtitudeDegrees);
        
        //_cityName = dictionary[@"name"];
        //_weatherDescription = weather[@"description"];
        //_countryCode = sys[@"country"];
        //_weatherID = weather[@"id"];
        //_weatherMain = [self objectForKeyOrNil:weather[@"main"]];
        //NSLog(@"%@", _weatherMain);
        //_message = sys[@"message"];
        
        //_sunriseTime = sys[@"sunrise"];
        //_sunsetTime = sys[@"sunset"];
        //_cityID = dictionary[@"id"];
        _cloudiness = [self objectForKeyOrNil:clouds[@"all"]];
        
        //_humidity = main[@"humidity"];*/
        _mainTemperature = [self objectForKeyOrNil:main[@"temp"]];
        NSLog(@"%@", _mainTemperature);
        
        _temperatureMin = [self objectForKeyOrNil:main[@"temp_min"]];
        _temperatureMax = [self objectForKeyOrNil:main[@"temp_max"]];
        
         /*
        _windSpeed = wind[@"deg"];
        _windDirections = wind[@"speed"];*/
    }
    return self;
}

@end
