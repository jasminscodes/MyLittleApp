//
//  LocationManager.h
//  MyLittleApp
//
//  Created by Jasmin Simon on 25.11.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#define LMLocationUpdatedNotification @"LMLocationUpdatedNotification"
#define LMLocationUpdateFailedNotification @"LMLocationUpdateFailedNotification"

@interface LocationManager : NSObject <CLLocationManagerDelegate>

- (CLLocation *)location;
- (void)start;
- (void)stop;
- (CLAuthorizationStatus)authorizationStatus;



@end


