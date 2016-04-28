//
//  AppCustomButton.h
//  Marcel Voss
//
//  Created by Marcel Voß on 24.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@class TopicApp;

@interface AppCustomButton : UIButton

@property (nonatomic) NSURL *appStoreURL;
@property (nonatomic) UIImage *appIcon;

- (void)setAppStoreURL:(NSURL *)appStoreURL appIcon:(UIImage *)appIcon;

@end
