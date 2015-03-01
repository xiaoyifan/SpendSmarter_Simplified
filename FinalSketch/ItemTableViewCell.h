//
//  ItemTableViewCell.h
//  FinalSketch
//
//  Created by xiaoyifan on 2/28/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *itemImage;

@property (weak, nonatomic) IBOutlet UILabel *itemTitle;

@property (weak, nonatomic) IBOutlet UILabel *itemDescription;


@property (weak, nonatomic) IBOutlet UILabel *itemPrice;

@end
