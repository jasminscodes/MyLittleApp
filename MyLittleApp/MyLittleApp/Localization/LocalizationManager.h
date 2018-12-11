//
//  LocalizationManager.h
//  MyLittleApp
//
//  Created by Jasmin Simon on 03.12.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LMLocalizedString(key) \
[[LocalizationManager sharedLocalSystem] localizedStringForKey:(key)]



@interface LocalizationManager : NSObject

+ (LocalizationManager *)sharedLocalSystem;

//gets the string localized
- (NSString *)localizedStringForKey:(NSString *)key;

@end

