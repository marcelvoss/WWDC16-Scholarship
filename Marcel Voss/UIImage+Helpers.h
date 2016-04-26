//
//  UIImage+Helpers.h
//  Marcel Voss
//
//  Created by Marcel Voß on 26.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helpers)

+ (UIImage *)imageResize:(UIImage *)img andResizeTo:(CGSize)newSize;
+ (NSArray *)resizeImages:(NSArray *)images resizeTo:(CGSize)newSize;

@end
