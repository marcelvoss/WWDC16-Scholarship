//
//  OWMManager.m
//  Marcel Voss
//
//  Created by Marcel Voß on 24.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "OWMManager.h"
#import "OWMObject.h"
#import "Constants.h"

static NSString *baseURL = @"http://api.openweathermap.org/data/2.5";

@interface OWMManager (Private)

- (void)GETOperationWithURL:(NSString *)url parameters:(NSDictionary *)parameters
                    success:(void (^) (NSDictionary *results, NSHTTPURLResponse *response))success
                    failure:(void (^) (NSError *error, NSHTTPURLResponse *response))failure;

- (NSString *)addUnitsToString:(NSString *)urlString;
- (NSString *)addAPIKeyToString:(NSString *)urlString;

@end

@implementation OWMManager

+ (OWMManager *)sharedManager
{
    static OWMManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)retrieveForecastForCoordinates:(CLLocationCoordinate2D)coordinates
                               success:(SuccessHandler)success
                               failure:(FailureHandler)failure
{
    // /weather?lat=35&lon=139

    NSString *urlString = [NSString
                           stringWithFormat:@"%@/weather?lat=%f&lon=%f", baseURL, coordinates.latitude, coordinates.longitude];
    
    [self GETOperationWithURL:urlString parameters:@{} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        OWMObject *aObject = [[OWMObject alloc] initWithDictionary:results];
        success(aObject, response);
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

@end

@implementation OWMManager (Private)

- (NSString *)addUnitsToString:(NSString *)urlString
{
    NSLocale *locale = [NSLocale currentLocale];
    BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
    
    if (isMetric) {
        return [NSString stringWithFormat:@"%@&units=metric", urlString];
    } else {
        return [NSString stringWithFormat:@"%@&units=imperial", urlString];
    }
}

- (NSString *)addAPIKeyToString:(NSString *)urlString
{
    NSString *tempString = [NSString stringWithFormat:@"%@&APPID=%@", urlString, weatherMapAPI];
    return tempString;
}

- (void)GETOperationWithURL:(NSString *)url parameters:(NSDictionary *)parameters
                    success:(void (^) (NSDictionary *, NSHTTPURLResponse *))success
                    failure:(void (^) (NSError *, NSHTTPURLResponse *))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json; charset=utf-8"};
    
    NSString *tempString = [self addUnitsToString:url];
    NSString *finalString = [self addAPIKeyToString:tempString];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    [[session dataTaskWithURL:[NSURL URLWithString:finalString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *convertedResponse = (NSHTTPURLResponse *)response;
        
        if (error == nil) {
            NSError *jsonError = nil;
            NSDictionary *serializedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError == nil) {
                success(serializedResults, convertedResponse);
            } else {
                failure(jsonError, nil);
            }
        } else {
            failure(error, convertedResponse);
        }
    }] resume];
}

@end
