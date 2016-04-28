//
//  AppCustomButton.m
//  Marcel Voss
//
//  Created by Marcel Voß on 24.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "AppCustomButton.h"

#import "Constants.h"

@interface AppCustomButton () <SKStoreProductViewControllerDelegate>
{
    UIViewController *controller;
    SKStoreProductViewController *storeVC;
}

@end

@implementation AppCustomButton

// TODO: Complete this -> unfinished

- (void)setAppStoreURL:(NSURL *)appStoreURL appIcon:(UIImage *)appIcon
{
    _appIcon = appIcon;
    _appStoreURL = appStoreURL;
    
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setBackgroundImage:appIcon forState:UIControlStateNormal];
    [self addTarget:self action:@selector(showApp) forControlEvents:UIControlEventTouchDown];
}

#pragma mark - Handling Action

- (void)showApp
{
    NSLog(@"App Pressed");
}

#pragma mark - Pressed Animations

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    
    self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:UIViewAnimationOptionTransitionNone animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:UIViewAnimationOptionTransitionNone animations:^{
        
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)storePresed:(id)sender
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    controller = window.rootViewController;
    
    storeVC = [[SKStoreProductViewController alloc] init];
    storeVC.delegate = self;
    
    NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier: pbAppID};
    [storeVC loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError * _Nullable error) {
        if (result) {
            [controller presentViewController:storeVC animated:YES completion:nil];
        }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController presentViewController:storeVC animated:YES completion:nil];
}

@end
