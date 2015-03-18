//
//  pirChartViewController.m
//  FinalSketch
//
//  Created by xiaoyifan on 3/9/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "pieChartViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FileSession.h"
#import "Map.h"
#import "JTNumberScrollAnimatedView.h"

@interface pieChartViewController ()

@property (weak, nonatomic) IBOutlet JTNumberScrollAnimatedView *spentAmountView;

@property (weak, nonatomic) IBOutlet JTNumberScrollAnimatedView *remainAmountView;

@property (weak, nonatomic) IBOutlet JTNumberScrollAnimatedView *thisCategoryAmountView;

@end

@implementation pieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *mapURL = [FileSession getListURLOf:@"map.plist"];
    
    self.map = [NSMutableArray arrayWithArray:[FileSession readDataFromList:mapURL]];
    // this is the data to draw the pieChart
    
    
    self.slices = [NSMutableArray arrayWithCapacity:self.map.count];
    
    // set value for each slice
    for(int i = 0; i < self.map.count; i ++)
    {
        NSNumber *one = [[self.map objectAtIndex:i] itemNumber];
        [self.slices addObject:one];
        //initialize the data from the array
    }
    
    [self.pieChartRight setDelegate:self];
    [self.pieChartRight setDataSource:self];
    [self.pieChartRight setStartPieAngle:M_PI_2];
    [self.pieChartRight setAnimationSpeed:1.0];
    [self.pieChartRight setShowPercentage:YES];
    [self.pieChartRight setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    [self.pieChartRight setLabelRadius:self.pieChartRight.bounds.size.width*0.35];
    [self.pieChartRight setPieBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:240/255.0 alpha:1]]; //ivory
    // set location of pie centre

    
    [self.pieChartRight setUserInteractionEnabled:YES];
    // [self.pieChartRight setLabelShadowColor:[UIColor blackColor]];
    [self.pieChartRight setLabelColor:[UIColor blackColor]];
    
//    [self.percentageLabel.layer setCornerRadius:90];
    
    
    // change color: use color for slices at index
    // reference: http://www.google.com/design/spec/style/color.html#color-color-palette
    
    self.sliceColors =[NSArray arrayWithObjects:
                       
                       [UIColor colorWithRed:121/255.0 green:134/255.0 blue:203/255.0 alpha:1], //5. indigo
                       [UIColor colorWithRed:174/255.0 green:213/255.0 blue:129/255.0 alpha:1], //14. light green
                       [UIColor colorWithRed:100/255.0 green:181/255.0 blue:246/255.0 alpha:1], //2. blue
                       [UIColor colorWithRed:220/255.0 green:231/255.0 blue:117/255.0 alpha:1], //8. lime
                       [UIColor colorWithRed:79/255.0 green:195/255.0 blue:247/255.0 alpha:1], //7. light blue
                       [UIColor colorWithRed:77/255.0 green:208/255.0 blue:225/255.0 alpha:1], //3. cyan
                       [UIColor colorWithRed:77/255.0 green:182/255.0 blue:172/255.0 alpha:1], //13. teal
                       [UIColor colorWithRed:129/255.0 green:199/255.0 blue:132/255.0 alpha:1], //9. green
                       [UIColor colorWithRed:255/255.0 green:241/255.0 blue:118/255.0 alpha:1], //16. yellow
                       [UIColor colorWithRed:255/255.0 green:213/255.0 blue:79/255.0 alpha:1], //12. amber
                       [UIColor colorWithRed:255/255.0 green:183/255.0 blue:77/255.0 alpha:1], //4. orange
                       [UIColor colorWithRed:255/255.0 green:138/255.0 blue:101/255.0 alpha:1], //10. deep orange
                       [UIColor colorWithRed:144/255.0 green:164/255.0 blue:174/255.0 alpha:1], //15. blue grey
                       [UIColor colorWithRed:229/255.0 green:155/255.0 blue:155/255.0 alpha:1], //6. red
                       [UIColor colorWithRed:240/255.0 green:98/255.0 blue:146/255.0 alpha:1], //1. pink
                       [UIColor colorWithRed:186/255.0 green:104/255.0 blue:200/255.0 alpha:1], //11. purple
                       nil];
    //the color of each piece
    
    self.spentAmountView.textColor = [UIColor grayColor];
    self.spentAmountView.font = [UIFont fontWithName:@"HelveticaNeue-light" size:20];
    
    self.spentAmountView.minLength = 3;
    
    self.remainAmountView.textColor = [UIColor grayColor];
    self.remainAmountView.font = [UIFont fontWithName:@"HelveticaNeue-light" size:20];
    
    self.spentAmountView.minLength = 3;
    
    self.thisCategoryAmountView.textColor =  [UIColor grayColor];
    self.thisCategoryAmountView.font = [UIFont fontWithName:@"HelveticaNeue-light" size:20];
    self.thisCategoryAmountView.minLength =3;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setPieChartRight:nil];
    [self setSelectedSliceLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSURL *mapURL = [FileSession getListURLOf:@"map.plist"];
    
    self.map = [NSMutableArray arrayWithArray:[FileSession readDataFromList:mapURL]];
    
    self.slices = [NSMutableArray arrayWithCapacity:self.map.count];
    
    // set value for each slice
    for(int i = 0; i < self.map.count; i ++)
    {
        NSNumber *one = [[self.map objectAtIndex:i] itemNumber];
        [self.slices addObject:one];
    }
    [self.pieChartRight reloadData];
    
  
    [self.spentAmountView setValue:[NSNumber numberWithInt:(rand() % 5000)]];
    
    [self.remainAmountView setValue:[NSNumber numberWithInt:(rand() % 5000)]];
    
     [self.thisCategoryAmountView setValue:[NSNumber numberWithInt:0]];

    [self.spentAmountView startAnimation];
    [self.remainAmountView startAnimation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.slices = nil;
    [self.pieChartRight reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    NSLog(@"%lu slices",(unsigned long)self.slices.count);
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    //if(pieChart == self.pieChartRight) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
    self.selectedSliceLabel.text = @"Category";
    
    [self.thisCategoryAmountView setValue:@(0)];
    
    [self.thisCategoryAmountView startAnimation];
}

// TO set number "selectedSliceLabel" text
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
    // self.selectedSliceLabel.text = @"Select a category";
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    
    self.selectedSliceLabel.text = [NSString stringWithFormat:@"%@",[[self.map objectAtIndex:index] categoryString]];
    
    NSNumber *number = [[self.map objectAtIndex:index] itemNumber];
    
    [self.thisCategoryAmountView setValue:number];
    
    [self.thisCategoryAmountView startAnimation];
    
   
}


*/

@end
