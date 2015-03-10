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
#import "FileSession.h"
#import "Item.h"
#import "Map.h"

@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) RNFrostedSidebar *callout;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (weak, nonatomic) IBOutlet UIButton *syncButton;

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
    
    NSLog(@"%@",self.account);
    
    
    
    
    NSURL *fileURL = [FileSession getListURLOf:@"items.plist"];
    
    self.itemArray = [NSMutableArray arrayWithArray:[FileSession readDataFromList:fileURL]];
    
    NSURL *mapURL = [FileSession getListURLOf:@"map.plist"];
    
    self.map = [NSMutableArray arrayWithArray:[FileSession readDataFromList:mapURL]];
    
    

    [self.mainTableView reloadData];
    
    
    self.account = [[DBAccountManager sharedManager] linkedAccount];
    if (!self.account) {
        self.syncButton.enabled = NO;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSURL *fileURL = [FileSession getListURLOf:@"items.plist"];
    self.itemArray = [NSMutableArray arrayWithArray:[FileSession readDataFromList:fileURL]];
    [self.mainTableView reloadData];
    
    NSURL *mapURL = [FileSession getListURLOf:@"map.plist"];
    self.map = [NSMutableArray arrayWithArray:[FileSession readDataFromList:mapURL]];
    
    for (Map *item in self.map) {
        NSLog(@"%@", item.categoryString);
        NSLog(@"%@", item.itemNumber);
    }
    
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
    
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Item *item = [self.itemArray objectAtIndex:indexPath.row];

   
    cell.itemTitle.text = item.title;
    cell.itemDescription.text = item.itemDescription;

    cell.itemImage.image = item.image;
    
    cell.itemPrice.text = item.price;
    
    cell.categoryImage.image = item.categoryPic;
    
    cell.dateLabel.text = item.date;
    
    cell.locationLabel.text = item.locationDescription;

    cell.itemPrice.backgroundColor = [UIColor blackColor];
    cell.itemPrice.alpha = 0.7;
    [cell setNeedsDisplay];
    
    return cell;

}



#pragma mark - sidebar delegate
-(void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    
    if (index == 1) {
        self.account = [[DBAccountManager sharedManager] linkedAccount];
        if (self.account) {
            NSLog(@"App already linked");
            NSLog(@"%@", self.account.info);
                self.syncButton.enabled = NO;
            DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:self.account];
            [DBFilesystem setSharedFilesystem:filesystem];
            
            DBPath *newPath = [[DBPath root] childPath:@"iAccount"];
            
            DBPath *itemPath = [newPath childPath:@"items.plist"];
            DBFile *itemFile = [[DBFilesystem sharedFilesystem] createFile:itemPath error:nil];
            
            DBPath *mapPath = [newPath childPath:@"map.plist"];
            DBFile *mapFile = [[DBFilesystem sharedFilesystem] createFile:mapPath error:nil];
            
            
            NSURL *itemUrl = [FileSession getListURLOf:@"items.plist"];
            [itemFile writeData:[NSData dataWithContentsOfURL:itemUrl] error:nil];
            
            NSURL *mapUrl = [FileSession getListURLOf:@"map.plist"];
            [mapFile writeData:[NSData dataWithContentsOfURL:mapUrl] error:nil];
            NSLog(@"mapPath is %@", mapPath);
            NSLog(@"mapURL is %@", mapUrl);
            
            //could initialize a alert view here that you gonna unlink your Dropbox account here
        } else {
            [[DBAccountManager sharedManager] linkFromController:self];
            self.account = [[DBAccountManager sharedManager] linkedAccount];
            if (self.account) {
                DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:self.account];
                [DBFilesystem setSharedFilesystem:filesystem];
            }
            self.syncButton.enabled = YES;
        }
    }
    else if (index == 2) {
       UITableViewController *gallery = [self.storyboard instantiateViewControllerWithIdentifier:@"galleryVC"];
        [self presentViewController:gallery animated:YES completion:nil];
    }
    
    if (index == 3) {

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
        
        Item * dataItem = [self.itemArray objectAtIndex:indexPath.row];
        
        itemDetailViewController *destVC = (itemDetailViewController *)[[segue destinationViewController] topViewController];
        
        [destVC setDetailItem:dataItem];
        
        
    }
    
    
    

}




@end
