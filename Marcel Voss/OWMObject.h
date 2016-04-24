//
//  OWMObject.h
//  Marcel Voss
//
//  Created by Marcel Voß on 24.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface OWMObject : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString *cityName;
@property (nonatomic) NSString *weatherDescription;
@property (nonatomic) NSString *countryCode;
@property (nonatomic) NSNumber *weatherID;
@property (nonatomic) NSNumber *weatherMain;
@property (nonatomic) NSNumber *sunriseTime; // UNIX UTC
@property (nonatomic) NSNumber *sunsetTime; // UNIX UTC
@property (nonatomic) NSNumber *message;
@property (nonatomic) NSNumber *cityID;
@property (nonatomic) NSNumber *cloudiness; // in %
@property (nonatomic) NSNumber *humidity; // in %
@property (nonatomic) NSNumber *mainTemperature; // in Fahrenheit or Celsius; based on device locale
@property (nonatomic) NSNumber *mainPressure;
@property (nonatomic) NSNumber *temperatureMin;
@property (nonatomic) NSNumber *temperatureMax;

@property (nonatomic) NSNumber *windSpeed; // Metric: meter/sec; Imperial: miles/hour
@property (nonatomic) NSNumber *windDirections; // in degrees

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
