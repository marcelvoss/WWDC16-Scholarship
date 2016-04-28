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
+ (UIImage *)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height;
+ (UIImage *)imageFromColor:(UIColor *)color;

@end
