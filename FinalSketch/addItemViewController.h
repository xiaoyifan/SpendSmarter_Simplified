//
//  addItemViewController.h
//  FinalSketch
//
//  Created by XiaoYifan on 2/28/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "Item.h"
#import <UIKit/UIKit.h>
#import "mapViewController.h"

@interface addItemViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;

@property (strong, nonatomic) NSString *categorySelected;

@property (strong, nonatomic) UIImage *categoryPic;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) CLLocation *itemLocation;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *categoryArray;


- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
