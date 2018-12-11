//
//  ServerHandler.m
//  MyLittleApp
//
//  Created by Jasmin Simon on 01.12.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import "ServerHandler.h"
#import "Protocols.h"

@interface ServerHandler ()
@property(nonatomic, strong) NSString *receivedType;
@end


@implementation ServerHandler

#pragma mark -
#pragma mark Init
- (id)initServerHandlerWithDelegate:(id<ServerHandleDelegate>)delegate {
    
    self = [super init];
    if(self){
        self->serverHandleDelegate = delegate;
    }
    return self;
}


#pragma mark -
#pragma mark server communication methods
- (void)serverCommunicationWithPath:(NSString*)filePath andReceivedType:(NSString*)type {

    self.receivedType = type;
    NSURL *url = [NSURL URLWithString:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    NSURLSessionDataTask* uRLSessionDataTask = [[NSURLSession sharedSession]
                                                dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                                    
                                                    if( data != nil && error == nil )
                                                        [self didReceiveData:data :response];
                                                    else
                                                        [self didFailWithError:error];
                                                }];
    [uRLSessionDataTask resume];
}


-(void)didReceiveData:(NSData*)data :(NSURLResponse*)response{
    // if status code is ok 
    if (![self handleStatusCode:response]) {
        if( [serverHandleDelegate respondsToSelector:@selector(informMainThreadWithData:andReceivedType:)] )
            [serverHandleDelegate informMainThreadWithData:data andReceivedType:self.receivedType];
    }
}


- (BOOL)handleStatusCode:(NSURLResponse*)response {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSUInteger code = httpResponse.statusCode;
    NSString *localizedError = nil;
    BOOL hasError = NO;
    
    switch (code) {
        case 400:
        case 401:
        case 403:
        case 404:
        case 500:
        case 502:
        case 503:
            localizedError =  [NSString stringWithFormat:@"%@: %lu - %@", LMLocalizedString(@"INFO_LABEL_TITLE_SERVER_HTTP_STATUS"), (unsigned long)code, [NSHTTPURLResponse localizedStringForStatusCode:code]];
            break;
        default:
            break;
    }
    
    if (localizedError) {
        hasError = YES;
        if( [serverHandleDelegate respondsToSelector:@selector(handleServerError:)] )
            [serverHandleDelegate handleServerError:localizedError];
    }
    return hasError;
}


-(void)didFailWithError:(NSError *)error{
    NSString *localizedError = error.localizedDescription;
    if( [serverHandleDelegate respondsToSelector:@selector(handleServerError:)] )
        [serverHandleDelegate handleServerError:localizedError];
}


@end
