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
        
        
       
        _weatherID = [self objectForKeyOrNil:dictionary[@"weather"][0][@"id"]];
        if ([self isNumber:_weatherID inRangeMinimum:200 maximum:232]) {
            
            _condition = WeatherConditionThunderstorm;
            _weatherDescription = [self stringForCondition:_condition];
            
        } else if ([self isNumber:_weatherID inRangeMinimum:300 maximum:321]) {
            
            _condition = WeatherConditionDrizzle;
            _weatherDescription = [self stringForCondition:_condition];
            
        } else if ([self isNumber:_weatherID inRangeMinimum:500 maximum:531]) {
            
            _condition = WeatherConditionRain;
            _weatherDescription = [self stringForCondition:_condition];
            
        } else if ([self isNumber:_weatherID inRangeMinimum:600 maximum:622]) {
            
            _condition = WeatherConditionSnow;
            _weatherDescription = [self stringForCondition:_condition];
            
        } else if ([self isNumber:_weatherID inRangeMinimum:701 maximum:781]) {
            
            _condition = WeatherConditionFog;
            _weatherDescription = [self stringForCondition:_condition];
            
        } else if ([_weatherID intValue] == 800) {
            
            _condition = WeatherConditionClear;
            _weatherDescription = [self stringForCondition:_condition];
            
        } else if ([self isNumber:_weatherID inRangeMinimum:801 maximum:804]) {
            
            _condition = WeatherConditionClouds;
            _weatherDescription = [self stringForCondition:_condition];
            
        }
        
        
        //NSLog(@"%@", weather);
        
        /*
        if (weather[@"number"]) {
            NSLog(@"%@", weather[@"weather.number"]);
        }
        */
        
        //_coordinate = CLLocationCoordinate2DMake(latitudeDegrees, longtitudeDegrees);
        
        //_cityName = dictionary[@"name"];
        
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

- (NSString *)stringForCondition:(WeatherCondition)condition
{
    switch (condition) {
        case WeatherConditionFog:
            
            return @"🌁";
            
            break;
        case WeatherConditionSnow:
            
            return @"❄️";
            
            break;
        case WeatherConditionWind:
            
            return @"🍃";
            
            break;
        case WeatherConditionClear:
            
            return @"☀️";
            
            break;
        case WeatherConditionClouds:
            
            return @"☁️";
            
            break;
        case WeatherConditionThunderstorm:
            
            return @"⛈";
            
            break;
        case WeatherConditionRain:
            
            return @"🌧";
            
            break;
        case WeatherConditionDrizzle:
            
            return @"🌦";
            
            break;
    }
}

- (BOOL)isNumber:(NSNumber *)idNumber inRangeMinimum:(NSInteger)minimumValue maximum:(NSInteger)maximumValue
{
    if ([idNumber intValue] >= minimumValue && [idNumber intValue] <= maximumValue) {
        return YES;
    } else {
        return NO;
    }
}

@end
