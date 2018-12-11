//
//  HTMLtoPDFMaker.h
//  MyLittleApp
//
//  Created by Jasmin Simon on 04.12.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPaperSizeA4 CGSizeMake(595.2,841.8)

@class HTMLtoPDFMaker;

typedef void (^HTMLtoPDFMakerCompletionBlock)(HTMLtoPDFMaker* htmlToPDF);

@protocol HTMLtoPDFMakerDelegate <NSObject>

@optional
- (void)HTMLtoPDFMakerDidSucceed:(HTMLtoPDFMaker*)htmlToPDF;
- (void)HTMLtoPDFMakerDidFail:(HTMLtoPDFMaker*)htmlToPDF;
@end

@interface HTMLtoPDFMaker : UIViewController <UIWebViewDelegate>

@property (nonatomic, copy) HTMLtoPDFMakerCompletionBlock successBlock;
@property (nonatomic, copy) HTMLtoPDFMakerCompletionBlock errorBlock;

@property (nonatomic, strong) id <HTMLtoPDFMakerDelegate> delegate;

@property (nonatomic, strong) NSString *pdfPath;
@property (nonatomic, strong, readonly) NSData *pdfData;
@property (nonatomic, strong) NSString *HTML;


+ (id)createPDFWithHTML:(NSString*)HTML pathForPDF:(NSString*)PDFpath delegate:(id <HTMLtoPDFMakerDelegate>)delegate pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins;

+ (id)createPDFWithHTML:(NSString*)HTML pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins successBlock:(HTMLtoPDFMakerCompletionBlock)successBlock errorBlock:(HTMLtoPDFMakerCompletionBlock)errorBlock;

@end
