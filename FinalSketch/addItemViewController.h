//
//  addItemViewController.h
//  FinalSketch
//
//  Created by XiaoYifan on 2/28/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "singleItemDictionary.h"
#import <UIKit/UIKit.h>

@interface addItemViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) CLLocation *itemLocation;

@end
