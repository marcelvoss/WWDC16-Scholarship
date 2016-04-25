//
//  InteractiveImageView.m
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "InteractiveImageView.h"

#import "Constants.h"

#import <MapKit/MapKit.h>

#import "Marcel_Voss-Swift.h"

@implementation InteractiveImageView
{
    NSInteger currentImageIndex;
    NSTimer *timer;
}

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleToFill;
        
        _slideTime = 5;
        _fadeTime = 1;
        
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
    }
    return self;
}

- (instancetype)initWithImages:(NSArray *)imageArray type:(ViewerType)viewerType
{
    TopicImage *firstImage = imageArray[0];
    self = [super initWithImage:firstImage.topicImage];
    if (self) {
        
        if (imageArray.count > 1) {
            [self setupTimer];
        }
        
        _viewerType = ViewerTypeImage;
        _imageArray = imageArray;
        
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleToFill;
        
        [self gestureForViewerType:ViewerTypeImage];
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
    TopicImage *firstImage = imageArray[0];
    self.image = firstImage.topicImage;

    
    _imageArray = imageArray;
    _viewerType = viewerType;
    
    if (imageArray.count > 1) {
        [self setupTimer];
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
    
    [UIView transitionWithView:self duration:_fadeTime options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        TopicImage *singleTopic = _imageArray[currentImageIndex];
        self.image = singleTopic.topicImage;
    } completion:NULL];
}

- (void)setupTimer
{
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:_slideTime target:self selector:@selector(fadeToNextImage) userInfo:nil repeats:YES];
    }
}

#pragma mark - Public

- (void)showImageViewer
{
    ImageViewer *viewer = [[ImageViewer alloc] init];
    
    // TODO: Add annotations
    TopicImage *image = _imageArray[currentImageIndex];
    if (image.topicAnnotation != nil) {
        viewer.annotationLabel.text = image.topicAnnotation;
    }
    
    if (self.image != nil) {
        [viewer show:self.image];
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
