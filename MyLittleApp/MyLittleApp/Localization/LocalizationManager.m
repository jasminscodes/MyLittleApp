//
//  LocalizationManager.m
//  MyLittleApp
//
//  Created by Jasmin Simon on 03.12.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import "LocalizationManager.h"

@implementation LocalizationManager

//Singleton instance
static LocalizationManager *_sharedLocalSystem = nil;

//Current application bungle to get the languages.
static NSBundle *bundle = nil;


#pragma mark -
#pragma mark Init
+ (LocalizationManager *)sharedLocalSystem
{
    @synchronized([LocalizationManager class])
    {
        if (!_sharedLocalSystem){
            _sharedLocalSystem = [[self alloc] init];
        }
        return _sharedLocalSystem;
    }
    // to avoid compiler warning
    return nil;
}


- (id)init
{
    if ((self = [super init]))
    {
        //empty.
        bundle = [NSBundle mainBundle];
    }
    return self;
}


// Gets the current localized string as in NSLocalizedString.
- (NSString *)localizedStringForKey:(NSString *)key {
    return [bundle localizedStringForKey:key value:nil table:nil];
}


@end
