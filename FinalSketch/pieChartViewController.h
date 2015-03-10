//
//  pirChartViewController.h
//  FinalSketch
//
//  Created by xiaoyifan on 3/9/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface pieChartViewController : UIViewController<XYPieChartDelegate, XYPieChartDataSource>

@property (strong, nonatomic) IBOutlet XYPieChart *pieChartRight;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;

@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

@property (nonatomic, strong) NSMutableArray *map;


@end
