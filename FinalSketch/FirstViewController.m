//
//  FirstViewController.m
//  FinalSketch
//
//  Created by xiaoyifan on 2/24/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "FirstViewController.h"
#import "detailSegue.h"

#import "itemDetailViewController.h"

@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) RNFrostedSidebar *callout;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:240/255.0 alpha:1];
    self.mainTableView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:240/255.0 alpha:1];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:0];
    
    NSArray *images = @[
                        [UIImage imageNamed:@"profile"],
                        [UIImage imageNamed:@"dropbox"],
                        [UIImage imageNamed:@"photo"],
                        [UIImage imageNamed:@"gear"],
                        [UIImage imageNamed:@"back"]
                        
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:61/255.f green:154/255.f blue:232/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1]

                        
                        ];
    
    self.callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    self.callout.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMenu:(id)sender {
    
    [self.callout show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    cell.contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:220/255.0 alpha:1];
    NSLog(@"%ld", (long)indexPath.row);
    
    UIImage *image = [UIImage imageNamed:@"Chicago.jpg"];
    cell.backgroundView = [self initializeImageViewWithName:image
                                                    InWidth:cell.contentView.window.frame.size.width
                                                  andHeight:cell.contentView.window.frame.size.height];
    cell.selectedBackgroundView =  [self initializeImageViewWithName:image
                                                             InWidth:cell.contentView.window.frame.size.width
                                                           andHeight:cell.contentView.window.frame.size.height];
    
    cell.textLabel.text = @"Hello table";
    
    return cell;

}

-(UIImageView *)initializeImageViewWithName:(UIImage *)image
                                    InWidth:(CGFloat)width
                                  andHeight:(CGFloat)height{
    UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    av.backgroundColor = [UIColor clearColor];
    av.opaque = NO;
    av.image = image;
    
    return av;
}

-(void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %lu",(unsigned long)index);
    if (index == 3) {
//        SecondViewController *second = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
//        [self presentViewController:second animated:YES completion:nil];
    }
    if (index == 4) {
        [sidebar dismissAnimated:YES];
    }
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller
    NSLog(@"The method is called");
    

}




@end
