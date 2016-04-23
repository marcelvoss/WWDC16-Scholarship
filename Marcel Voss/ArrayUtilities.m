//
//  ArrayUtilities.m
//  Grain
//
//  Created by Marcel Voß on 19.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "ArrayUtilities.h"

@implementation ArrayUtilities

+ (NSArray *)arrayForJSON:(NSString *)filename
{
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:file options:0 error:nil];
    
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        return nil;
    } else {
        return array;
    }
}

+ (instancetype)randomObjectInArray:(NSArray *)array
{
    NSUInteger randomIndex = arc4random() % [array count];
    id theObject = array[randomIndex];
    
    return theObject;
    
}

@end
