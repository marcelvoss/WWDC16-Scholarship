//
//  TopicLayout.m
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "TopicLayout.h"

@interface TopicLayout ()
{
    CGFloat height;
    CGFloat width;
}

@end

@implementation TopicLayout

- (void)prepareLayout
{
    [super prepareLayout];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"collectionView.contentOffset"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"collectionView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        CGRect screen = [[UIScreen mainScreen] bounds];
        height = screen.size.height;
        width = screen.size.width;
        
        self.minimumLineSpacing = 20;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(10, 35, 0, 35);
    }
    return self;
}

- (CGFloat)cardWidth {
    return self.itemSize.width + self.minimumLineSpacing;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat rawIndex = self.collectionView.contentOffset.x / self.cardWidth;
    CGFloat nextIndex = (velocity.x > 0.0) ? ceil(rawIndex) : floor(rawIndex);
    
    BOOL pannedLessThanACard = fabs(1 + currentIndex - rawIndex) > 0.5;
    BOOL flicked = fabs(velocity.x) > [self flickVelocity];
    if (pannedLessThanACard && flicked) {
        proposedContentOffset.x = nextIndex * self.cardWidth;
    } else {
        proposedContentOffset.x = round(rawIndex) * self.cardWidth;
    }
    
    return proposedContentOffset;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"collectionView.contentOffset"]) {
        NSInteger newIndex = round(self.collectionView.contentOffset.x / [self cardWidth]);
        if (currentIndex != newIndex) {
            currentIndex = newIndex;
        }
    }
}

@synthesize currentIndex;



@end
