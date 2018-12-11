//
//  PDFViewController.h
//  MyLittleApp
//
//  Created by Jasmin Simon on 04.12.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <QuickLook/QuickLook.h>
#import "HTMLtoPDFMaker.h"

@interface PDFViewController : BaseViewController <QLPreviewControllerDelegate, QLPreviewControllerDataSource, HTMLtoPDFMakerDelegate>

@end


