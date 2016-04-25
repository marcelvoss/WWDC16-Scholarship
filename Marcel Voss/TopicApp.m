//
//  TopicApp.m
//  Marcel Voss
//
//  Created by Marcel Voß on 25.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "TopicApp.h"

@implementation TopicApp

- (instancetype)initWithIcon:(UIImage *)appIcon
                         url:(NSURL *)appURL
                        name:(NSString *)appName
                    subtitle:(NSString *)appSubtitle
                 description:(NSString *)appDescription
                 screenshots:(NSArray *)screenshotsArray
{
    self = [super init];
    if (self) {
        _icon = appIcon;
        _appURL = appURL;
        _name = appName;
        _subtitle = appSubtitle;
        _descriptionText = appDescription;
        _screenshots = screenshotsArray;
    }
    return self;
}

@end
