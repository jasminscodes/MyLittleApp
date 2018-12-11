//
//  HTMLtoPDFViewController.h
//  MyLittleApp
//
//  Created by Jasmin Simon on 04.12.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTMLtoPDFMaker.h"

typedef enum {
    PREVIEW,
    EMAIL_ATTACH,
    EMAIL_CONT,
} PDFTYPE;

@interface HTMLtoPDFViewController : UIViewController <HTMLtoPDFMakerDelegate>

@property (nonatomic, strong) HTMLtoPDFMaker *pdfMaker;

- (HTMLtoPDFMaker*)generatePdfForType:(int)type AndSaveToPath:(NSString*)path delegate:(id <HTMLtoPDFMakerDelegate>)delegate;

@end
