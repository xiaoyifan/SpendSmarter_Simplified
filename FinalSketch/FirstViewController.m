//
//  FirstViewController.m
//  FinalSketch
//
//  Created by xiaoyifan on 2/24/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "FirstViewController.h"
#import "detailSegue.h"
#import "ItemTableViewCell.h"
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
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults arrayForKey:@"itemArray"] == nil) {
        self.itemArray = [[NSMutableArray alloc]init];
        [defaults setObject:self.itemArray forKey:@"itemArray"];
        [defaults synchronize];
    }
    else{
        self.itemArray = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"itemArray"]];
        
        //if the array exists, get the array from NSUserDefault and change it to NSMutableArray
    }

    [self.mainTableView reloadData];
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
    
    NSLog(@"%lu",(unsigned long)self.itemArray.count);
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSMutableDictionary *item = [self.itemArray objectAtIndex:indexPath.row];
    
//    [self setObject:self.itemTitle forKey:@"title"];
//    [self setObject:self.itemDescription forKey:@"description"];
//    [self setObject:self.image forKey:@"image"];
//    [self setObject:self.itemCategory forKey:@"category"];
//    [self setObject:self.itemLocation forKey:@"location"];
//    [self setObject:self.locationDescription forKey:@"locationDescription"];
//    [self setObject:self.itemDate forKey:@"date"];
//    [self setObject:self.itemPrice forKey:@"price"];
   
    cell.itemTitle.text = [item objectForKey:@"title"];
    cell.itemDescription.text = [item objectForKey:@"description"];

    cell.itemImage.image = [item objectForKey:@"image"];
    
    cell.itemPrice.text = [item objectForKey:@"price"];

    cell.itemPrice.backgroundColor = [UIColor blackColor];
    cell.itemPrice.alpha = 0.7;
    [cell setNeedsDisplay];
    
    return cell;

}



#pragma mark - sidebar delegate
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
    // Pass the selected object to the new view controller
    NSLog(@"The method is called");
    
    if ([segue.identifier isEqualToString:@"detailSegue"])
    {
        NSIndexPath *indexPath = [self.mainTableView indexPathForSelectedRow];
        
        //NSDictionary * dataItem = [self.itemData objectAtIndex:indexPath.row];
        
        //itemDetailViewController *destVC = [[segue destinationViewController] topViewController];
        
        //[destVC setItemDictionary:dataItem];
        
        
    }
    
    if ([segue.identifier isEqualToString:@"addDetailSegue"])
    {
        
        
        
    }
    
    

}




@end
