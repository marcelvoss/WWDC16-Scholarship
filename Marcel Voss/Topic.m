//
//  Topic.m
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "Topic.h"

@implementation Topic

- (instancetype)initWithTitle:(NSString *)topicTitle
                     subtitle:(NSString *)topicSubtitle
                         text:(NSString *)topicText
                       images:(NSArray *)imagesArray
                       option:(Options)topicOption
{
    self = [super init];
    if (self) {
        _topicTitle = topicTitle;
        _topicText = topicText;
        _topicOption = topicOption;
        _images = imagesArray;
        _topicSubtitle = topicSubtitle;
    }
    return self;
}

- (instancetype)initWithApp:(TopicApp *)appItem
{
    self = [super init];
    if (self) {
        _topicOption = OptionsApp;
        _topicApp = appItem;
    }
    return self;
}

- (instancetype)initWithSkill:(TopicSkill *)skillItem
{
    self = [super init];
    if (self) {
        _topicOption = OptionsSkill;
        _topicSkill = skillItem;
    }
    return self;
}

@end
