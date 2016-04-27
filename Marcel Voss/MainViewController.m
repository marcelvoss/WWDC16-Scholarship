//
//  MainViewController.m
//  Marcel Voss
//
//  Created by Marcel Voß on 21.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "MainViewController.h"

#import "InteractiveImageView.h"

#import "FBShimmeringView.h"
#import "Constants.h"

#import "GenericCollectionViewCell.h"
#import "MapCollectionViewCell.h"
#import "ProjectCollectionViewCell.h"

#import "CustomMenuButton.h"
#import "WeatherCard.h"

#import "Topic.h"
#import "TopicApp.h"
#import "ArrayUtilities.h"
#import "UIImage+Helpers.h"

#import "Marcel_Voss-Swift.h"

static CGFloat const kMCCardPickerCollectionViewBottomInset = 4;
static CGFloat const kPanTriggerFadeOutDistance = 200.0;
static CGFloat const kPanTriggerExpandDistance = 50.0;

typedef NS_ENUM(NSInteger, MenuTopic) {
    MenuTopicAbout,
    MenuTopicEducation,
    MenuTopicProjects
};

@interface MainViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    CGFloat width;
    CGFloat height;
    
    UIImage *mapShot;
    UIStackView *stackView;
    
    UIImageView *backgroundImageView;
    BOOL firstScrollDown;
    
    UILabel *nameLabel;
    UILabel *welcomeLabel;
    
    UIImageView *arrowImageView;
    NSLayoutConstraint *arrowYConstraint;
    
    
    UIScrollView *scrollView;
    UICollectionView *menuCollectionView;
    
    NSLayoutConstraint *menuCollectionYConstraint;
    
    CustomMenuButton *aboutButton;
    CustomMenuButton *projectsButton;
    CustomMenuButton *educationButton;
    CustomMenuButton *skillsButton;
    CustomMenuButton *moreButton;
    
    InteractiveImageView *avatarImageView;

    UIVisualEffectView *visualEffectViewBlurred2;
}

@property (nonatomic) TopicLayout *layout;
@property (nonatomic) NSMutableArray *topicsArray;

- (CGSize)cardSize;
- (CGFloat)cardScaleRatio;
- (CGRect)collectionViewFrame;
- (UICollectionViewCell *)selectedCell;

@end

