//
//  settingsTableViewController.m
//  FinalSketch
//
//  Created by xiaoyifan on 3/15/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "settingsTableViewController.h"

@interface settingsTableViewController ()

@end

@implementation settingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sliderValueChanged:(id)sender {
     self.warningLabel.text = [NSString stringWithFormat:@"%f%%", self.warningSlider.value];
}

- (IBAction)dismissVC:(id)sender {
    
    //settings to be saved in the plist
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
