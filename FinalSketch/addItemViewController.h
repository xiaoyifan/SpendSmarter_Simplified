//
//  addItemViewController.h
//  FinalSketch
//
//  Created by XiaoYifan on 2/28/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "Item.h"
#import "Map.h"
#import "Timeline.h"
#import <UIKit/UIKit.h>
#import "mapViewController.h"
#import <Dropbox/Dropbox.h>

@interface addItemViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;

@property (strong, nonatomic) IBOutlet UIImageView *categoryImageView;

@property (strong, nonatomic) NSString *categorySelected;

@property (strong, nonatomic) UIImage *categoryPic;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) CLLocation *itemLocation;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *categoryArray;

@property (nonatomic, strong) DBAccount *account;


- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