@implementation MainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bottomInset = kMCCardPickerCollectionViewBottomInset;
        
        self.layout = [[TopicLayout alloc] init];
        self.layout.itemSize = self.cardSize;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    firstScrollDown = YES;
    
    width = [[UIScreen mainScreen] bounds].size.width;
    height = [[UIScreen mainScreen] bounds].size.height;
    
    
    scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scrollView.contentSize = CGSizeMake(width, height * 2);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    // Background Image View
    // Containts an image that is shown on the entire scroll view
    backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VenueWWDC"]];
    backgroundImageView.frame = CGRectMake(0, 0, width, height * 2);
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.userInteractionEnabled = YES;
    [scrollView addSubview:backgroundImageView];
    
    // Background blur with UIVisualEffectView and UIBlurEffect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectViewBlurred = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectViewBlurred.frame = [backgroundImageView bounds];
    [backgroundImageView addSubview:visualEffectViewBlurred];
    
    
    // Invisible view to make AL easier
    UIView *canvasView = [[UIView alloc] init];
    canvasView.translatesAutoresizingMaskIntoConstraints = NO;
    canvasView.backgroundColor = [UIColor clearColor];
    [backgroundImageView addSubview:canvasView];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:canvasView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:canvasView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:- (0.5 * height)]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:canvasView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:350]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:canvasView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:300]];
    
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"Hi, I'm Marcel.";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.alpha = 0;
    nameLabel.font = [UIFont boldSystemFontOfSize:22];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundImageView addSubview:nameLabel];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:canvasView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:canvasView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:10]];
    
    
    welcomeLabel = [[UILabel alloc] init];
    welcomeLabel.text = @"Nerd, developer and student";
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightLight];
    welcomeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    welcomeLabel.alpha = 0;
    [backgroundImageView addSubview:welcomeLabel];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:welcomeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:nameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:welcomeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:canvasView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    
    //[UIImage imageNamed:@"AvatarPhoto"]
    UIImage *tempAvatarImage = [UIImage resizeImage:[UIImage imageNamed:@"AvatarPhoto"] withWidth:100 withHeight:100];
    TopicImage *avatarImage = [[TopicImage alloc] initWithSDImage:tempAvatarImage HDImage:[UIImage imageNamed:@"AvatarPhoto"] annotation:@"I met Craig Federighi at WWDC 2015. We talked about my scholarship app and about working at Apple."];
    avatarImageView = [[InteractiveImageView alloc] initWithImages:@[avatarImage] type:ViewerTypeImage];
    avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarImageView.layer.borderWidth = 2.0;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = 100 / 2;
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundImageView addSubview:avatarImageView];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:canvasView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:canvasView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-10]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:100]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:100]];
    
    
    
    
    arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowIcon"]];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    [backgroundImageView addSubview:arrowImageView];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    arrowYConstraint = [NSLayoutConstraint constraintWithItem:arrowImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-height - 15];
    [backgroundImageView addConstraint:arrowYConstraint];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:18]];
    
    
    [self setupMenuView];
    [self showStartAnimation];
    //[self startArrowAnimation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMenuView
{
    CGFloat menuButtonWidth = width - 60;
    
    //View 1
    aboutButton = [CustomMenuButton buttonWithType:UIButtonTypeCustom];
    aboutButton.gradientImage = [UIImage imageNamed:@"WWDCEntrance"];
    aboutButton.mainLabel.text = @"About Me";
    [aboutButton addTarget:self action:@selector(aboutPressed:) forControlEvents:UIControlEventTouchUpInside];
    aboutButton.backgroundImage = [UIImage imageNamed:@"RedBackground"];
    [aboutButton.heightAnchor constraintEqualToConstant:70].active = YES;
    [aboutButton.widthAnchor constraintEqualToConstant:menuButtonWidth].active = YES;
    
    
    //View 2
    educationButton = [CustomMenuButton buttonWithType:UIButtonTypeCustom];
    [educationButton.heightAnchor constraintEqualToConstant:70].active = YES;
    educationButton.mainLabel.text = @"Education";
    [educationButton addTarget:self action:@selector(educationPressed:) forControlEvents:UIControlEventTouchUpInside];
    educationButton.gradientImage = [UIImage imageNamed:@"SchoolPhoto"];
    educationButton.backgroundImage = [UIImage imageNamed:@"BlueBackground"];
    [educationButton.widthAnchor constraintEqualToConstant:menuButtonWidth].active = YES;
    
    //View 3
    projectsButton = [CustomMenuButton buttonWithType:UIButtonTypeCustom];
    [projectsButton.heightAnchor constraintEqualToConstant:70].active = YES;
    projectsButton.mainLabel.text = @"Projects";
    [projectsButton addTarget:self action:@selector(projectsPressed:) forControlEvents:UIControlEventTouchUpInside];
    projectsButton.gradientImage = [UIImage imageNamed:@"NDRAppShot"];
    projectsButton.backgroundImage = [UIImage imageNamed:@"OrangeBackground"];
    [projectsButton.widthAnchor constraintEqualToConstant:menuButtonWidth].active = YES;
    
    //View 4
    skillsButton = [CustomMenuButton buttonWithType:UIButtonTypeCustom];
    [skillsButton.heightAnchor constraintEqualToConstant:70].active = YES;
    skillsButton.mainLabel.text = @"Skills";
    [skillsButton addTarget:self action:@selector(skillsPressed:) forControlEvents:UIControlEventTouchUpInside];
    skillsButton.gradientImage = [UIImage imageNamed:@"NDRCodePhoto"];
    skillsButton.backgroundImage = [UIImage imageNamed:@"GreenBackground"];
    [skillsButton.widthAnchor constraintEqualToConstant:menuButtonWidth].active = YES;

    
    //Stack View
    stackView = [[UIStackView alloc] init];
    stackView.alpha = 0;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 10;
    
    [stackView addArrangedSubview:aboutButton];
    [stackView addArrangedSubview:educationButton];
    [stackView addArrangedSubview:projectsButton];
    [stackView addArrangedSubview:skillsButton];
    [stackView addArrangedSubview:moreButton];
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundImageView addSubview:stackView];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:height / 2]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:height - 300]];
    
}

