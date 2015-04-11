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
#import "Timeline.h"
#import "SpendSmarter-Swift.h"


@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) RNFrostedSidebar *callout;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (weak, nonatomic) IBOutlet UIButton *syncButton;

@property (retain,nonatomic) ViewController *vc;

@property (nonatomic) BOOL needToLoadFiles;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.vc = [[ViewController alloc] init];
    [self presentViewController:self.vc animated:NO completion:nil];
    [self.view addSubview:self.vc.view];
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunchDate"];
    if (date) {
        NSLog(@"gonna call the selector");
        [self performSelector:@selector(dissMissViewController) withObject:self afterDelay:2.0];
    }
 
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:0];
    
    NSArray *images = @[
                        [UIImage imageNamed:@"gear"],
//                        [UIImage imageNamed:@"dropbox"],
//                        [UIImage imageNamed:@"sync"],
                        [UIImage imageNamed:@"photo"],
                        [UIImage imageNamed:@"Info"],
                        [UIImage imageNamed:@"back"]
                        
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:61/255.f green:154/255.f blue:232/255.f alpha:1],
//                        [UIColor colorWithRed:61/255.f green:154/255.f blue:232/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1]

                        
                        ];
    
    self.callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    self.callout.delegate = self;
    
    NSLog(@"%@",self.account);
    
    
    
    
    NSURL *fileURL = [FileSession getListURLOf:@"items.plist"];
    
//        self.itemArray = nil;
//        [FileSession writeData:self.itemArray ToList:fileURL];
    
    self.itemArray = [NSMutableArray arrayWithArray:[FileSession readDataFromList:fileURL]];
    
    NSURL *mapURL = [FileSession getListURLOf:@"map.plist"];
    
//        self.map = nil;
//        [FileSession writeData:self.map ToList:mapURL];
    
    self.map = [NSMutableArray arrayWithArray:[FileSession readDataFromList:mapURL]];
    
    NSURL *timelineURL = [FileSession getListURLOf:@"timeline.plist"];
    
//        self.timeline = nil;
//        [FileSession writeData:self.timeline ToList:timelineURL];
    
    self.timeline = [NSMutableArray arrayWithArray:[FileSession readDataFromList:timelineURL]];

    [self.mainTableView reloadData];
    
    
    self.account = [[DBAccountManager sharedManager] linkedAccount];
    NSLog(@"The current linked Dropbox account is: %@", self.account);

    
}


//dissMissviewController is the method which has the code for dismissing the viewController.

//and can follow the same for showing the viewController.

- (void)dissMissViewController
{
    //if you are pushing your viewControler, then use below single line code
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"calling the selector");
    //if you are presnting ViewController modally. then use below code
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSURL *fileURL = [FileSession getListURLOf:@"items.plist"];
    self.itemArray = [NSMutableArray arrayWithArray:[FileSession readDataFromList:fileURL]];
    
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
    
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    Item *item = [self.itemArray objectAtIndex:indexPath.row];
    //initialize the cell object, from array of items
   
    cell.itemTitle.text = item.title;
    cell.itemDescription.text = item.itemDescription;
    
    if (item.image != nil) {
        cell.itemImage.image = item.image;
    }
    else{
        cell.itemImage.image = nil;
        cell.itemImage.backgroundColor  = [self randomColor];
    }
    //initialize the cell pic
    //if not pic is provided, we will use the random color
    
    cell.itemPrice.text = [NSString stringWithFormat:@"  $%@  ",[item.price stringValue]];
    
    cell.categoryImage.backgroundColor = [UIColor grayColor];
    
    cell.dateLabel.text = item.date;
    
    if(item.locationDescription.length == 0)
    {
     cell.locationLabel.text = @"location not provided";
    }
    else{
    cell.locationLabel.text = item.locationDescription;
    }
    cell.itemPrice.backgroundColor = [UIColor blackColor];
    cell.itemPrice.alpha = 0.7;
    [cell setNeedsDisplay];
    
    return cell;

}


