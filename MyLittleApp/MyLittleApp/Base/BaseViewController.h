//
//  BaseViewController.h
//  MyLittleApp
//
//  Created by Jasmin Simon on 26.11.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"
#import "ServerHandler.h"
#import "Defines.h"


@interface BaseViewController : UIViewController <ServerHandleDelegate>{

    @protected
    UIButton *leftButton;
    UIButton *rightButton;
    UIView *centerView;
    UILabel *infoLabel;
    ServerHandler *handleServer;
}

@end


@interface BaseViewController (Protected)
    
- (void)pushLeftButton:(id)sender;
- (void)pushRightButton:(id)sender;
- (void)removeViews;
- (NSDictionary*)parseJSONToStringWithData:(NSData*)data andKey:(NSString*)key;

@end