#pragma mark - Custom Collection View

- (CGFloat)cardScaleRatio
{
    return self.cardSize.width / self.view.frame.size.width;
}

- (CGSize)cardSize
{
    CGRect frame = self.view.bounds;
    frame.size.width -= self.layout.sectionInset.left + self.layout.sectionInset.right;
    frame.size.height = CGRectGetHeight(self.collectionViewFrame) - (self.layout.sectionInset.top + _bottomInset + 140);
    return frame.size;
}

- (CGRect)collectionViewFrame
{
    CGRect frame = CGRectZero;
    frame.origin.y = height;
    frame.size.width = CGRectGetWidth(self.view.frame);
    //frame.size.height = CGRectGetHeight(self.view.frame) - frame.origin.y + self.bottomInset;
    frame.size.height = height;
    return frame;
}

- (void)restoreLayout:(BOOL)animated
{
    NSTimeInterval duration = animated ? 0.25 : 0;
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        menuCollectionView.frame = [self collectionViewFrame];
    } completion:NULL];
}

// TODO: Code optimieren
- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
        UIPanGestureRecognizerDirectionUndefined,
        UIPanGestureRecognizerDirectionUp,
        UIPanGestureRecognizerDirectionDown
    };
    
    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (direction == UIPanGestureRecognizerDirectionUndefined) {
                CGPoint velocity = [gesture velocityInView:gesture.view];
                if (velocity.y > 0) {
                    direction = UIPanGestureRecognizerDirectionDown;
                } else {
                    direction = UIPanGestureRecognizerDirectionUp;
                    //[self.delegate cardPickerCollectionViewController:self preparePresentingView:self.presentingView fromSelectedCell:self.selectedCell];
                }
            }
            
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [gesture translationInView:self.view];
            if (direction == UIPanGestureRecognizerDirectionDown) {
                if (point.y<0) {
                    [self restoreLayout:NO];
                }
                else {
                    CGFloat alpha = 1 - fabs(point.y/kPanTriggerFadeOutDistance);
                    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:alpha];
                    
                    CGRect frame = menuCollectionView.frame;
                    frame.origin.y = self.collectionViewFrame.origin.y + MAX(point.y, 0);
                    menuCollectionView.frame = frame;
                }
            }
            else if (direction == UIPanGestureRecognizerDirectionUp) {
                UICollectionViewCell *cell = self.selectedCell;
                if (point.y>0) {
                    [self restoreCellLayout:cell isAnimated:NO];
                }
            }
            
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            if (direction == UIPanGestureRecognizerDirectionDown) {
                BOOL shouldDismiss = CGRectGetMinY(menuCollectionView.frame) > kPanTriggerFadeOutDistance;
                if (shouldDismiss) {
                    [self fadeOut];
                }
                else {
                    [self restoreLayout:YES];
                }
            }
            else if (direction == UIPanGestureRecognizerDirectionUp) {
                CGFloat xScale = visualEffectViewBlurred2.transform.a;
                CGFloat halfScale = self.cardScaleRatio + (1-self.cardScaleRatio)/2;
                if (xScale < halfScale) {
                    [self restoreCellLayout:self.selectedCell isAnimated:YES];
                }
            }
            
            direction = UIPanGestureRecognizerDirectionUndefined;
            break;
        }
        default:
            break;
    }
}

