//
//  MainViewController.m
//  Marcel Voss
//
//  Created by Marcel Voß on 21.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "MainViewController.h"

#import "InteractiveImageView.h"

#import "FBShimmering.h"

#import "Topic.h"
#import "TopicCollectionViewCell.h"
#import "CustomMenuButton.h"

#import "ArrayUtilities.h"

static CGFloat const kMCCardPickerCollectionViewBottomInset = 4;

@interface MainViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>
{
    CGFloat width;
    CGFloat height;
    
    UIImageView *backgroundImageView;
    
    
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
    
    InteractiveImageView *avatarImageView;
    
    UIWindow *aWindow;
}

@property (nonatomic) TopicLayout *layout;
@property (nonatomic) NSMutableArray *cardsArray;


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


#pragma mark - etc
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    width = [[UIScreen mainScreen] bounds].size.width;
    height = [[UIScreen mainScreen] bounds].size.height;
    
    
    scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scrollView.contentSize = CGSizeMake(width, height * 2);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    // Background Image View
    // Containts an image that is shown on the entire scroll view
    backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundSF"]];
    backgroundImageView.frame = CGRectMake(0, 0, width, height * 2);
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.userInteractionEnabled = YES;
    [scrollView addSubview:backgroundImageView];
    
    // Background blur with UIVisualEffectView and UIBlurEffect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectViewBlurred = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectViewBlurred.frame = [backgroundImageView bounds];
    [backgroundImageView addSubview:visualEffectViewBlurred];
    
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"Hi, I'm Marcel.";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.alpha = 0;
    nameLabel.font = [UIFont boldSystemFontOfSize:22];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundImageView addSubview:nameLabel];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:- (0.5 * height)]];
    
    
    welcomeLabel = [[UILabel alloc] init];
    welcomeLabel.text = @"Nerd, developer and student";
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightLight];
    welcomeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    welcomeLabel.alpha = 0;
    [backgroundImageView addSubview:welcomeLabel];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:welcomeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:welcomeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:nameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    
    avatarImageView = [[InteractiveImageView alloc] initWithImage:[UIImage imageNamed:@"AvatarPhoto"] annotation:@"I met Craig Federighi at WWDC 2015. We talked about my scholarship app and about working at Apple."];
    avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarImageView.layer.borderWidth = 2.0;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = 100 / 2;
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundImageView addSubview:avatarImageView];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:nameLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:-50]];
    
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
    
   
    
    
    UIView *factsView = [[UIView alloc] init];
    factsView.backgroundColor = [UIColor whiteColor];
    factsView.layer.cornerRadius = 8;
    factsView.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundImageView addSubview:factsView];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:factsView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:factsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:150]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:factsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-50]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:factsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-height-50]];
    
    
    UIView *factsView1 = [[UIView alloc] init];
    factsView1.backgroundColor = [UIColor whiteColor];
    factsView1.layer.cornerRadius = 8;
    factsView1.transform = CGAffineTransformMakeRotation(0.05);
    factsView1.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundImageView addSubview:factsView1];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:factsView1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:factsView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:150]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:factsView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-50]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:factsView1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:factsView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    

    
    
    
    [self setupMenuView];
    [self showStartAnimation];
    //[self startArrowAnimation];
    [self setupAboutTopics];
    
    
}

