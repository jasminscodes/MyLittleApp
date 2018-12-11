//
//  ServerViewController.m
//  MyLittleApp
//
//  Created by Jasmin Simon on 26.11.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import "ServerViewController.h"

@interface ServerViewController ()
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *labelName0;
@property(nonatomic, strong) UILabel *labelName1;
@property(nonatomic, strong) UILabel *labelAddress01;
@property(nonatomic, strong) UILabel *labelAddress02;
@property(nonatomic, strong) UILabel *labelAddress11;
@property(nonatomic, strong) UILabel *labelAddress12;
@end

@implementation ServerViewController

#pragma mark -
#pragma mark View Load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [leftButton setTitle:LMLocalizedString(@"NAV_BUTTON_LEFT_SERVER") forState:UIControlStateNormal];
    [rightButton setTitle:LMLocalizedString(@"NAV_BUTTON_RIGHT_SERVER") forState:UIControlStateNormal];
    self.imageView = [[UIImageView alloc]init];
    
    self->handleServer = [[ServerHandler alloc]initServerHandlerWithDelegate:self];
}


#pragma mark -
#pragma mark Base class methods
- (void)pushLeftButton:(id)sender {
    [super pushLeftButton:sender];
    [self removeViews];
    [self removeLabels];

    // communicate with server to get an image from server
    [self->handleServer serverCommunicationWithPath:SERVER_ADDRESS_1 andReceivedType:IMAGE];
}

- (void)pushRightButton:(id)sender {
    [super pushRightButton:sender];
    [self removeViews];
    [self addLabels];

    // communicate with server to get text from server
    [self->handleServer serverCommunicationWithPath:SERVER_ADDRESS_2 andReceivedType:DATA];
}

- (void)removeViews {
    [super removeViews];
    [self.imageView removeFromSuperview];
}


#pragma mark -
#pragma mark Private methods
// add labels to to show text from server
- (void)addLabels {
    self.labelName0 = [[UILabel alloc]init];
    self.labelName0.textColor = [UIColor whiteColor];
    CGRect frame = centerView.frame;
    frame.origin.x = 20;
    frame.origin.y = 40;
    frame.size.width = centerView.frame.size.width / 2;
    frame.size.height = 30;
    self.labelName0.frame = frame;
    [centerView addSubview:self.labelName0];
    
    self.labelName1 = [[UILabel alloc]init];
    self.labelName1.textColor = [UIColor whiteColor];
    frame = centerView.frame;
    frame.origin.x = 20;
    frame.origin.y = 160;
    frame.size.width = centerView.frame.size.width / 2;
    frame.size.height = 30;
    self.labelName1.frame = frame;
    [centerView addSubview:self.labelName1];
    
    self.labelAddress01 = [[UILabel alloc]init];
    self.labelAddress01.textColor = [UIColor whiteColor];
    frame = centerView.frame;
    frame.origin.x = centerView.frame.size.width / 2;
    frame.origin.y = 40;
    frame.size.height = 30;
    self.labelAddress01.frame = frame;
    [centerView addSubview:self.labelAddress01];
    
    self.labelAddress02 = [[UILabel alloc]init];
    self.labelAddress02.textColor = [UIColor whiteColor];
    frame = centerView.frame;
    frame.origin.x = centerView.frame.size.width / 2;
    frame.origin.y = 80;
    frame.size.height = 30;
    self.labelAddress02.frame = frame;
    [centerView addSubview:self.labelAddress02];
    
    self.labelAddress11 = [[UILabel alloc]init];
    self.labelAddress11.textColor = [UIColor whiteColor];
    frame = centerView.frame;
    frame.origin.x = centerView.frame.size.width / 2;
    frame.origin.y = 160;
    frame.size.height = 30;
    self.labelAddress11.frame = frame;
    [centerView addSubview:self.labelAddress11];
    
    self.labelAddress12 = [[UILabel alloc]init];
    self.labelAddress12.textColor = [UIColor whiteColor];
    frame = centerView.frame;
    frame.origin.x = centerView.frame.size.width / 2;
    frame.origin.y = 200;
    frame.size.height = 30;
    self.labelAddress12.frame = frame;
    [centerView addSubview:self.labelAddress12];
}

- (void)removeLabels {
    [self.labelName0 removeFromSuperview];
    [self.labelName1 removeFromSuperview];
    [self.labelAddress01 removeFromSuperview];
    [self.labelAddress02 removeFromSuperview];
    [self.labelAddress11 removeFromSuperview];
    [self.labelAddress12 removeFromSuperview];
}


#pragma mark -
#pragma mark server communication methods
- (void)informMainThreadWithData:(NSData *)data andReceivedType:(NSString*)type {

    dispatch_async(dispatch_get_main_queue(), ^{
        
        // if received type from server an image show image
        if ([type isEqualToString:IMAGE]) {
        
            UIImage *downloadedImage = [UIImage imageWithData:data];
            [self.imageView setImage:downloadedImage];
            self.imageView.frame = CGRectMake(0, 20, downloadedImage.size.width, downloadedImage.size.height);
            [self.imageView sizeToFit];
            [self->centerView addSubview:self.imageView];
        }
        
        // if received type from server text show label with text
        if ([type isEqualToString:DATA]) {
            NSDictionary *jsonDictionary =  [self parseJSONToStringWithData:data andKey:type];
            NSDictionary *name = [jsonDictionary valueForKey:@"Name"];
            
            for (int i = 0; i <= name.allKeys.count; i++) {
                    
                NSDictionary *d = [name valueForKey:[NSString stringWithFormat:@"%i", i]];
                NSString *firstname = [d valueForKey:@"vorname"];
                NSString *lastname = [d valueForKey:@"name"];
                NSString *nameString = [NSString stringWithFormat:@"%@ %@", firstname, lastname];

                switch (i) {
                    case 0:
                        self.labelName0.text = nameString;
                        break;
                    case 1:
                        self.labelName1.text = nameString;
                        break;
                    default:
                        break;
                }
            }
            
            NSDictionary *address = [jsonDictionary valueForKey:@"Adresse"];
            
            for (int i = 0; i <= address.allKeys.count; i++) {
                
                NSDictionary *d = [address valueForKey:[NSString stringWithFormat:@"%i", i]];
                NSString *street = [d valueForKey:@"Strasse"];
                NSString *place = [d valueForKey:@"Ort"];
                switch (i) {
                    case 0:
                        self.labelAddress01.text = street;
                        self.labelAddress02.text = place;
                        break;
                    case 1:
                        self.labelAddress11.text = street;
                        self.labelAddress12.text = place;
                        break;
                    default:
                        break;
                }
            }
        }
    });
}


#pragma mark -
#pragma mark View Unload
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeViews];
}


@end