- (void)expandPresentingViewWithCell:(UICollectionViewCell *)cell andScaleDelta:(CGFloat )delta
{
    CGFloat scale = 1 + delta * 0.18;
    cell.transform = CGAffineTransformMakeScale(scale,scale);
    cell.alpha = 1 - delta * 2;
    //self.presentingView.alpha = delta * 2;
    
    scale = self.cardScaleRatio + delta * (1 - self.cardScaleRatio);
    CGFloat topOffset = self.collectionViewFrame.origin.y * self.cardScaleRatio;
    CGAffineTransform t = CGAffineTransformMakeTranslation(0.0, topOffset - topOffset * delta);
    CGAffineTransform s = CGAffineTransformMakeScale(scale, scale);
    self.view.transform = CGAffineTransformConcat(s, t);
}

- (void)restoreCellLayout:(UICollectionViewCell *)cell isAnimated:(BOOL)animated
{
    NSTimeInterval duration = animated ? 0.25 : 0;
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.transform = CGAffineTransformMakeScale(1, 1);
        cell.alpha = 1;
        //self.presentingView.alpha = 0;
        //self.presentingView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:NULL];
}

- (UICollectionViewCell *)selectedCell
{
    return [menuCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.layout.currentIndex inSection:0]];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    if (aScrollView == menuCollectionView) {
        return;
    }
    
    if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat y = scrollView.contentOffset.y;
        if (y < 0) {
            CGFloat delta = 1 - MIN(1, fabs(y/kPanTriggerExpandDistance));
            [self expandPresentingViewWithCell:self.selectedCell andScaleDelta:delta];
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate
{
    if (aScrollView == menuCollectionView) {
        return;
    }
    
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:scrollView.panGestureRecognizer.view];
    if (velocity.y>0 && scrollView.contentOffset.y <=0) {
        [self restoreCellLayout:self.selectedCell isAnimated:YES];
    }
    else {
        [self expandPresentingViewWithCell:self.selectedCell andScaleDelta:1];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    if (aScrollView == scrollView) {
        if (firstScrollDown) {
            [self showMenuAnimation];
        }
    }
}

#pragma mark - UIGestureRecongizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint velocity = [panGestureRecognizer velocityInView:menuCollectionView];
    BOOL isVerticalPan = fabs(velocity.y) > fabs(velocity.x);
    BOOL isScrolling = menuCollectionView.isDragging || menuCollectionView.isDecelerating;
    return isVerticalPan && !isScrolling;
}

- (void)fadeOut
{
    [UIView transitionWithView:self.view duration:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
        menuCollectionView.frame = CGRectOffset(menuCollectionView.frame, 0, CGRectGetHeight(self.view.frame));
        visualEffectViewBlurred2.effect = nil;
    } completion:^(BOOL finished) {
        scrollView.scrollEnabled = YES;
        _topicsArray = nil;
        [visualEffectViewBlurred2 removeFromSuperview];
        _topicsArray = nil;
    }];
}

#pragma mark - Menu Control

- (void)aboutPressed:(id)sender
{
    [self setupTopicsForMenuTopic:MenuTopicAbout];
    [self setupCollectionViewForMenuTopic:MenuTopicAbout];
}

- (void)educationPressed:(id)sender
{
    [self setupTopicsForMenuTopic:MenuTopicEducation];
    [self setupCollectionViewForMenuTopic:MenuTopicEducation];
}

- (void)projectsPressed:(id)sender
{
    [self setupTopicsForMenuTopic:MenuTopicProjects];
    [self setupCollectionViewForMenuTopic:MenuTopicProjects];
}

