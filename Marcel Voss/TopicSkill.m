//
//  TopicSkill.m
//  Marcel Voss
//
//  Created by Marcel Voß on 28.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "TopicSkill.h"

@implementation TopicSkill

- (instancetype)initWithSkill:(NSString *)skillName color:(UIColor *)skillColor progress:(NSInteger)skillProgress since:(NSInteger)skillSince
{
    self = [super init];
    if (self) {
        _skillName = skillName;
        _skillColor = skillColor;
        _skillProgress = [NSNumber numberWithInteger:skillProgress];
        _skillSince = [NSNumber numberWithInteger:skillSince];
        
    }
    return self;
}

@end
