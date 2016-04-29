//
//  InteractiveImageView.m
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "InteractiveImageView.h"

#import "Constants.h"
#import "UIImage+Helpers.h"

#import <MapKit/MapKit.h>

#import "Marcel_Voss-Swift.h"

@implementation InteractiveImageView
{
    NSInteger currentImageIndex;
}

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        //self.contentMode = UIViewContentModeCenter;
        
        _slideTime = 5;
        _fadeTime = 1;
        currentImageIndex = 0;
        
        [self gestureForViewerType:_viewerType];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleToFill;
        
        self.image = image;
        
        self.viewerType = ViewerTypeImage;
        [self gestureForViewerType:ViewerTypeImage];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray *)imageArray type:(ViewerType)viewerType
{
    currentImageIndex = 0;
    TopicImage *firstImage = imageArray[0];
    self = [super initWithImage:firstImage.topicImage];
    if (self) {
        
        if (imageArray.count > 1) {
            [self setupTimer];
        }
        
        _viewerType = ViewerTypeImage;
        _imageArray = imageArray;
        
        self.userInteractionEnabled = YES;
        
        
        _temporaryArray = [NSMutableArray array];
        
        TopicImage *aImage = [[TopicImage alloc] initWithSDImage:firstImage.topicImage
                                                         HDImage:firstImage.topicHQImage
                                                      annotation:firstImage.topicAnnotation];
        [_temporaryArray addObject:aImage];
        
        
        self.image = aImage.topicImage;
        
        _imageArray = imageArray;
        _viewerType = viewerType;
        
        if (imageArray.count > 1) {
            [self setupTimer];
        }
        
        if (imageArray.count > 0) {
            [self gestureForViewerType:ViewerTypeImage];
        }
    }
    return self;
}

- (void)gestureForViewerType:(ViewerType)viewerType
{
    switch (viewerType) {
        case ViewerTypeMap:
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMapViewer)];
            [self addGestureRecognizer:tap];
        }
            break;
        case ViewerTypeImage:
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageViewer)];
            [self addGestureRecognizer:tap];
        }
            break;
        default:
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageViewer)];
            [self addGestureRecognizer:tap];
        }
            break;
    }
}

- (void)setImages:(NSArray *)imageArray type:(ViewerType)viewerType
{
    if (viewerType == ViewerTypeImage) {
        currentImageIndex = 0;
        _temporaryArray = [NSMutableArray array];
        
        TopicImage *firstImage = imageArray[0];
        UIImage *sdImage = [UIImage resizeImage:firstImage.topicImage
                                      withWidth:self.frame.size.width + 200
                                     withHeight:self.frame.size.height + 200];
        
        TopicImage *aImage = [[TopicImage alloc] initWithSDImage:sdImage
                                                         HDImage:firstImage.topicImage
                                                      annotation:firstImage.topicAnnotation];
        [_temporaryArray addObject:aImage];
        
        self.image = aImage.topicImage;
        
        _imageArray = imageArray;
        _viewerType = viewerType;
        
        if (imageArray.count > 1) {
            [self setupTimer];
        }
    } else if (viewerType == ViewerTypeMap) {
        TopicImage *firstImage = imageArray[0];
        TopicImage *aImage = [[TopicImage alloc] initWithImage:firstImage.topicImage annotation:firstImage.topicAnnotation];
        
        self.image = aImage.topicImage;
    }
}

- (void)setViewerType:(ViewerType)viewerType
{
    _viewerType = viewerType;
    [self gestureForViewerType:viewerType];
}

- (void)fadeToNextImage
{
    // Increment image index
    currentImageIndex++;
    
    // If last image in array reached, reset currentImageIndex back to 0
    if ([_imageArray count] == currentImageIndex) {
        currentImageIndex = 0;
    }
    
    TopicImage *firstImage = _imageArray[currentImageIndex];
    
    UIImage *sdImage = [UIImage resizeImage:firstImage.topicImage withWidth:self.frame.size.width + 200
                                 withHeight:self.frame.size.height + 200];
    
    TopicImage *aImage = [[TopicImage alloc] initWithSDImage:sdImage
                                                     HDImage:firstImage.topicImage
                                                  annotation:firstImage.topicAnnotation];
    [_temporaryArray addObject:aImage];
    
    [UIView transitionWithView:self duration:_fadeTime options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.image = aImage.topicImage;
    } completion:NULL];
}

- (void)setupTimer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_slideTime target:self selector:@selector(fadeToNextImage) userInfo:nil repeats:YES];
    }
}

#pragma mark - Public

- (void)showImageViewer
{
    ImageViewer *viewer = [[ImageViewer alloc] init];
    
    if (_imageArray) {
        TopicImage *newImage = _temporaryArray[currentImageIndex];
        
        if (newImage.topicAnnotation != nil) {
            viewer.annotationLabel.text = newImage.topicAnnotation;
        }
        
        if (self.image != nil) {
            [viewer show:newImage.topicHQImage];
        }
    } else {
        if (self.image != nil) {
            [viewer show:self.image];
        }
    }
}

- (void)showMapViewer
{
    MapViewer *viewer = [[MapViewer alloc] init];
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    // Initialize map view
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    
    MKCoordinateRegion theRegion;
    
    theRegion.center.latitude = HEIDE_LATITUDE;
    theRegion.center.longitude = HEIDE_LONGTITUDE;
    theRegion.span.latitudeDelta = 0.05f;
    theRegion.span.longitudeDelta = 0.05f;
    
    mapView.region = theRegion;
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(HEIDE_LATITUDE, HEIDE_LONGTITUDE);
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = @"My Hometown";
    [mapView addAnnotation:annotation];
    
    viewer.mapView = mapView;
    [viewer show];
}

@end