- (void)skillsPressed:(id)sender
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        aboutButton.alpha = 0;
        
        
    } completion:nil];
    
    
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        educationButton.alpha = 0;
    } completion:nil];
    
    [UIView animateWithDuration:0.2 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        projectsButton.alpha = 0;
    } completion:nil];
    
    [UIView animateWithDuration:0.2 delay:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
        skillsButton.alpha = 0;
    } completion:^(BOOL finished) {
        stackView.hidden = YES;
        
        // Show the skillview after completing last animation

         SkillView *s2 = [[SkillView alloc] initWithName:@"Objective-C" percentage:4 color:[UIColor redColor] since:@"Since 2012" frame:CGRectMake(20, 200 + 150, width, 65)];
         [s2 runAnimationWithDuration:2 delay:0.5];
        
        
        //Stack View
        UIStackView *skillStack = [[UIStackView alloc] init];
        skillStack.alpha = 1;
        skillStack.axis = UILayoutConstraintAxisVertical;
        skillStack.distribution = UIStackViewDistributionEqualSpacing;
        skillStack.alignment = UIStackViewAlignmentCenter;
        skillStack.spacing = 10;
        skillStack.translatesAutoresizingMaskIntoConstraints = NO;
        [skillStack addArrangedSubview:s2];
        [backgroundImageView addSubview:skillStack];
        
        [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:skillStack attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:skillStack attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:height / 2]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:skillStack attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:skillStack attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:height - 300]];
    }];
    
}

