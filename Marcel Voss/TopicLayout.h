//
//  TopicLayout.h
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat flickVelocity;
@property (readonly) NSInteger currentIndex;

@end
