//
//  SkillCollectionViewCell.h
//  Marcel Voss
//
//  Created by Marcel Voß on 28.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Topic;

@interface SkillCollectionViewCell : UICollectionViewCell

@property (nonatomic) Topic *topic;
@property (nonatomic) BOOL wasShown;


@end
