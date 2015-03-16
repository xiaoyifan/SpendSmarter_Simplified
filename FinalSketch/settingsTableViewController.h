//
//  settingsTableViewController.h
//  FinalSketch
//
//  Created by xiaoyifan on 3/15/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *monthlyAmount;

@property (weak, nonatomic) IBOutlet UISlider *warningSlider;

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;



@end
