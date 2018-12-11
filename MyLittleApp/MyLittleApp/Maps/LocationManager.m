//
//  LocationManager.m
//  MyLittleApp
//
//  Created by Jasmin Simon on 25.11.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import "LocationManager.h"

// configure details of location
#define LOCATION_STOP_AFTER_INITIAL_LOCATION NO
#define LOCATION_MAX_AGE_TO_ACCEPT 120
#define LOCATION_HORIZONTAL_ACCURACY kCLLocationAccuracyNearestTenMeters
#define LOCATION_DISTANCE_FILTER 100.0f

@interface LocationManager()

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLAuthorizationStatus authoStatus;

@end


@implementation LocationManager

#pragma mark Lifecycle

- (void)start {

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)stop {
    [self.locationManager stopUpdatingLocation];
}

- (CLAuthorizationStatus)authorizationStatus {
    return self.authoStatus;
}


#pragma mark Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    // if the time interval returned from core location is more than two minutes we ignore it because it might be from an old session
    if (fabs([newLocation.timestamp timeIntervalSinceNow]) < LOCATION_MAX_AGE_TO_ACCEPT) {
        if (LOCATION_STOP_AFTER_INITIAL_LOCATION) {
         
            [self stop];
        }
        
        self.location = self.locationManager.location;
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LMLocationUpdatedNotification object:self];
    } else {
       
    }

    
     [[NSNotificationCenter defaultCenter] postNotificationName:LMLocationUpdatedNotification object:self];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:LMLocationUpdateFailedNotification object:self];
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    self.authoStatus = status;
    
    switch (status) {
        case kCLAuthorizationStatusDenied:
            [self stop];
            self.locationManager = nil;
            break;
        default:
            break;
    }
}

#pragma mark Init & Singleton

- (id)init {
    if ((self = [super init])) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        // Set a movement threshold for new events.
        self.locationManager.distanceFilter = LOCATION_DISTANCE_FILTER;
        self.locationManager.desiredAccuracy = LOCATION_HORIZONTAL_ACCURACY;
    }
    
    return self;
}

- (void)dealloc {
    self.location = nil;
    self.locationManager = nil;
}



@end

