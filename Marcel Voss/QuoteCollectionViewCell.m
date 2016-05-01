//
//  QuoteCollectionViewCell.m
//  Marcel Voss
//
//  Created by Marcel Voß on 01.05.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "QuoteCollectionViewCell.h"

#import "Topic.h"
#import "TopicImage.h"
#import "AppCustomButton.h"
#import "AppDelegate.h"
#import "TopicQuote.h"

#import "Constants.h"

@interface QuoteCollectionViewCell ()
{
    UILabel *quoteLabel;
    UILabel *authorLabel;
    
    NSLayoutConstraint *headlineYConstraint;
}

@end

@implementation QuoteCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 12;
        
        
        quoteLabel = [[UILabel alloc] init];
        quoteLabel.textAlignment = NSTextAlignmentCenter;
        quoteLabel.font = [UIFont systemFontOfSize:16];
        quoteLabel.numberOfLines = 0;
        quoteLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:quoteLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:quoteLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:quoteLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:quoteLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-40]];
        
        
        authorLabel = [[UILabel alloc] init];
        authorLabel.textAlignment = NSTextAlignmentCenter;
        authorLabel.font = [UIFont systemFontOfSize:15];
        authorLabel.numberOfLines = 0;
        authorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:authorLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:authorLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:authorLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:quoteLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:authorLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-60]];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    TopicQuote *quote = topic.topicQuote;

    authorLabel.text = [self makeAuthorStringFromString:quote.quoteItemAuthor];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 6;
    [paraStyle setAlignment:NSTextAlignmentCenter];
    
    
    // Quote String
    NSMutableAttributedString *quoteString = [[NSMutableAttributedString alloc]
                                             initWithString:[self makeQuoteStringFromString:quote.quote]];
    [quoteString addAttribute:NSParagraphStyleAttributeName
                       value:paraStyle range:NSMakeRange(0, quoteString.length)];
    quoteLabel.attributedText = quoteString;
}

- (NSString *)makeQuoteStringFromString:(NSString *)string
{
    NSString *quotationMarkLeft = [NSString stringWithFormat:@"\u201C"];
    NSString *quotationMarkRight = [NSString stringWithFormat:@"\u201D"];
    
    return [NSString stringWithFormat:@"%@%@%@", quotationMarkLeft, string, quotationMarkRight];
}

- (NSString *)makeAuthorStringFromString:(NSString *)string
{
    return [NSString stringWithFormat:@"- %@", string];
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    _topic = nil;
    quoteLabel.attributedText = nil;
    authorLabel.text = nil;
    
    [self setNeedsLayout];
}

@end
