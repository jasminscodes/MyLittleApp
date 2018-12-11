//
//  PDFViewController.m
//  MyLittleApp
//
//  Created by Jasmin Simon on 04.12.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import "PDFViewController.h"
#import "HTMLtoPDFMaker.h"
#import "HTMLtoPDFViewController.h"
#import "HTMLtoPDFPreviewController.h"


@interface PDFViewController ()
@property(nonatomic, strong) NSString *pathForPreviewPdf;
@property (nonatomic, strong) HTMLtoPDFMaker *htmlToPDFMaker;
@end

@implementation PDFViewController

#pragma mark -
#pragma mark View Load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [leftButton setTitle:LMLocalizedString(@"NAV_BUTTON_LEFT_PDF") forState:UIControlStateNormal];
    [rightButton setTitle:LMLocalizedString(@"NAV_BUTTON_RIGHT_PDF") forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark Base class methods
- (void)pushLeftButton:(id)sender {
    [super pushLeftButton:sender];
    [self removePath];
    [self loadPDF];
}

- (void)pushRightButton:(id)sender {
    [super pushRightButton:sender];
    [self removePath];
    [self generatePDF];
}


#pragma mark -
#pragma mark Private methods
- (void)removePath {
    self.pathForPreviewPdf = nil;
    self.htmlToPDFMaker.pdfPath = nil;
}

// generate PDF from html code
- (void)generatePDF {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *saveDirectory = [paths objectAtIndex:0];
    NSString *fileNamePdf = @"MyNewPDF.pdf";
    NSString *filePath = [saveDirectory stringByAppendingPathComponent:fileNamePdf];
    
    HTMLtoPDFViewController *htmlToPDFViewController = [[HTMLtoPDFViewController alloc]init];
  
    if ([fileManager fileExistsAtPath:filePath]) {
        if (![fileManager removeItemAtPath:filePath error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        } else {
            self.htmlToPDFMaker =  [htmlToPDFViewController generatePdfForType:PREVIEW AndSaveToPath:filePath delegate:self];
        }
    } else {
        self.htmlToPDFMaker =  [htmlToPDFViewController generatePdfForType:PREVIEW AndSaveToPath:filePath delegate:self];
    }
}


// load PDF from main bundle
- (void)loadPDF {
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"#WWDC18.pdf"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exists = [fileManager fileExistsAtPath:path];

    if (exists) {
         self.pathForPreviewPdf = path;
        [self showPdfInPreview:path];
    } else {
        [self showError];
    }
}


// show PDF as push
-(void) showPdfInPreview:(NSString*)onPath{
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    previewController.view.tag = 2;
    [self.navigationController pushViewController:previewController animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)showError {
    self->infoLabel.text = LMLocalizedString(@"ERROR_PDF_LOAD");
}


#pragma mark -
#pragma mark QLPreviewControllerDelegate
-(NSInteger) numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController {
    
    if( self.pathForPreviewPdf || self.htmlToPDFMaker.pdfPath) {
        return 1;
    } else
        return 0;
}


- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    
    NSURL *fileURL = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSUInteger pathIndex = controller.view.tag;
    
    switch (pathIndex) {
        case 1: {
            BOOL exists = [fileManager fileExistsAtPath:self.htmlToPDFMaker.pdfPath];
            if (exists) {
                fileURL = [NSURL fileURLWithPath:self.htmlToPDFMaker.pdfPath];
            }
        }
            break;
        case 2: {
            BOOL exists = [fileManager fileExistsAtPath:self.pathForPreviewPdf];
            if (exists) {
                fileURL = [NSURL fileURLWithPath:self.pathForPreviewPdf];
            }
        }
            break;
        default:
            break;
    }
    return fileURL;
}


#pragma mark -
#pragma mark HTMLtoPDFMakerDelegate
// show PDF as push
- (void)HTMLtoPDFMakerDidSucceed:(HTMLtoPDFMaker*)htmlToPDF {
    HTMLtoPDFPreviewController *previewController = [[HTMLtoPDFPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    previewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:previewController animated:YES];
}

- (void)HTMLtoPDFMakerDidFail:(HTMLtoPDFMaker*)htmlToPDF {
    self->infoLabel.text = LMLocalizedString(@"ERROR_PDF_GENERATE");
}


@end
