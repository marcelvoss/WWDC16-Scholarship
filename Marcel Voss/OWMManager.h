//
//  OWMManager.h
//  Marcel Voss
//
//  Created by Marcel Voß on 24.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class OWMObject;

typedef void (^SuccessHandler) (OWMObject *weatherObject, NSHTTPURLResponse *response);
typedef void (^FailureHandler) (NSError *error, NSHTTPURLResponse *response);

@interface OWMManager : NSObject

+ (OWMManager *)sharedManager;

- (void)retrieveForecastForCoordinates:(CLLocationCoordinate2D)coordinates
                               success:(SuccessHandler)success
                               failure:(FailureHandler)failure;

@end
