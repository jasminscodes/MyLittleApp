//
//  QRScannerViewController.m
//  MyLittleApp
//
//  Created by Jasmin Simon on 01.12.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import "QRScannerViewController.h"


@interface QRScannerViewController ()

@property(nonatomic, assign) BOOL isReading;
@property(nonatomic, strong) AVCaptureSession *captureSession;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation QRScannerViewController


#pragma mark -
#pragma mark View Load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [leftButton setTitle:LMLocalizedString(@"NAV_BUTTON_LEFT_QR") forState:UIControlStateNormal];
    [rightButton setTitle:LMLocalizedString(@"NAV_BUTTON_RIGHT_QR") forState:UIControlStateNormal];
 
    _captureSession = nil;
    self.isReading = NO;
    
    self.imageView = [[UIImageView alloc]init];
    self->handleServer = [[ServerHandler alloc]initServerHandlerWithDelegate:self];
}


#pragma mark -
#pragma mark Base class methods
- (void)pushLeftButton:(id)sender {
    [super pushLeftButton:sender];
    [self removeViews];
    
    // make ready to start reading QR Code
    [self handleReading];
}

- (void)pushRightButton:(id)sender {
    [super pushRightButton:sender];
    [self removeViews];
    
    // stop reading QR Code
    self.isReading = YES;
    [self handleReading];
    
    // communicate with server to get QR Code text from server
    [self->handleServer serverCommunicationWithPath:SERVER_ADDRESS_3 andReceivedType:SCANTEXT];
}

- (void)removeViews {
    [super removeViews];
    [self.imageView removeFromSuperview];
}

#pragma mark -
#pragma mark Private methods
- (void)handleReading {
    if (!self.isReading) {
        if ([self startReading]) {
            infoLabel.text = LMLocalizedString(@"INFO_LABEL_TITLE_QR_READY");
        }
    } else{
        [self stopReading];
    }
    
    self.isReading = !self.isReading;
}


#pragma mark -
#pragma mark QR Scan methods
- (BOOL)startReading {
    
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // if device have no access to camera show localized error
        infoLabel.text = [error localizedDescription];
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [_videoPreviewLayer setFrame:centerView.layer.bounds];
    [centerView.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

- (void)stopReading {
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}


#pragma mark -
#pragma mark AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            NSString *string = [metadataObj stringValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self->infoLabel.text = string;
                
                // if text for QR Code is a http string show an alert to inform user
                if ([string containsString:@"http"]) {
                    
                    NSURL *url  = [[NSURL alloc] initWithString:string];
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LMLocalizedString(@"ALERT_INFO_TITLE") message:LMLocalizedString(@"ALERT_INFO_MESSAGE") preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LMLocalizedString(@"BUTTON_OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        
                        [[UIApplication sharedApplication] openURL:url options:@{}
                                                 completionHandler:^(BOOL success) {
                                                     self->infoLabel.text = @"";
                                                 }];
                    }];
                    
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:LMLocalizedString(@"BUTTON_CANCEL") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        self->infoLabel.text = @"";
                    }];
                    
                    [alert addAction:cancel];
                    [alert addAction:okAction];
                    
                    if (!self.presentedViewController) {
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                } else {
                    //you can show your custom alert like - there is no HTTP link present in the QR Code. //
                }
                
                [self stopReading];
                self->_isReading = NO;
                
            });
        }
    }
}


#pragma mark -
#pragma mark server communication methods
- (void)informMainThreadWithData:(NSData *)data andReceivedType:(NSString*)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        // parse data to dictionary
        NSDictionary *jsonDictionary =  [self parseJSONToStringWithData:data andKey:type];
        NSString *string = [jsonDictionary valueForKey:SCANTEXT];
        [self generateQRCodeWithString:string];
    });
}

// generate QR Code
- (void)generateQRCodeWithString:(NSString*)string {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    UIImage *resized = [self qRresizeImage:image withQuality:kCGInterpolationNone rate:7.0];
    
    [self.imageView setImage:resized];
    self.imageView.frame = CGRectMake((centerView.frame.size.width - resized.size.width) / 2, (centerView.frame.size.height - resized.size.height) / 2, resized.size.width, resized.size.height);
    
    [centerView addSubview:self.imageView];
    
    CGImageRelease(cgImage);
}


- (UIImage *)qRresizeImage:(UIImage *)image withQuality:(CGInterpolationQuality)quality rate:(CGFloat)rate {
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}


#pragma mark -
#pragma mark View Unload
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeViews];
    [self stopReading];
}


@end
