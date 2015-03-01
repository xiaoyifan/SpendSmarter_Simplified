//
//  itemDetailViewController.m
//  FinalSketch
//
//  Created by xiaoyifan on 2/27/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "itemDetailViewController.h"
#import "FirstViewController.h"

@interface itemDetailViewController ()

@end

@implementation itemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mainScrollView.delegate = self;
    self.mainScrollView.scrollEnabled = YES;
    //self.mainScrollView.contentSize = self.view.frame.size;
    
    self.itemImage.image = [UIImage imageNamed:@"superstar.png"];
    
}

- (void)viewDidLayoutSubviews {
    [self.mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1150)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

















- (IBAction)back:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];

}



@end