- (void)setupTopicsForMenuTopic:(MenuTopic)menuTopic
{
    _topicsArray = [NSMutableArray array];
    
    // TODO: Finish content
    switch (menuTopic) {
        case MenuTopicAbout:
        {
            [self setupMapShot];
            // TODO: Finish this and check for spelling and grammar
            TopicImage *aImage = [[TopicImage alloc] initWithImage:mapShot annotation:nil];
            Topic *a = [[Topic alloc] initWithTitle:@"Beginning of a Journey"
                                           subtitle:@""
                                               text:@"I grew up in the small town of Heide in northern Germany.\n\nFrom early on I was fascinated by technology and wanted to understand how, both, software and hardware work. This fascination was intensified when I bought my first iPod touch back in 2009. I couldn't believe how unique the entire ecosystem was (even though I called it differently back then), how simple it was and how beautiful the software was.\n\nTwo years later, I got my first Intel-based Mac. This was basically the beginning of the story. I downloaded Xcode, talked to experienced developers on the Internet, read books and slowly got into the matter.\n\nCrazy it's almost been 4 years since then."
                                             images:@[aImage]
                                             option:OptionsMap];
            
            // TODO: Finish the annotations and check for spelling and grammar
            TopicImage *bImage1 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"JugendHackt"]
                                                         annotation:@""];
            TopicImage *bImage2 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"JugendHacktGroup"]
                                                         annotation:@"\"Jugend hackt\" (German for \"Youth's hacking\") was one of the first hackathons in Germany, which is why there weren't that many people. It was fun, though."];
            TopicImage *bImage3 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"JugendHacktStage"]
                                                         annotation:@"Presenting your idea to other teenagers was something I really appreciated about Jugend hackt."];
            Topic *b = [[Topic alloc] initWithTitle:@"Jugend hackt"
                                           subtitle:@""
                                               text:@"In 2013, just one year after I started learning Objective-C, I participated in my first hackathon which was \"Jugend hackt\" in Berlin.\n\nWe built a small app with a corresponding web service, called \"Kleiderfrosch\", that recommended you what kind of clothes to wear for the whole day – based on the weather forecast.\n\nThe jury really liked our idea and awarded us in the category \"I Wish I'd Thought of That\"\n\nIt was a great experience that showed me I'm not the only teenager who is interested in software development.\n\nUnfortunately, hackathons still aren't as popular in Germany as they are in the USA."
                                             images:@[bImage1, bImage2, bImage3]
                                             option:OptionsGeneric];
            
            
            // TODO: Continue content
            TopicImage *cImage1 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"EscalatorWWDC"]
                                                         annotation:@"The moment everyone waited for: the opening keynote. What a feeling to be there!"];
            TopicImage *cImage2 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"VenueWWDC"]
                                                         annotation:@"When I saw those banners on the other building I started realizing I'm in San Francisco for WWDC. I couldn't believe it until then."];
            TopicImage *cImage3 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"FriendsWWDC"]
                                                         annotation:@"On Sunday, at registration, I met a couple of other scholars and eventual friends."];
            TopicImage *cImage4 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"DoorsWWDC"]
                                                         annotation:@"Being in front of the Moscone center for the first time was quite amazing."];
            TopicImage *cImage5 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"FirstEveningWWDC"]
                                                         annotation:@"On the first day in San Francisco, a couple of friends and I enjoyed ourselves. We had a great time!"];
             Topic *c = [[Topic alloc] initWithTitle:@"WWDC 2015"
                                            subtitle:@""
                                                text:@"Last year, I took part in Apple's WWDC scholarship challenge for the first. Luckily, I won a ticket and was able to attended the conference.\n\nSeriously, this was the best week of my entire life. I met so many smart people, made new friends, saw amazing places and learned a load of new stuff.\n\nFinally visiting the actual conference after streaming it for years still gives me goosebumps until today.\n\nHowever, the most amazing thing about WWDC was that it felt like coming home. You are surrounded by people who are like you, who accept you without a blink. I have never experienced something comparable."
                                              images:@[cImage1, cImage2, cImage3, cImage4, cImage5]
                                              option:OptionsGeneric];
            

            TopicImage *dImage1 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"SFDiversity"]
                                                         annotation:@"Acceptance and diversity are values I cherish and San Francisco is the heart of diversity."];
            TopicImage *dImage2 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"StreetSF"]
                                                         annotation:@"Yes, this was my first time in San Francisco but I already felt better than I did home."];
            Topic *d = [[Topic alloc] initWithTitle:@"Consequences"
                                           subtitle:nil
                                               text:@"Software development already had a quite impressive impact on me and my life. There was a time in my life where I was an absolute outsider, I was afraid to talk to other people and basically didn't have any self-confidence – this drastically changed after becoming a \"nerd\".\n\nI'm no longer an outsider since I know there are many other teenagers like me and that I don't have to fit in if I don't want to. Nobody judged me becaue of my age, my looks or my nationality – only by my experience.\n\nThe techology sector (and particulary Apple) is one of the leading forces in equality and impartiality.\n\nBy embracing that and by being open-minded it is possible to achieve truly great things."
                                             images:@[dImage1, dImage2]
                                             option:OptionsGeneric];
            
            
            TopicImage *eImage1 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"FacebookCampus"]
                                                         annotation:@"Visiting the Facebook campus was another motivating experience: I'm going to work as hard as I have to in order to work at such an awesome place."];
            TopicImage *eImage2 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"FoggyBash"]
                                                         annotation:@"Views like this one motivate me to work even harder to achieve what I want."];
            Topic *e = [[Topic alloc] initWithTitle:@"Plans for the Future"
                                           subtitle:nil
                                               text:@"As far as I can remember, I already wanted to live and work in a different country (or at least in a big city) since I was a little kid.\n\nGrowing up in a small city like Heide is not easy for people like me. For people who are not like the others. For people who, well, think different.\n\nI'm living in rural area and open-minded people are rare around here and it's usual to get insulted for being the way you are.\n\nSo, yes. I want to live in a city like San Francisco where nobody cares about your quirks and I want to work for a company that embraces a similar mindset like me."
                                             images:@[eImage1, eImage2]
                                             option:OptionsGeneric];
            
            [_topicsArray addObjectsFromArray:@[a, b, c, d, e]];
        }
            break;
        case MenuTopicEducation:
        {
            TopicImage *aImage1 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"SchoolPhoto"]
                                                         annotation:@"That is my high school. It's not the prettiest one but I had a couple of good years here."];
            Topic *a = [[Topic alloc] initWithTitle:@"High School"
                                           subtitle:nil
                                               text:@"At the moment, I am a grade 11 student at the \"Gymnasium Heide-Ost\". It's a high school with about 1500 students. Next summer, I will, hopefully, finish high school and pass the secondary school exams.\n\nIn school I'm very interested in English, Biology and History.\n\nUnfortunately, there aren't any \"real\" CS classes. I put that in quotes, because the classes basically consist of copying Java code from the Internet into Eclipse or they are about the correct usage of word processors."
                                             images:@[aImage1]
                                             option:OptionsGeneric];
            
            
            TopicImage *bImage1 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"CollegeStanford"]
                                                         annotation:@"Studying in Silicon Valley would be obviously awesome."];
            Topic *b = [[Topic alloc] initWithTitle:@"Studying or Working?"
                                           subtitle:nil
                                               text:@"Well, there are two things that I would like to do after finishing high school: either studying computer science at a college (preferable an American one) or immediately working as an iOS developer.\n\nStudying is interesting because education and knowledge are two of the most important resources we, as human race, have. More education is great but studying is very theoretically.\n\nI also want to make or create something. That's why I also want to work."
                                             images:@[bImage1]
                                             option:OptionsGeneric];
            
            TopicImage *cImage1 = [[TopicImage alloc] initWithImage:[UIImage imageNamed:@"NewspaperPhoto"]
                                                         annotation:@"Yep, the local newspaper took a couple of photo, too."];
            Topic *c = [[Topic alloc] initWithTitle:@"Volunteer Engagement"
                                           subtitle:nil
                                               text:@"Helping young people and minority groups is an important task, in my opinion.\n\nFor example I am volunteering in a program that teaches Syrian refugees fundamental German skills.\n\nLast year, the principal and I also organized a course for boys and girls to teach them the basics of writing code and making them interested in continuing on their own. It was quite successful which shows that there aren't enough, free, coding courses for kids."
                                             images:@[cImage1]
                                             option:OptionsGeneric];

            [_topicsArray addObjectsFromArray:@[a, b, c]];
        }
            break;
        case MenuTopicProjects:
        {
            // TODO: UI is very ugly
            TopicApp *a = [[TopicApp alloc] initWithIcon:[UIImage imageNamed:@"PhoneBatteryIcon"] url:[NSURL URLWithString:phoneBatteryURLString] name:@"PhoneBattery" subtitle:@"Your phone's battery, on your wrist." description:@"PhoneBattery is a tiny utility app that displays your iPhone's battery level right on your Apple Watch.\n\nIt is pretty useful if you're working out and your palms are sweaty or if your phone is in your backpack.\n\nI had the idea for PhoneBattery on the plane back to Germany after last year's WWDC and had almost finished it after landing back in Hamburg." screenshots:@[]];
            Topic *p1 = [[Topic alloc] initWithApp:a];
            
            TopicApp *b = [[TopicApp alloc] initWithIcon:[UIImage imageNamed:@"GrainIcon"] url:[NSURL URLWithString:phoneBatteryURLString] name:@"Grain" subtitle:@"" description:@"" screenshots:@[]];
            Topic *p2 = [[Topic alloc] initWithApp:b];
            
            TopicApp *c = [[TopicApp alloc] initWithIcon:[UIImage imageNamed:@"MVDribbbleKitIcon"] url:[NSURL URLWithString:dribbbleURLString] name:@"MVDribbbleKit" subtitle:@"" description:@"MVDribbbleKit is an easy-to-use, full-featured Objective-C wrapper for the official Dribbble API.\n\nIt is the most successful Dribbble wrapper for iOS and is being actively used in several Dribbble apps on the App Store.\n\nApart from that, it is also my most popular open source project which makes it even cooler." screenshots:@[]];
            Topic *p3 = [[Topic alloc] initWithApp:c];
            
            [_topicsArray addObjectsFromArray:@[p1, p2, p3]];
        }
            break;
    }
}