//select a random color
-(UIColor *)randomColor{
    NSArray *sliceColors =[NSArray arrayWithObjects:
                       
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
    
    int rad = arc4random() % 16;
    return sliceColors[rad];

}


#pragma mark - sidebar delegate

//this is the side bar method
-(void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    
  if (index == 0) {
      
    }
    else if (index == 1) {
       UITableViewController *gallery = [self.storyboard instantiateViewControllerWithIdentifier:@"galleryVC"];
        [self presentViewController:gallery animated:YES completion:nil];
        //load gallery to view the pics
    }
    else if (index == 2) {
        UIViewController *info = [self.storyboard instantiateViewControllerWithIdentifier:@"infoViewController"];
        [self presentViewController:info animated:YES completion:nil];
        
        //show brief info
    }
    if (index == 3) {
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
        //bring the item object selected to detailVC
    }
}


-(void)dropboxConnect{
    
    self.account = [[DBAccountManager sharedManager] linkedAccount];
    //check if there's a linked account
    
    if (self.account) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"You are not linked." message:[NSString stringWithFormat:@"%@",self.account.info] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [self.account unlink];
        
    } else {
        [[DBAccountManager sharedManager] linkFromController:self];
        self.account = [[DBAccountManager sharedManager] linkedAccount];
        //if the account is not linked, will link to your Dropbox account
       
    }
    
}

-(void)startSync{
    self.account = [[DBAccountManager sharedManager] linkedAccount];
    //get the current account
    if (self.account)
    {
        
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:self.account];
        [DBFilesystem setSharedFilesystem:filesystem];
        NSLog(@"start sync............");
        
        __weak FirstViewController *weakSelf = self;
        [[DBFilesystem sharedFilesystem] addObserver:self forPathAndChildren:[[DBPath root] childPath:@"iAccount"] block:^{
            
            [weakSelf loadFiles];
        }];
        //add observer to the iAccount file
        
    }
    
}

- (void)loadFiles {
    
    
    if (self.loadingFiles) return;
    self.loadingFiles  =YES;
    NSLog(@"loading files %d", self.loadingFiles);
    
    //using GCD to cache the data from Dropbox
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^() {
        
        
        
        DBPath *newPath = [[DBPath root] childPath:@"iAccount"];

        DBPath *itemPath = [newPath childPath:@"items.plist"];
        [[DBFilesystem sharedFilesystem] openFile:itemPath error:nil];
        
        DBPath *mapPath = [newPath childPath:@"map.plist"];
        [[DBFilesystem sharedFilesystem] openFile:mapPath error:nil];
        
        DBPath *timelinePath = [newPath childPath:@"timeline.plist"];
        [[DBFilesystem sharedFilesystem] openFile:timelinePath error:nil];
        
        [self reload];
        //load data to the arrays
    
        dispatch_async(dispatch_get_main_queue(), ^() {
            
            //update UI to views in main thread
            [[DBFilesystem sharedFilesystem] removeObserver:self];
            
            [self.mainTableView reloadData];
            
            self.loadingFiles = NO;
            
        });
    });
}

-(void)reload{
    
    if ([self filesExistAtLocal]) {
        //if files exist at local
        //data merge
        if([self filesExistOnCloud]){//if data exist on Cloud
            [self mergeData];
        }
        else{
            //files exist only in local
            [self writeLocalToCloud];
        }
    }
    else{
        [self writeFilesToLocal];
        //handled situation 1, 4
        //if the files are not existed at local, will be fetched from Dropbox
        //if the files are not at Dropbox, too. Create files at Dropbox and download them
    }
    
    
}


-(BOOL)filesExistAtLocal{
    
    NSURL *itemUrl = [FileSession getListURLOf:@"items.plist"];
    if ([itemUrl checkResourceIsReachableAndReturnError:nil] == NO)
    {
        NSLog(@"items list not exists");
     return false;
    }
    
    NSURL *mapUrl = [FileSession getListURLOf:@"map.plist"];
    if ([mapUrl checkResourceIsReachableAndReturnError:nil] == NO)
    {
        NSLog(@"map list not exists");
        return false;
    }
    NSURL *timelineUrl = [FileSession getListURLOf:@"timeline.plist"];
    if ([timelineUrl checkResourceIsReachableAndReturnError:nil] == NO)
    {
        NSLog(@"timeline list not exists");
        return false;
    }
    
    NSLog(@"File existed at local");
    return true;
}

