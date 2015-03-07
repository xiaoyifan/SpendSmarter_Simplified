//
//  galleryTableViewController.h
//  FinalSketch
//
//  Created by xiaoyifan on 3/7/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface galleryTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) NSMutableArray *itemArray;

@property (strong,nonatomic) IBOutlet UITableView *tableview;

@end