- (void)setupCollectionViewForMenuTopic:(MenuTopic)menuTopic
{
    scrollView.scrollEnabled = NO;
    
    visualEffectViewBlurred2 = [[UIVisualEffectView alloc] init];
    visualEffectViewBlurred2.frame = CGRectMake(0, height, self.view.frame.size.width, height);
    [backgroundImageView addSubview:visualEffectViewBlurred2];
    
    [UIView animateWithDuration:0.3 animations:^{
        visualEffectViewBlurred2.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }];
    
    
    // Setting a temporary frame to move the menuCollectionView out of the view
    CGRect tempFrame = CGRectMake(0, height * 3, CGRectGetWidth(self.view.frame), height);
    menuCollectionView = [[UICollectionView alloc] initWithFrame:tempFrame collectionViewLayout:_layout];
    menuCollectionView.delegate = self;
    menuCollectionView.dataSource = self;
    menuCollectionView.backgroundColor = [UIColor clearColor];
    menuCollectionView.showsHorizontalScrollIndicator = NO;
    [backgroundImageView addSubview:menuCollectionView];
    
    [menuCollectionView registerClass:[GenericCollectionViewCell class] forCellWithReuseIdentifier:@"CellGeneric"];
    [menuCollectionView registerClass:[MapCollectionViewCell class] forCellWithReuseIdentifier:@"CellMap"];
    [menuCollectionView registerClass:[ProjectCollectionViewCell class] forCellWithReuseIdentifier:@"CellProjects"];
    
    
    if (menuTopic == MenuTopicAbout) {
        [self setupMapShot];
    }
    
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.delegate = self;
    [menuCollectionView addGestureRecognizer:panRecognizer];
    
    [UIView animateWithDuration:0.4 delay:0.3 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
        menuCollectionView.frame = CGRectMake(0, height, CGRectGetWidth(self.view.frame), height);
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_topicsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GenericCollectionViewCell *cellGeneric = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellGeneric"
                                                                                       forIndexPath:indexPath];
    MapCollectionViewCell *cellMap = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellMap"
                                                                               forIndexPath:indexPath];
    ProjectCollectionViewCell *cellProjects = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellProjects"
                                                                               forIndexPath:indexPath];
    
    Topic *topic = _topicsArray[indexPath.row];
    if (topic.topicOption == OptionsMap) {
        
        cellMap.topic = topic;
        
        return cellMap;
    } else if (topic.topicOption == OptionsGeneric) {
        
        cellGeneric.topic = topic;
        
        return cellGeneric;
        
    } else if (topic.topicOption == OptionsApp) {
        
        cellProjects.topic = topic;
        
        return cellProjects;
    }
    
    return cellGeneric;
}

