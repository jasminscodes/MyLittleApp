//
//  AppDelegate.h
//  MyLittleApp
//
//  Created by Jasmin Simon on 24.11.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

