//
//  RWDemoViewController.m
//  RWBarChartViewDemo
//
//  Created by Yifan Xiao & Yecheng Li on 14-03-08.
//  Copyright (c) 2014 Yifan Xiao & Yecheng Li. All rights reserved.
//

#import "RWDemoViewController.h"
#import "RWBarChartView.h"



@interface RWDemoViewController () <RWBarChartViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSDictionary *singleItems; // indexPath -> RWBarChartItem
@property (nonatomic, strong) NSArray *itemCounts;
@property (nonatomic, strong) RWBarChartView *singleChartView;
@property (nonatomic, strong) NSIndexPath *indexPathToScroll;
@property (weak, nonatomic) IBOutlet UILabel *dayExpenseLabel;

@end



@implementation RWDemoViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)loadView
{
    [super loadView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 100, 30)];
    titleLabel.text = @"Bar Chart";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Neue" size:16]; //custom font
    titleLabel.numberOfLines = 1;
    titleLabel.baselineAdjustment = YES;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.clipsToBounds = YES;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(self.view.frame.size.width/2, 25);
    [self.view addSubview:titleLabel];
    
    // represents days and total expenditure of that day respectively
    NSMutableArray *itemCounts = [NSMutableArray array];
    NSMutableDictionary *singleItems = [NSMutableDictionary dictionary];
    
    // make sample values
    for (NSInteger month = 0; month < 12; ++month)
    {
        NSInteger numDays;
        NSInteger realMonth = month+1;
        if (realMonth==1 || realMonth==3 || realMonth==5 || realMonth==7 || realMonth==8 || realMonth==10 || realMonth==12) {
            numDays = 31;
        }
        else if (realMonth==4 || realMonth==6 || realMonth==9 || realMonth==11) {
            numDays = 30;
        }
        else {
            numDays = 28;
        }
        
        [itemCounts addObject:@(numDays)];
        for (NSInteger irow = 0; irow < numDays; ++irow)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:irow inSection:month];
            
            // fake data to demonstrate daily expenses
            {
                CGFloat ratio = (CGFloat)(random() % 1000) / 1000.0;
                
                NSLog(@"%f", ratio);
                
                UIColor *color = nil;
                if (ratio < 0.25)
                {
                    color = [UIColor colorWithRed:129/255.0 green:199/255.0 blue:132/255.0 alpha:1];
                }
                else if (ratio < 0.5)
                {
                    color = [UIColor colorWithRed:100/255.0 green:181/255.0 blue:246/255.0 alpha:1];
                }
                else if (ratio < 0.75)
                {
                    color = [UIColor colorWithRed:220/255.0 green:231/255.0 blue:117/255.0 alpha:1];
                    
                }
            
                else
                {
                    color = [UIColor colorWithRed:255/255.0 green:183/255.0 blue:77/255.0 alpha:1];
                }
                
                RWBarChartItem *singleItem = [RWBarChartItem itemWithSingleSegmentOfRatio:ratio color:color];
                singleItem.text = [NSString stringWithFormat:@"Date: %ld-%ld, Expense:%.2f ", (long)indexPath.section+1, (long)indexPath.item+1, ratio*1000];
               // self.dayExpenseLabel.text = [NSString stringWithFormat:@"Date: %ld-%ld   Expense:%@", (long)indexPath.section+1, (long)indexPath.item+1, singleItem.ratios];
                //NSLog(@"%@", singleItem.ratios);
                singleItems[indexPath] = singleItem;
            }
        }
    }
    
    self.itemCounts = itemCounts;
    self.singleItems = singleItems;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.singleChartView = [RWBarChartView new];
    self.singleChartView.dataSource = self;
    self.singleChartView.barWidth = 15;
    
    self.singleChartView.alwaysBounceHorizontal = YES;
    
    self.singleChartView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:self.singleChartView];
    
    self.singleChartView.scrollViewDelegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self updateScrollButton];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:240/255.0 alpha:1];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat padding = 50;
    CGFloat height = (self.view.bounds.size.height - padding)*0.9;
    CGRect rect = CGRectMake(0, padding, self.view.bounds.size.width, height);
    self.singleChartView.frame = rect;

    [self.singleChartView reloadData];
}

- (NSInteger)numberOfSectionsInBarChartView:(RWBarChartView *)barChartView
{
    return self.itemCounts.count;
}

- (NSInteger)barChartView:(RWBarChartView *)barChartView numberOfBarsInSection:(NSInteger)section
{
    /*
     if (section == self.itemCounts.count - 1)
     {
     return 1;
     }
     */
    
    return [self.itemCounts[section] integerValue];
}

- (id<RWBarChartItemProtocol>)barChartView:(RWBarChartView *)barChartView barChartItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@",self.singleItems[indexPath]);
    return self.singleItems[indexPath];
}

- (NSString *)barChartView:(RWBarChartView *)barChartView titleForSection:(NSInteger)section
{
//    NSString *prefix = @"Month: ";
//    return [prefix stringByAppendingFormat:@" %ld", (long)section];
    if(section==0)
        return @"January";
    else if(section==1)
        return @"February";
    else if(section==2)
        return @"March";
    else if(section==3)
        return @"April";
    else if(section==4)
        return @"May";
    else if(section==5)
        return @"June";
    else if(section==6)
        return @"July";
    else if(section==7)
        return @"August";
    else if(section==8)
        return @"September";
    else if(section==9)
        return @"October";
    else if(section==10)
        return @"November";
    else
        return @"December";
}

- (BOOL)shouldShowItemTextForBarChartView:(RWBarChartView *)barChartView
{
    return YES; // barChartView == self.singleChartView;
}

- (BOOL)barChartView:(RWBarChartView *)barChartView shouldShowAxisAtRatios:(out NSArray *__autoreleasing *)axisRatios withLabels:(out NSArray *__autoreleasing *)axisLabels
{
    
    *axisRatios = @[@(0.25), @(0.50), @(0.75), @(1.0)];
    *axisLabels = @[@"25%", @"50%", @"75%", @"100%"];
    
    return YES;
}

// UIScrollView events handling
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
}


- (NSIndexPath *)indexPathToScroll
{
    if (!_indexPathToScroll)
    {
        NSInteger section = arc4random() % self.itemCounts.count;
        NSInteger item = arc4random() % [self.itemCounts[section] integerValue];
        //NSLog(@"Section: %ld; Item: %ld", (long)section, (long)item);
        _indexPathToScroll = [NSIndexPath indexPathForItem:item inSection:section];
    }
    return _indexPathToScroll;
}


- (void)updateScrollButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Scroll To %ld-%ld", (long)self.indexPathToScroll.section, (long)self.indexPathToScroll.item] style:UIBarButtonItemStylePlain target:self action:@selector(scrollToBar)];
}

// scroll animation
- (void)scrollToBar
{
    [self.singleChartView scrollToBarAtIndexPath:self.indexPathToScroll animated:YES];
    self.indexPathToScroll = nil;
    [self updateScrollButton];
}

@end