#pragma mark - Pure Animation

- (void)startArrowAnimation
{
    
    arrowYConstraint.constant = 5;
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        
        [backgroundImageView layoutIfNeeded];
        
        // set the new frame
    } completion:nil];
}

- (void)showStartAnimation
{
    [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        nameLabel.alpha = 1;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            welcomeLabel.alpha = 1;
            
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    // TODO: Add little bouncing animation to arrow
    /*
    */
    
    
    // Adds a little scale and spring animation to the avatarImageView
    avatarImageView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.4 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:UIViewAnimationOptionTransitionNone animations:^{
        
        avatarImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setupMapShot
{
    if (mapShot == nil) {
       // headlineYConstraint.constant = - 75;
        //[self layoutIfNeeded];
        
        CGSize cardSizeHeader = CGSizeMake(self.cardSize.width, 150);
        
        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
        options.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(HEIDE_LATITUDE, HEIDE_LONGTITUDE), MKCoordinateSpanMake(0.05, 0.05));
        
        
        options.size = cardSizeHeader;
        options.scale = [[UIScreen mainScreen] scale];
        
        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
        [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
            if (error) {
                
                // TODO: Add logic for better error instead of alert -> icon or something
                
                
                return;
            } else {
                mapShot = snapshot.image;
                //headerImageView.alpha = 0;
                
                //headlineYConstraint.constant = -5;
                [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    /*TopicImage *topicImage = [[TopicImage alloc] initWithImage:mapShot annotation:nil];
                    [headerImageView setImages:@[topicImage] type:ViewerTypeMap];*/
                    //headerImageView.alpha = 1;
                    //[self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    
                }];
            }
        }];
    } else {
        NSLog(@"Map shot has already been created");
    }
}

- (void)showMenuAnimation
{
    stackView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    stackView.alpha = 1;
    [UIView animateWithDuration:0.4 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:UIViewAnimationOptionTransitionNone animations:^{
        
        stackView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        
    }];
    
    firstScrollDown = NO;
}

@end
