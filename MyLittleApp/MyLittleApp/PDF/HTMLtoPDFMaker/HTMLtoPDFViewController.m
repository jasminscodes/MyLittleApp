//
//  HTMLtoPDFViewController.m
//  MyLittleApp
//
//  Created by Jasmin Simon on 04.12.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import "HTMLtoPDFViewController.h"


@interface HTMLtoPDFViewController ()

@end

@implementation HTMLtoPDFViewController

#pragma mark -
#pragma mark Init
- (id)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark Generate PDF
- (HTMLtoPDFMaker*)generatePdfForType:(int)type AndSaveToPath:(NSString*)path delegate:(id <HTMLtoPDFMakerDelegate>)delegate {
    
    NSString *html1 = @"<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8' /><title></title></head><body style='background-color:#444444'><font color='#FFFFFF'><h1></h1><p align='center' style='font-family:AppleSDGothicNeo-Bold; font-size:15px;'>";
    NSString *html2 = LMLocalizedString(@"HTML_TEXT_1");
    NSString *html3 = @" <br>";
    NSString *html4 = LMLocalizedString(@"HTML_TEXT_2");
    NSString *html5 = @"</p></font></body></html>";
    
    NSString *html = [NSString stringWithFormat:@"%@%@%@%@%@", html1, html2, html3, html4, html5];
    
    self.pdfMaker = [HTMLtoPDFMaker createPDFWithHTML:html pathForPDF:path delegate:delegate pageSize:kPaperSizeA4 margins:UIEdgeInsetsMake(10, 5, 10, 5)];
    
    return self.pdfMaker;
}


- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}


#pragma mark -
#pragma mark HTMLtoPDFMakerDelegate
- (void)HTMLtoPDFMakerDidSucceed:(HTMLtoPDFMaker*)htmlToPDF
{
    NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.pdfPath];
    NSLog(@"%@",result);
}

- (void)HTMLtoPDFMakerDidFail:(HTMLtoPDFMaker*)htmlToPDF
{
    NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did fail (%@)", htmlToPDF];
    NSLog(@"%@",result);
}

@end
