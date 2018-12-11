//
//  HTMLtoPDFPreviewController.m
//  MyLittleApp
//
//  Created by Jasmin Simon on 04.12.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import "HTMLtoPDFPreviewController.h"

@implementation HTMLtoPDFPreviewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tag = 1;
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)setNeedsStatusBarAppearanceUpdate{
    [self prefersStatusBarHidden];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
