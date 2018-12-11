//
//  MainCollectionViewController.h
//  MyLittleApp
//
//  Created by Jasmin Simon on 24.11.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLittleAppCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainCollectionViewController : UICollectionViewController

@property IBOutlet UIView *baseCellView;
@property IBOutlet UICollectionViewCell *myLittleAppCollectionViewCell;

@end

NS_ASSUME_NONNULL_END
