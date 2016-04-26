//
//  ProjectCollectionViewCell.m
//  Marcel Voss
//
//  Created by Marcel Voß on 25.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "ProjectCollectionViewCell.h"

#import "Constants.h"
#import "UIColor+Colors.h"
#import "TopicApp.h"

@interface ProjectCollectionViewCell ()
{
    UILabel *headlineLabel;
    UILabel *subtitleLabel;
    UILabel *textLabel;
    
    UIImageView *appIconView;
    UIImageView *backgroundImageView;
}

@end

@implementation ProjectCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        backgroundImageView = [[UIImageView alloc] init];
        
        
    }
    return self;
}

- (void)setApp:(TopicApp *)app
{
    _app = app;
}


@end
