//
//  HTMLtoPDFMaker.m
//  MyLittleApp
//
//  Created by Jasmin Simon on 04.12.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import "HTMLtoPDFMaker.h"

@interface HTMLtoPDFMaker ()
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *PDFpath;
@property (nonatomic, strong) NSData *PDFdata;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) UIEdgeInsets pageMargins;
@end

@interface UIPrintPageRenderer (PDF)

- (NSData*) printToPDF;

@end

@implementation HTMLtoPDFMaker


- (id)init {
    if (self = [super init]) {
        self.PDFdata = nil;
    }
    return self;
}

- (id)initWithHTML:(NSString*)HTML baseURL:(NSURL*)baseURL delegate:(id <HTMLtoPDFMakerDelegate>)delegate
        pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins
{
    if (self = [super init]) {
        self.HTML = HTML;
        self.URL = baseURL;
        self.delegate = delegate;
        self.PDFpath = PDFpath;
        
        self.pageMargins = pageMargins;
        self.pageSize = pageSize;
        
        [self loadedView];
    }
    return self;
}


// Create PDF by passing in the HTML as a String
+ (id)createPDFWithHTML:(NSString*)HTML pathForPDF:(NSString*)PDFpath delegate:(id <HTMLtoPDFMakerDelegate>)delegate pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins {
    
    HTMLtoPDFMaker *creator = [[HTMLtoPDFMaker alloc] initWithHTML:HTML baseURL:nil delegate:delegate pathForPDF:PDFpath pageSize:pageSize margins:pageMargins];
    creator.pdfPath = PDFpath;
    return creator;
}


+ (id)createPDFWithHTML:(NSString*)HTML pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins successBlock:(HTMLtoPDFMakerCompletionBlock)successBlock errorBlock:(HTMLtoPDFMakerCompletionBlock)errorBlock
{
    HTMLtoPDFMaker *creator = [[HTMLtoPDFMaker alloc] initWithHTML:HTML baseURL:nil delegate:nil pathForPDF:PDFpath pageSize:pageSize margins:pageMargins];
    creator.successBlock = successBlock;
    creator.errorBlock = errorBlock;
    
    return creator;
}


- (void)loadedView
{
    [[UIApplication sharedApplication].delegate.window addSubview:self.view];
    
    self.view.frame = CGRectMake(0, 0, 1, 1);
    self.view.alpha = 0.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webview = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webview.delegate = self;
    
    [self.view addSubview:self.webview];
    
    if (self.HTML == nil) {
        [self.webview loadRequest:[NSURLRequest requestWithURL:self.URL]];
    }else{
        [self.webview loadHTMLString:self.HTML baseURL:self.URL];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.isLoading) return;
    
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    
    [render addPrintFormatter:webView.viewPrintFormatter startingAtPageAtIndex:0];
    
    CGRect printableRect = CGRectMake(self.pageMargins.left,
                                      self.pageMargins.top,
                                      self.pageSize.width - self.pageMargins.left - self.pageMargins.right,
                                      self.pageSize.height - self.pageMargins.top - self.pageMargins.bottom);
    
    CGRect paperRect = CGRectMake(0, 0, self.pageSize.width, self.pageSize.height);
    
    [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    
    self.PDFdata = [render printToPDF];
    
    if (self.PDFpath) {
        [self.PDFdata writeToFile: self.PDFpath  atomically: YES];
    }
    
    [self terminateWebTask];

    if (self.delegate && [self.delegate respondsToSelector:@selector(HTMLtoPDFMakerDidSucceed:)]) {
        [self.delegate HTMLtoPDFMakerDidSucceed:self];
    }
  
    /*
    //test for failing
     if (self.delegate && [self.delegate respondsToSelector:@selector(HTMLtoPDFMakerDidFail:)])
     [self.delegate HTMLtoPDFMakerDidFail:self];
    */
    
    
    if(self.successBlock) {
        self.successBlock(self);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if (webView.isLoading) return;
    
    [self terminateWebTask];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTMLtoPDFMakerDidFail:)])
        [self.delegate HTMLtoPDFMakerDidFail:self];
    
    if(self.errorBlock) {
        self.errorBlock(self);
    }
}

- (void)terminateWebTask {
    [self.webview stopLoading];
    self.webview.delegate = nil;
    [self.webview removeFromSuperview];
    
    [self.view removeFromSuperview];
    
    self.webview = nil;
}

@end

@implementation UIPrintPageRenderer (PDF)

- (NSData*) printToPDF
{
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData( pdfData, self.paperRect, nil );
    
    [self prepareForDrawingPages: NSMakeRange(0, self.numberOfPages)];
    
    CGRect bounds = UIGraphicsGetPDFContextBounds();

    for ( int i = 0 ; i < self.numberOfPages ; i++ )
    {
        UIGraphicsBeginPDFPage();
        
        [self drawPageAtIndex: i inRect: bounds];
    }
    
    UIGraphicsEndPDFContext();
    
    return pdfData;
}

@end
