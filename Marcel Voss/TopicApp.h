//
//  TopicApp.h
//  Marcel Voss
//
//  Created by Marcel Voß on 25.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TopicApp : NSObject

@property (nonatomic) UIImage *icon;
@property (nonatomic) NSURL *appURL;
@property (nonatomic) NSArray *screenshots;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) NSString *descriptionText;

- (instancetype)initWithIcon:(UIImage *)appIcon
                         url:(NSURL *)appURL
                        name:(NSString *)appName
                    subtitle:(NSString *)appSubtitle
                 description:(NSString *)appDescription
                 screenshots:(NSArray *)screenshotsArray;

@end
