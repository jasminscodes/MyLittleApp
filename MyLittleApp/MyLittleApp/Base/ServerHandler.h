//
//  ServerHandler.h
//  MyLittleApp
//
//  Created by Jasmin Simon on 01.12.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Protocols.h"


typedef enum : NSUInteger {
    BUTTON_NUMBER_SERVER_LEFT,
    BUTTON_NUMBER_SERVER_RIGHT,
    BUTTON_NUMBER_QRSCAN_LEFT,
    BUTTON_NUMBER_QRSCAN_RIGHT
} BUTTON_NUMBER;


@interface ServerHandler : NSObject  {
    @protected
    __weak id<ServerHandleDelegate> serverHandleDelegate;
}
@end


@interface ServerHandler (Protected) <ServerHandleDelegate>
- (id)initServerHandlerWithDelegate:(id<ServerHandleDelegate>)delegate;
- (void)serverCommunicationWithPath:(NSString*)filePath andReceivedType:(NSString*)type;
@end