- (void)setupMenuView
{
    
    CGFloat menuButtonWidth = width - 60;
    
    //View 1
    aboutButton = [CustomMenuButton buttonWithType:UIButtonTypeSystem];
    aboutButton.gradientImage = [UIImage imageNamed:@"EntranceWWDC"];
    aboutButton.mainLabel.text = @"About Me";
    [aboutButton addTarget:self action:@selector(aboutPressed:) forControlEvents:UIControlEventTouchUpInside];
    aboutButton.backgroundImage = [UIImage imageNamed:@"RedBackground"];
    [aboutButton.heightAnchor constraintEqualToConstant:70].active = YES;
    [aboutButton.widthAnchor constraintEqualToConstant:menuButtonWidth].active = YES;
    
    
    //View 2
    educationButton = [CustomMenuButton buttonWithType:UIButtonTypeSystem];
    [educationButton.heightAnchor constraintEqualToConstant:70].active = YES;
    educationButton.mainLabel.text = @"Education";
    [educationButton addTarget:self action:@selector(educationPressed:) forControlEvents:UIControlEventTouchUpInside];
    educationButton.gradientImage = [UIImage imageNamed:@"SchoolPhoto"];
    educationButton.backgroundImage = [UIImage imageNamed:@"GreenBackground"];
    [educationButton.widthAnchor constraintEqualToConstant:menuButtonWidth].active = YES;
    educationButton.backgroundColor = [UIColor greenColor];
    
    //View 3
    projectsButton = [CustomMenuButton buttonWithType:UIButtonTypeSystem];
    [projectsButton.heightAnchor constraintEqualToConstant:70].active = YES;
    projectsButton.mainLabel.text = @"Projects";
    [projectsButton addTarget:self action:@selector(projectsPressed:) forControlEvents:UIControlEventTouchUpInside];
    projectsButton.gradientImage = [UIImage imageNamed:@"NDRAppShot"];
    projectsButton.backgroundImage = [UIImage imageNamed:@"VioletBackground"];
    [projectsButton.widthAnchor constraintEqualToConstant:menuButtonWidth].active = YES;
    projectsButton.backgroundColor = [UIColor magentaColor];
    
    //View 4
    skillsButton = [CustomMenuButton buttonWithType:UIButtonTypeSystem];
    [skillsButton.heightAnchor constraintEqualToConstant:70].active = YES;
    skillsButton.mainLabel.text = @"Skills";
    [skillsButton addTarget:self action:@selector(skillsPressed:) forControlEvents:UIControlEventTouchUpInside];
    skillsButton.gradientImage = [UIImage imageNamed:@"NDRCodePhoto"];
    skillsButton.backgroundImage = [UIImage imageNamed:@"OrangeBackground"];
    [skillsButton.widthAnchor constraintEqualToConstant:menuButtonWidth].active = YES;
    skillsButton.backgroundColor = [UIColor magentaColor];

    
    //Stack View
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.backgroundColor = [UIColor redColor];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 10;
    
    
    [stackView addArrangedSubview:aboutButton];
    [stackView addArrangedSubview:educationButton];
    [stackView addArrangedSubview:projectsButton];
    [stackView addArrangedSubview:skillsButton];
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundImageView addSubview:stackView];
    
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:height / 2]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:400]];
    
}

- (void)aboutPressed:(id)sender
{
    scrollView.scrollEnabled = NO;
    
    /*// Background blur with UIVisualEffectView and UIBlurEffect
    UIBlurEffect *blurEffect2 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectViewBlurred2 = [[UIVisualEffectView alloc] initWithEffect:blurEffect2];
    visualEffectViewBlurred2.frame = CGRectMake(0, height, self.view.frame.size.width, height);
    visualEffectViewBlurred2.alpha = 0;
    [backgroundImageView addSubview:visualEffectViewBlurred2];
    
    [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        visualEffectViewBlurred2.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];*/
    
    
    menuCollectionView = [[UICollectionView alloc] initWithFrame:self.collectionViewFrame collectionViewLayout:_layout];
    menuCollectionView.delegate = self;
    menuCollectionView.alpha = 1;
    menuCollectionView.dataSource = self;
    menuCollectionView.backgroundColor = [UIColor clearColor];
    menuCollectionView.showsHorizontalScrollIndicator = NO;
    [backgroundImageView addSubview:menuCollectionView];
    
    
    [menuCollectionView registerClass:[TopicCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [UIView animateWithDuration:0.4 animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    
}


- (void)educationPressed:(id)sender
{
    
}

- (void)projectsPressed:(id)sender
{
    menuCollectionView.alpha = 1;
}

- (void)skillsPressed:(id)sender
{
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (TopicCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCollectionViewCell *cell = [collectionView
                                        dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 12;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)setupAboutTopics
{
    _cardsArray = [NSMutableArray array];
    
    Topic *aboutMe = [[Topic alloc] initWithTitle:@"About Me" text:@"I was born in a small town called Heide."];
    [_cardsArray addObject:aboutMe];
}

- (void)startArrowAnimation
{
    arrowYConstraint.constant = -5;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
