//
//  MainCollectionViewController.m
//  MyLittleApp
//
//  Created by Jasmin Simon on 24.11.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "MapsViewController.h"
#import "GallaryViewController.h"
#import "ServerViewController.h"
#import "QRScannerViewController.h"
#import "PDFViewController.h"


@interface MainCollectionViewController ()

@end

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"cell";

#pragma mark -
#pragma mark View Load
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = LMLocalizedString(@"NAV_TITLE");
    
    // register custom collection view cell
    [self.collectionView registerClass:[MyLittleAppCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}


#pragma mark -
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return CELL_SECTIONS;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return CELL_ROWS;
}

- (MyLittleAppCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyLittleAppCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                cell.backgroundColor = [UIColor darkGrayColor];
                cell.customLabel.text = LMLocalizedString(@"CELLS_1");
            }
                break;
            case 1: {
                cell.backgroundColor = [UIColor redColor];
                cell.customLabel.text = LMLocalizedString(@"CELLS_2");
            }
                break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                cell.backgroundColor = [UIColor grayColor];
                cell.customLabel.text = LMLocalizedString(@"CELLS_3");
            }
                break;
            case 1: {
                cell.backgroundColor = [UIColor darkGrayColor];
                cell.customLabel.text = LMLocalizedString(@"CELLS_4");
            }
                break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                cell.backgroundColor = [UIColor redColor];
                cell.customLabel.text = LMLocalizedString(@"CELLS_5");
            }
                break;
            case 1: {
                cell.backgroundColor = [UIColor grayColor];
                cell.customLabel.text = LMLocalizedString(@"CELLS_6");
            }
                break;
            default:
                break;
        }
    }
    
    return cell;
}


#pragma mark -
#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                break;
            case 1:
                [self pushServerCell];
                break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self pushMapsCell];
                break;
            case 1:
               // [self pushGallaryCell];
                break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
               [self pushQRScanCell];
                break;
            case 1:
                [self pushPDFCell];
                break;
            default:
                break;
        }
    }
}


#pragma mark -
#pragma mark Private methods
- (void)pushServerCell{
    ServerViewController *serverViewController = [[ServerViewController alloc]init];
    [self.navigationController pushViewController:serverViewController animated:YES];
}

- (void)pushGallaryCell{
    GallaryViewController *gallaryViewController = [[GallaryViewController alloc]init];
    [self.navigationController pushViewController:gallaryViewController animated:YES];
}

- (void)pushQRScanCell{
    QRScannerViewController *qRScannerViewController = [[QRScannerViewController alloc]init];
    [self.navigationController pushViewController:qRScannerViewController animated:YES];
}

- (void)pushPDFCell{
    PDFViewController *pDFViewController = [[PDFViewController alloc]init];
    [self.navigationController pushViewController:pDFViewController animated:YES];
}

- (void)pushMapsCell{
    MapsViewController *mapsViewController = [[MapsViewController alloc]init];
    [self.navigationController pushViewController:mapsViewController animated:YES];
}

#pragma mark -
#pragma mark <UICollectionViewDelegate>
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
}


#pragma mark -
#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBounds.size;

    return CGSizeMake(screenSize.width / CELL_ROWS, screenSize.height / (CELL_SECTIONS + 1));
}


@end
