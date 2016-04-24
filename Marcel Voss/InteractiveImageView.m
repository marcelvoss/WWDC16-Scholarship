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

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleToFill;
        
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

- (instancetype)initWithImage:(UIImage *)image annotation:(NSString *)annotation type:(ViewerType)viewerType
{
    self = [super initWithImage:image];
    if (self) {
        _annotationString = annotation;
        _viewerType = viewerType;
        
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleToFill;
        
        [self gestureForViewerType:viewerType];
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

- (void)setViewerType:(ViewerType)viewerType
{
    _viewerType = viewerType;
    [self gestureForViewerType:viewerType];
}

#pragma mark - Public

- (void)setImage:(UIImage *)image annotation:(NSString *)annotation type:(ViewerType)viewerType
{
    self.image = image;
    _annotationString = annotation;
    _viewerType = viewerType;
}

- (void)showImageViewer
{
    ImageViewer *viewer = [[ImageViewer alloc] init];
    
    if (_annotationString != nil) {
        viewer.annotationLabel.text = self.annotationString;
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