-(BOOL)filesExistOnCloud{
    
    DBPath *newPath = [[DBPath root] childPath:@"iAccount"];
    
    DBPath *itemPath = [newPath childPath:@"items.plist"];
    
    DBFileInfo *itemInfo = [[DBFilesystem sharedFilesystem] fileInfoForPath:itemPath error:nil];
    
    if (itemInfo == nil) {
        NSLog(@"item list not exist on cloud");
        return false;
    }
    
    DBPath *mapPath = [newPath childPath:@"map.plist"];
    
    DBFileInfo *mapInfo = [[DBFilesystem sharedFilesystem] fileInfoForPath:mapPath error:nil];
    
    if (mapInfo == nil) {
         NSLog(@"map list not exist on cloud");
        return false;
    }
    
    DBPath *timelinePath = [newPath childPath:@"timeline.plist"];
    
    DBFileInfo *timelineInfo = [[DBFilesystem sharedFilesystem] fileInfoForPath:timelinePath error:nil];
    
    if (timelineInfo == nil) {
         NSLog(@"timeline list not exist on cloud");
        return false;
    }
    
    return true;
}


//if there's nothing local, get from cloud, and save a copy to local
-(void)writeFilesToLocal{
    //create files if not exists
    
    DBPath *newPath = [[DBPath root] childPath:@"iAccount"];

    
    DBPath *itemPath = [newPath childPath:@"items.plist"];
    DBFile *itemFile = [[DBFilesystem sharedFilesystem] openFile:itemPath error:nil];
    
    if (itemFile == nil) {
    itemFile = [[DBFilesystem sharedFilesystem] createFile:itemPath error:nil];
    }
    
    NSURL *itemUrl = [FileSession getListURLOf:@"items.plist"];
    NSData *itemData =[itemFile readData:nil];
    // this is the data from
    [FileSession writeData:itemData ToList:itemUrl];
    //get the copy from Dropbox Cloud to local
    
    
    DBPath *mapPath = [newPath childPath:@"map.plist"];
    DBFile *mapFile = [[DBFilesystem sharedFilesystem] openFile:mapPath error:nil];
    
    if (mapFile == nil) {
        mapFile = [[DBFilesystem sharedFilesystem] createFile:itemPath error:nil];
    }
    
    NSURL *mapUrl = [FileSession getListURLOf:@"map.plist"];
    NSData *mapData =[mapFile readData:nil];
    // this is the data from
    [FileSession writeData:mapData ToList:mapUrl];
    //get the copy from Dropbox Cloud to local
    
    
    DBPath *timelinePath = [newPath childPath:@"timeline.plist"];
    DBFile *timelineFile = [[DBFilesystem sharedFilesystem] openFile:timelinePath error:nil];
    
    if (timelineFile == nil) {
        timelineFile = [[DBFilesystem sharedFilesystem] createFile:itemPath error:nil];
    }
    
    NSURL *timelineUrl = [FileSession getListURLOf:@"timeline.plist"];
    NSData *timelineData =[timelineFile readData:nil];
    // this is the data from
    [FileSession writeData:timelineData ToList:timelineUrl];
    //get the copy from Dropbox Cloud to local
    
    
}


