//
//  TopicSkill.h
//  Marcel Voss
//
//  Created by Marcel Voß on 28.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TopicSkill : NSObject

@property (nonatomic) NSString *skillName;
@property (nonatomic) UIColor *skillColor;
@property (nonatomic) NSNumber *skillProgress;
@property (nonatomic) NSNumber *skillSince;

- (instancetype)initWithSkill:(NSString *)skillName color:(UIColor *)skillColor progress:(NSInteger)skillProgress since:(NSInteger)skillSince;

@end
