//
//  GenericCollectionViewCell.h
//  Marcel Voss
//
//  Created by Marcel Voß on 25.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractiveImageView.h"

@class Topic;


@interface GenericCollectionViewCell : UICollectionViewCell

@property (nonatomic) Topic *topic;
@property (nonatomic) InteractiveImageView *headerImageView;

@end
