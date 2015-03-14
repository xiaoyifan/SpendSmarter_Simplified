//
//  RWDemoViewController.m
//  RWBarChartViewDemo
//
//  Created by Yecheng Li on 14-03-08.
//  Copyright (c) 2014 Zhang Bin. All rights reserved.
//

#import "RWDemoViewController.h"
#import "RWBarChartView.h"



@interface RWDemoViewController () <RWBarChartViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSDictionary *singleItems; // indexPath -> RWBarChartItem
@property (nonatomic, strong) NSArray *itemCounts;
@property (nonatomic, strong) RWBarChartView *singleChartView;
@property (nonatomic, strong) NSIndexPath *indexPathToScroll;

@end



@implementation RWDemoViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)loadView
{
    [super loadView];
    
    // represents days and total expenditure of that day respectively
    NSMutableArray *itemCounts = [NSMutableArray array];
    NSMutableDictionary *singleItems = [NSMutableDictionary dictionary];
    
    // make sample values
    for (NSInteger month = 0; month < 12; ++month)
    {
       // NSInteger n = random() % 30 + 1;
       
        NSInteger numDays;
        if (month==1 || month==3 || month==5 || month==7 || month==8 || month==10 || month==12) {
            numDays = 31;
        }
        else if (month==2 || month==4 || month==6 || month==9 || month==11) {
            numDays = 30;
        }
        else {
            numDays = 29;
        }

        
        
        [itemCounts addObject:@(numDays)];
        for (NSInteger irow = 0; irow < numDays; ++irow)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:irow inSection:month];
            
            // signle-segment item
            {
                CGFloat ratio = (CGFloat)(random() % 1000) / 1000.0;
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
                singleItem.text = [NSString stringWithFormat:@"Date: %ld-%ld ", (long)indexPath.section, (long)indexPath.item];
                singleItems[indexPath] = singleItem;
            }
        }
    }
    
    self.itemCounts = itemCounts;
    self.singleItems = singleItems;
   // self.statItems = statItems;
    
    
    
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
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat padding = 20;
    CGFloat height = (self.view.bounds.size.height - padding)*0.7;
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
    return self.singleItems[indexPath];
}

- (NSString *)barChartView:(RWBarChartView *)barChartView titleForSection:(NSInteger)section
{
    NSString *prefix = @"Month: ";
    return [prefix stringByAppendingFormat:@" %ld", (long)section];
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