//write data from local files to cloud, if data exist at local, but nothing on the cloud
-(void)writeLocalToCloud{
    NSLog(@"write local to cloud");
    DBPath *newPath = [[DBPath root] childPath:@"iAccount"];
    
    DBPath *itemPath = [newPath childPath:@"items.plist"];
    DBFile *itemFile = [[DBFilesystem sharedFilesystem] createFile:itemPath error:nil];
    
    DBPath *mapPath = [newPath childPath:@"map.plist"];
    DBFile *mapFile = [[DBFilesystem sharedFilesystem] createFile:mapPath error:nil];
    
    DBPath *timelinePath = [newPath childPath:@"timeline.plist"];
    DBFile *timelineFile = [[DBFilesystem sharedFilesystem] createFile:timelinePath error:nil];
    
    NSURL *itemUrl = [FileSession getListURLOf:@"items.plist"];
    [itemFile writeData:[NSData dataWithContentsOfURL:itemUrl] error:nil];
    
    NSURL *mapUrl = [FileSession getListURLOf:@"map.plist"];
    [mapFile writeData:[NSData dataWithContentsOfURL:mapUrl] error:nil];
    
    NSURL *timelineUrl = [FileSession getListURLOf:@"timeline.plist"];
    [timelineFile writeData:[NSData dataWithContentsOfURL:timelineUrl] error:nil];
}


-(void)mergeData{
    NSLog(@"merging data");
    
    DBPath *newPath = [[DBPath root] childPath:@"iAccount"];
    
    DBPath *itemPath = [newPath childPath:@"items.plist"];
    DBFile *itemFile = [[DBFilesystem sharedFilesystem] openFile:itemPath error:nil];
    NSData *itemData =[itemFile readData:nil];
    
    NSURL *itemUrl = [FileSession getListURLOf:@"items.plist"];
    self.itemArray = [NSMutableArray arrayWithArray:[FileSession readDataFromList:itemUrl]];
    NSLog(@"itemArray count: %lu", (unsigned long)self.itemArray.count);
    NSArray *temp1 = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:itemData];
    
    NSLog(@"item Array on cloud count: %lu", (unsigned long)temp1.count);
    [self.itemArray addObjectsFromArray: temp1];
    
    NSData* sessionDataItem = [NSKeyedArchiver archivedDataWithRootObject:self.itemArray];
    [itemFile writeData:sessionDataItem error:nil];
    [FileSession writeData:self.itemArray ToList:itemUrl];
    
    
    DBPath *mapPath = [newPath childPath:@"map.plist"];
    DBFile *mapFile = [[DBFilesystem sharedFilesystem] openFile:mapPath error:nil];
    NSData *mapData =[mapFile readData:nil];
    
    NSURL *mapUrl = [FileSession getListURLOf:@"map.plist"];
    self.map = [NSMutableArray arrayWithArray:[FileSession readDataFromList:mapUrl]];
    NSLog(@"mapArray count: %lu", (unsigned long)self.map.count);

    NSArray *temp2 = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:mapData];
    
    NSLog(@"mapArray on cloud count: %lu", (unsigned long)temp2.count);

    [self.map addObjectsFromArray: temp2];
    
    NSData* sessionDataMap = [NSKeyedArchiver archivedDataWithRootObject:self.map];
    [mapFile writeData:sessionDataMap error:nil];
    [FileSession writeData:self.map ToList:mapUrl];
    
    
    
    DBPath *timelinePath = [newPath childPath:@"timeline.plist"];
    DBFile *timelineFile = [[DBFilesystem sharedFilesystem] openFile:timelinePath error:nil];
    NSData *timelineData =[timelineFile readData:nil];
    
    NSURL *timelineUrl = [FileSession getListURLOf:@"timeline.plist"];
    self.timeline = [NSMutableArray arrayWithArray:[FileSession readDataFromList:timelineUrl]];
    NSLog(@"timeline Array count: %lu", (unsigned long)self.timeline.count);

    NSArray *temp3 = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:timelineData];
    NSLog(@"timeline Array count on cloud: %lu", (unsigned long)temp3.count);

    [self.timeline addObjectsFromArray: temp3];
    
    NSData* sessionDataTimeline = [NSKeyedArchiver archivedDataWithRootObject:self.timeline];
    [timelineFile writeData:sessionDataTimeline error:nil];
    [FileSession writeData:self.timeline ToList:timelineUrl];
    
}


@end
