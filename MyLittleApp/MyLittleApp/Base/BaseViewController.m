//
//  BaseViewController.m
//  MyLittleApp
//
//  Created by Jasmin Simon on 26.11.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark -
#pragma mark View Load
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.navigationItem.title = LMLocalizedString(@"NAV_TITLE");

    CGRect topViewFrame = self.view.frame;
    topViewFrame.size.height = 100;
    UIView *topView = [[UIView alloc]initWithFrame:topViewFrame];
    topView.backgroundColor = [UIColor whiteColor];
    
    // left button at the top of the view
    CGRect leftButtonFrame = topViewFrame;
    leftButtonFrame.origin.y = 0;
    leftButtonFrame.size.width = topViewFrame.size.width / 2;
    leftButton = [[UIButton alloc]initWithFrame:leftButtonFrame];
    [leftButton addTarget:self action:@selector(pushLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag = 1;
    leftButton.titleLabel.numberOfLines = 2;
    leftButton.tintColor = [UIColor whiteColor];
    leftButton.backgroundColor = [UIColor grayColor];
    [topView addSubview:leftButton];
    
    // right button at the top of the view
    CGRect rightButtonFrame = leftButtonFrame;
    rightButtonFrame.origin.x = leftButtonFrame.size.width;
    rightButton = [[UIButton alloc]initWithFrame: rightButtonFrame];
    [rightButton addTarget:self action:@selector(pushRightButton:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag = 2;
    rightButton.titleLabel.numberOfLines = 2;
    rightButton.tintColor = [UIColor whiteColor];
    rightButton.backgroundColor = [UIColor redColor];
    [topView addSubview:rightButton];
    
    [self.view addSubview:topView];
    
    // view at the center of the view
    CGRect centerViewFrame = self.view.frame;
    centerViewFrame.origin.y = topView.frame.origin.y + topView.frame.size.height;
    centerViewFrame.size.height = 300;
    centerView = [[UIView alloc]initWithFrame:centerViewFrame];
    centerView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:centerView];

    CGRect bottomViewFrame = self.view.frame;
    bottomViewFrame.origin.y = centerView.frame.origin.y + centerView.frame.size.height;
    bottomViewFrame.size.height = self.view.frame.size.height - bottomViewFrame.origin.y;
    UIView *bottomView = [[UIView alloc]initWithFrame:bottomViewFrame];
    bottomView.backgroundColor = [UIColor grayColor];
    
    // info label at the bottom of the view
    CGRect infoViewFrame = bottomView.frame;
    infoViewFrame.origin.y = 0;
    infoViewFrame.size.height = 110;
    infoLabel = [[UILabel alloc]initWithFrame:infoViewFrame];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.backgroundColor = [UIColor redColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.numberOfLines = 2;
    [bottomView addSubview:infoLabel];
    
    [self.view addSubview:bottomView];
}


#pragma mark -
#pragma mark Base class methods
- (void)pushLeftButton:(id)sender {}

- (void)pushRightButton:(id)sender {}

- (void)removeViews {
    infoLabel.text = @"";
}

// encoding the received NSData to NSDictionary
- (NSDictionary*)parseJSONToStringWithData:(NSData*)data andKey:(NSString*)key {
    
    NSError *error;
    NSDictionary *jsonDictionary = [[NSDictionary alloc]init];
    jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    return jsonDictionary;
}


#pragma mark -
#pragma mark ServerHandleDelegate
- (void)informMainThreadWithData:(NSData *)data andReceivedType:(NSString*)type {}

- (void)handleServerError:(NSString *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self->infoLabel.text = error;
    });
}


#pragma mark -
#pragma mark View Unload
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeViews];
}

@end
