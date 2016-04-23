//
//  ArrayUtilities.h
//  Grain
//
//  Created by Marcel Voß on 19.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArrayUtilities : NSObject

+ (NSArray *)arrayForJSON:(NSString *)filename;
+ (instancetype)randomObjectInArray:(NSArray *)array;

@end
