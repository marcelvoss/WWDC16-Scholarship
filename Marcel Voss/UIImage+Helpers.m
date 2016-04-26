//
//  UIImage+Helpers.m
//  Marcel Voss
//
//  Created by Marcel Voß on 26.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "UIImage+Helpers.h"

@implementation UIImage (Helpers)

+ (UIImage *)imageResize:(UIImage *)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSArray *)resizeImages:(NSArray *)images resizeTo:(CGSize)newSize
{
    NSMutableArray *finalArray = [NSMutableArray arrayWithCapacity:[images count]];
    
    for (UIImage *img in images) {
        CGFloat scale = [[UIScreen mainScreen]scale];
        
        /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
        //UIGraphicsBeginImageContext(newSize);
        
        
        UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
        [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [finalArray addObject:newImage];
    }
    
    return [finalArray copy];
    
    
    
}

@end
