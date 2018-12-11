//
//  Protocols.h
//  MyLittleApp
//
//  Created by Jasmin Simon on 02.12.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#ifndef Protocols_h
#define Protocols_h


@protocol ServerHandleDelegate <NSObject>

- (void)informMainThreadWithData:(NSData *)data andReceivedType:(NSString*)type;
- (void)handleServerError:(NSString *)error;

@end


#endif 
