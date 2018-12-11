//
//  MapsViewController.m
//  MyLittleApp
//
//  Created by Jasmin Simon on 25.11.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import "MapsViewController.h"
#import "LocationManager.h"

@interface MapsViewController ()
@property(nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) LocationManager* locationManagerHandle;
@property (nonatomic, strong) CLGeocoder* geoCoder;

@end

@implementation MapsViewController

#pragma mark -
#pragma mark View Load
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView = [[MKMapView alloc]init];

    self.locationManagerHandle = [[LocationManager alloc] init];
    
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    
    //add long press gesture to allow selecting a location on map
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    
    //init the geocoder to get address from coords
    self.geoCoder = [[CLGeocoder alloc] init];
    
    [self.locationManagerHandle start];
    
    [self.mapView setFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    [self.mapView setShowsUserLocation:YES];
    [self.view addSubview:self.mapView];
}

-(void) viewDidAppear:(BOOL)animated{
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView setShowsUserLocation:YES];
    [self jumpToMyLocation:nil];
    [self.locationManagerHandle start];
        
    //add observers for current user location updates
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(newLocationReceived:)
                                               name:LMLocationUpdatedNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(newLocationFailed:)
                                               name:LMLocationUpdateFailedNotification
                                             object:nil];
}


- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    MKPlacemark *droppedAnnotaion = [[MKPlacemark alloc] initWithCoordinate:touchMapCoordinate addressDictionary:nil];
    [self.mapView addAnnotation:droppedAnnotaion];
    
    self.mapView.showsUserLocation = YES;
}


#pragma mark Location
-(void)jumpToMyLocation:(id)sender{
    
    CLLocationCoordinate2D coords = self.locationManagerHandle.location.coordinate;
    [self.mapView setCenterCoordinate:coords animated:YES];
    
    //now zoom the map here
    MKCoordinateRegion mapRegion;
    mapRegion.center = coords;
    
    mapRegion.span.latitudeDelta = 0.02;
    mapRegion.span.longitudeDelta = 0.02;
    [self.mapView setRegion:mapRegion animated: YES];
    
    self.mapView.showsUserLocation = YES;
}

-(void) newLocationReceived:(id)sender{

}

-(void) newLocationFailed:(id)sender{
    
}


-(void) viewDidDisappear:(BOOL)animated{
    [self.locationManagerHandle stop];
    
    //remove observers for current user location updates
    [NSNotificationCenter.defaultCenter removeObserver:self];
}


@end
