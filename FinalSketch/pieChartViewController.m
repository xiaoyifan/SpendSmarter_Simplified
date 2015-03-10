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

@interface pieChartViewController ()

@end

@implementation pieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ViewController called;");
    // Do any additional setup after loading the view.
    NSURL *mapURL = [FileSession getListURLOf:@"map.plist"];
    
    self.map = [NSMutableArray arrayWithArray:[FileSession readDataFromList:mapURL]];
    
    self.slices = [NSMutableArray arrayWithCapacity:self.map.count];
    
    // set value for each slice
    for(int i = 0; i < self.map.count; i ++)
    {
        NSNumber *one = [[self.map objectAtIndex:i] itemNumber];
        [self.slices addObject:one];
    }
    
    [self.pieChartRight setDelegate:self];
    [self.pieChartRight setDataSource:self];
    [self.pieChartRight setStartPieAngle:M_PI_2];
    [self.pieChartRight setAnimationSpeed:1.0];
    [self.pieChartRight setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    [self.pieChartRight setLabelRadius:170];
    [self.pieChartRight setPieBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:240/255.0 alpha:1]]; //ivory
    // set location of pie centre
    
    NSLog(@"The half size : %f, %f", self.pieChartRight.frame.size.width/2, self.pieChartRight.frame.size.height/2);
    NSLog(@"The origin: %f, %f", self.pieChartRight.frame.origin.x, self.pieChartRight.frame.origin.y);
    NSLog(@"The center: %f, %f",self.pieChartRight.frame.size.width/2+self.pieChartRight.frame.origin.x , self.pieChartRight.frame.size.height/2+self.pieChartRight.frame.origin.y);

    
    [self.pieChartRight setUserInteractionEnabled:YES];
    // [self.pieChartRight setLabelShadowColor:[UIColor blackColor]];
    [self.pieChartRight setLabelColor:[UIColor blackColor]];
    
    //[self.percentageLabel.layer setCornerRadius:90];
    
    
    // change color: use color for slices at index
    // reference: http://www.google.com/design/spec/style/color.html#color-color-palette
    
    self.sliceColors =[NSArray arrayWithObjects:
                       
                       [UIColor colorWithRed:121/255.0 green:134/255.0 blue:203/255.0 alpha:1], //5. indigo
                       [UIColor colorWithRed:100/255.0 green:181/255.0 blue:246/255.0 alpha:1], //2. blue
                       [UIColor colorWithRed:79/255.0 green:195/255.0 blue:247/255.0 alpha:1], //7. light blue
                       [UIColor colorWithRed:77/255.0 green:208/255.0 blue:225/255.0 alpha:1], //3. cyan
                       [UIColor colorWithRed:77/255.0 green:182/255.0 blue:172/255.0 alpha:1], //13. teal
                       [UIColor colorWithRed:129/255.0 green:199/255.0 blue:132/255.0 alpha:1], //9. green
                       [UIColor colorWithRed:220/255.0 green:231/255.0 blue:117/255.0 alpha:1], //8. lime
                       [UIColor colorWithRed:255/255.0 green:241/255.0 blue:118/255.0 alpha:1], //16. yellow
                       [UIColor colorWithRed:255/255.0 green:213/255.0 blue:79/255.0 alpha:1], //12. amber
                       [UIColor colorWithRed:255/255.0 green:183/255.0 blue:77/255.0 alpha:1], //4. orange
                       [UIColor colorWithRed:255/255.0 green:138/255.0 blue:101/255.0 alpha:1], //10. deep orange
                       [UIColor colorWithRed:174/255.0 green:213/255.0 blue:129/255.0 alpha:1], //14. light green
                       [UIColor colorWithRed:144/255.0 green:164/255.0 blue:174/255.0 alpha:1], //15. blue grey
                       [UIColor colorWithRed:229/255.0 green:155/255.0 blue:155/255.0 alpha:1], //6. red
                       [UIColor colorWithRed:240/255.0 green:98/255.0 blue:146/255.0 alpha:1], //1. pink
                       [UIColor colorWithRed:186/255.0 green:104/255.0 blue:200/255.0 alpha:1], //11. purple
                       nil];
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
    NSLog(@"View Did Appear called");
    [self.pieChartRight reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (IBAction)showSlicePercentage:(id)sender {
    UISwitch *perSwitch = (UISwitch *)sender;
    [self.pieChartRight setShowPercentage:perSwitch.isOn];
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
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
