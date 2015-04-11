//
//  addItemViewController.m
//  FinalSketch
//
//  Created by XiaoYifan on 2/28/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "FileSession.h"
#import "addItemViewController.h"
#import "CKCalendarView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "categoryArrayInitializer.h"
#import "CameraSessionView.h"
#import "KLCPopup.h"
#import "SpendSmarter-Swift.h"




@interface addItemViewController()<CKCalendarDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate, MKMapViewDelegate, CACameraSessionDelegate, UIAlertViewDelegate>

@property BOOL inputingDecimal;
@property int decimalCount;

@property (nonatomic, strong) CameraSessionView *cameraView;
@property (nonatomic, strong) KLCPopup *calendarPopup;

@property CGPoint mainOperationViewCenter;

@property (weak, nonatomic) IBOutlet UIView *mainOperationView;

@property (weak, nonatomic) IBOutlet KaedeTextField *titleField;


@property (weak, nonatomic) IBOutlet KaedeTextField *descriptionField;

@property (weak, nonatomic) IBOutlet UIView *networkView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *savingIndicator;


@end

@implementation addItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputingDecimal = false;
    self.decimalCount = 0;
    // Do any additional setup after loading the view.

    categoryArrayInitializer *initializer = [[categoryArrayInitializer alloc] init];
    
    self.categoryArray = [initializer getTheCategories];
    //the category array contains the catogories
    [self.collectionView reloadData];
    
    
    self.titleField.delegate  =self;
    self.descriptionField.delegate = self;
    
    self.networkView.hidden  = YES;
    
}

-(void)viewDidAppear:(BOOL)animated{
    self.mainOperationViewCenter = self.mainOperationView.center;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// press add info to type in the title and description
- (IBAction)pressedInfo:(id)sender {
    
    NSLog(@"info button tapped");
    [self.mainOperationView setTranslatesAutoresizingMaskIntoConstraints:YES];

    NSLog(@"center is: %f", self.mainOperationView.center.y);
    NSLog(@"original center is: %f", self.mainOperationViewCenter.y);
    
    if (self.mainOperationViewCenter.y == self.mainOperationView.center.y) {
        
    // the animation will scroll down the top view layer
    [UIView animateWithDuration:0.5 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                       
                             self.mainOperationView.center = CGPointMake(self.mainOperationView.center.x, self.mainOperationView.center.y+200);
   
                         
                     }
                     completion:^(BOOL completed){
                         
                         NSLog(@"center is: %f", self.mainOperationView.center.y);
                         NSLog(@"original center is: %f", self.mainOperationViewCenter.y);
                         self.mainOperationView.center = CGPointMake(self.mainOperationViewCenter.x, self.mainOperationViewCenter.y+200);
                         NSLog(@"center is: %f", self.mainOperationView.center.y);
                         NSLog(@"original center is: %f", self.mainOperationViewCenter.y);
                     }
     ];
    }
    
}

//if the title and description is typed in, you can press done to move up the main view
- (IBAction)pressDone:(id)sender {
    
    [self.titleField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    [self.mainOperationView setTranslatesAutoresizingMaskIntoConstraints:YES];

    
    if (self.mainOperationViewCenter.y != self.mainOperationView.center.y) {
  
    //if the title stuff is done, tao down will cause the top view layer move up to the original position
    [UIView animateWithDuration:0.5 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.mainOperationView.center = CGPointMake(self.mainOperationViewCenter.x, self.mainOperationViewCenter.y);
                         
                     }
                     completion:^(BOOL completed){
                        
                     }
     ];
    }
}




//unwind segue
- (IBAction)unwindToList:(UIStoryboardSegue *)segue{
    
    mapViewController *source = [segue sourceViewController];
    CLLocation *itemLocation = source.selectedLocation;
    NSString *address = source.selectedLocationAddress;
    self.itemLocation = [[CLLocation alloc] initWithLatitude:itemLocation.coordinate.latitude longitude:itemLocation.coordinate.longitude];
    //assign the location to the add view controller, this is the location data from the map view controller
    
    NSLog(@"the selected location is: %f, %f", self.itemLocation.coordinate.latitude, self.itemLocation.coordinate.longitude);

    if (itemLocation != nil) {
        self.locationLabel.text = [NSString stringWithFormat:@"%@",address];
    }
    
}


#pragma mark - buttons taped

//tap the number
- (IBAction)numberTapped:(id)sender {
    
    
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = button.currentTitle;
    //get the input characters
    
    if (buttonTitle.length<=9) {
         NSString *priceString = self.priceLabel.text;
        
        priceString = [priceString stringByAppendingString:buttonTitle];
        
        self.priceLabel.text = priceString;
        
    }
    // just add number
}

- (IBAction)clearButtonTapped:(id)sender {
    
    self.priceLabel.text = @"$";
}

- (IBAction)decimalDotTapped:(id)sender {
     self.priceLabel.text = [self.priceLabel.text stringByAppendingString:@"."];
}


- (IBAction)removeOneCharTapped:(id)sender {
    if ([self.priceLabel.text isEqualToString:@"$"]) {
    }
    else{
    self.priceLabel.text = [self.priceLabel.text substringWithRange:NSMakeRange(0, self.priceLabel.text.length-1)];
    }
}

//save the data
- (IBAction)doneIsTapped:(id)sender {
    //Save the data first
    
    
    //the data cannot be empty
    if ([self.priceLabel.text isEqualToString:@"$"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Price field required"
                                                        message:@"you should enter the price field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    self.networkView.hidden = NO;
    [self.savingIndicator startAnimating];
    //save the data to the array, then sync it to Dropbox and local plist
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
        
        [self addItemWithAttributes];
        
        dispatch_async(dispatch_get_main_queue(), ^() {
            
            [self dismissViewControllerAnimated:YES completion:nil];

            self.networkView.hidden = YES;
            [self.savingIndicator stopAnimating];
        });
    });
    
    
}

//get the properties from the addViewController
-(void)addItemWithAttributes{
    
    Item *newItem = [[Item alloc] init];
    
    if (self.titleField.text.length == 0) {
        newItem.title = @"New Item";
    }
    else{
        newItem.title = self.titleField.text;
    }
    
    if (self.descriptionField.text.length == 0) {
        newItem.itemDescription = @"essentials";
    }
    else{
        newItem.itemDescription = self.descriptionField.text;
        
    }
    
    if (self.dateLabel.text.length!=0) {
        newItem.date = self.dateLabel.text;
    }
    else{
        NSDate *today = [[NSDate alloc] init];
        NSDateFormatter *dateformat = [[NSDateFormatter alloc]init];
        [dateformat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [dateformat stringFromDate:today];
        newItem.date = dateStr;
    }
    //Pick the date or default date
    
    if (self.smallImageView.image!=nil) {
        
        newItem.image = self.smallImageView.image;
    }
    else{
        newItem.image = nil;
    }
    
    //if no image added, just set to nil, add default image in the cell
    
    newItem.category = self.categorySelected;
    NSLog(@"The selected category is %@", self.categorySelected);
    newItem.categoryPic = self.categoryPic;
    
    if (self.itemLocation != nil) {
        newItem.location = [[CLLocation alloc] initWithLatitude:self.itemLocation.coordinate.latitude
                                                      longitude:self.itemLocation.coordinate.longitude];
    }
    else{
        newItem.location = nil;
        
    }
    
    NSLog(@"added location: %f, %f", self.itemLocation.coordinate.latitude, self.itemLocation.coordinate.longitude);
    
    newItem.locationDescription = self.locationLabel.text;
    
    NSString *priceLabel = [self.priceLabel.text substringFromIndex:1];
    newItem.price = [[NSNumber alloc] initWithDouble:[priceLabel doubleValue]];
    
    
    NSURL *fileURL = [FileSession getListURLOf:@"items.plist"];
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithArray:[FileSession readDataFromList:fileURL]];
    
    [itemArray insertObject:newItem atIndex:0];
    
    [FileSession writeData:itemArray ToList:fileURL];
    
    [self addToMap];
    [self addToTimeline];
    
    
    self.account = [[DBAccountManager sharedManager] linkedAccount];
    //check fi there's a linked account
    
    
    //if the account is linked, data will be linked to Dropbox
    if (self.account) {
        NSLog(@"write to the cloud");
        [self writeLocalToCloud];
    }
    
}

//write the files to cloud, we gonna write three lists to cloud
-(void)writeLocalToCloud{
    NSLog(@"write local to cloud");
    DBPath *newPath = [[DBPath root] childPath:@"iAccount"];
    
    DBPath *itemPath = [newPath childPath:@"items.plist"];
    DBFile *itemFile = [[DBFilesystem sharedFilesystem] openFile:itemPath error:nil];
    
    DBPath *mapPath = [newPath childPath:@"map.plist"];
    DBFile *mapFile = [[DBFilesystem sharedFilesystem] openFile:mapPath error:nil];
    
    DBPath *timelinePath = [newPath childPath:@"timeline.plist"];
    DBFile *timelineFile = [[DBFilesystem sharedFilesystem] openFile:timelinePath error:nil];
    
    NSURL *itemUrl = [FileSession getListURLOf:@"items.plist"];
    [itemFile writeData:[NSData dataWithContentsOfURL:itemUrl] error:nil];
    
    NSURL *mapUrl = [FileSession getListURLOf:@"map.plist"];
    [mapFile writeData:[NSData dataWithContentsOfURL:mapUrl] error:nil];
    
    NSURL *timelineUrl = [FileSession getListURLOf:@"timeline.plist"];
    [timelineFile writeData:[NSData dataWithContentsOfURL:timelineUrl] error:nil];
}


//add the item to the map array, items are dictionary of locations
-(void) addToMap{
    
    NSURL *mapURL = [FileSession getListURLOf:@"map.plist"];
    
    NSMutableArray *mapArray = [NSMutableArray arrayWithArray:[FileSession readDataFromList:mapURL]];
    
    int flag = 0;
    
    NSString *priceLabel = [self.priceLabel.text substringFromIndex:1];
    NSNumber *price = [[NSNumber alloc] initWithDouble:[priceLabel doubleValue]];
    
    for (Map *obj in mapArray) {
        if ([self.categorySelected isEqualToString:obj.categoryString]) {
            flag = 1;

            obj.itemNumber = @([obj.itemNumber integerValue]+[price doubleValue]);
            //if category existed, add 1
        }
    }
    
    if (flag == 0) {
        Map *mapItem = [[Map alloc] init];
        mapItem.itemNumber = price;
        mapItem.categoryString = self.categorySelected;
        [mapArray addObject:mapItem];
    }
    
    [FileSession writeData:mapArray ToList:mapURL];
    
}


//add to timeline, timeline array contains items with dictionary with date and price. 
-(void) addToTimeline{
    
    NSURL *timelineURL = [FileSession getListURLOf:@"timeline.plist"];
    
    NSMutableArray *timelineArray = [NSMutableArray arrayWithArray:[FileSession readDataFromList:timelineURL]];
    
    int flag = 0;
    
    NSString *priceLabel = [self.priceLabel.text substringFromIndex:1];
    NSNumber *price = [[NSNumber alloc] initWithDouble:[priceLabel doubleValue]];
    
    for (Timeline *obj in timelineArray) {
        if ([self.dateLabel.text isEqualToString:obj.timelabel]) {
            flag = 1;
            
            obj.dailyAmount = @([obj.dailyAmount integerValue]+[price doubleValue]);
            //if category existed, add 1
           
        }
    }
    
    if (flag == 0) {
        Timeline *dailyItem = [[Timeline alloc] init];
        dailyItem.dailyAmount = price;
        dailyItem.timelabel = self.dateLabel.text;
        [timelineArray addObject:dailyItem];
    }
    
    [FileSession writeData:timelineArray ToList:timelineURL];
    
}


#pragma mark - collection view delegate implementation


- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
//    return [sectionArray count];
    return self.categoryArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [[UIColor clearColor]CGColor];
    UIImageView *image = [[UIImageView alloc]init];
    NSMutableDictionary *dic = [self.categoryArray objectAtIndex:indexPath.row];
    self.categorySelected  = [dic objectForKey:@"description"];
    self.categoryPic = [dic objectForKey:@"pic"];
    
    image.image = [dic objectForKey:@"pic"];
    image.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    [cell addSubview:image];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat side = (self.view.frame.size.width-80)/5.0;
    return CGSizeMake(side, side);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic = [self.categoryArray objectAtIndex:indexPath.row];
    NSString *description = [dic objectForKey:@"description"];
    self.categoryImageView.image = [dic objectForKey:@"pic"];
    self.categoryPic = [dic objectForKey:@"pic"];
    self.categorySelected = description;

    NSLog(@"%@", description);
    

}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 40, 10, 40);
}

#pragma mark - dismiss the view controller
- (IBAction)back:(id)sender {
    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.6;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromTop;
//    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - picture taking and delegate
- (IBAction)TakingPicture:(id)sender {
    
    self.cameraView = [[CameraSessionView alloc] initWithFrame:self.view.frame];
    self.cameraView.delegate = self;
    [self.cameraView setTopBarColor:[UIColor colorWithRed:61/255.0 green:154/255.0 blue:232/255.0 alpha: 0.64]];

    [self.navigationController setNavigationBarHidden: YES animated:YES];
    
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.6];
    [applicationLoadViewIn setType:kCATransitionFromLeft];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[self.cameraView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionFromLeft];
    
    [self.view bringSubviewToFront:self.cameraView];

    [self.view addSubview:self.cameraView];
    
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //Show error alert if image could not be saved
    [self.navigationController setNavigationBarHidden: NO animated:YES];

    if (error) [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

-(void)didCaptureImage:(UIImage *)image {
    //Use the image that is received
    
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width != height) {
        CGFloat newDimension = MIN(width, height);
        CGFloat widthOffset = (width - newDimension) / 2;
        CGFloat heightOffset = (height - newDimension) / 2;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
        [image drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                       blendMode:kCGBlendModeCopy
                           alpha:1.];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    self.smallImageView.image = image;
    [self.navigationController setNavigationBarHidden: NO animated:YES];
    

    NSLog(@"the photo is taken");
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
    [self.cameraView removeFromSuperview];
}

-(void)didPressDismiss{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - calendar function and delegate
- (IBAction)showCalendar:(id)sender {
    
    CKCalendarView *calendar = [[CKCalendarView alloc] init];
    
    
//    calendar.center  = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
//    [self.view addSubview:calendar];
    calendar.delegate = self;
    
    self.calendarPopup = [KLCPopup popupWithContentView:calendar
                                               showType: KLCPopupShowTypeSlideInFromLeft
                                            dismissType: KLCPopupDismissTypeSlideOutToRight
                                               maskType: KLCPopupMaskTypeDimmed
                               dismissOnBackgroundTouch:YES
                                  dismissOnContentTouch:NO];
    [self.calendarPopup show];
    
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateformat stringFromDate:date];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",dateStr];
    //    [calendar removeFromSuperview];
    [self.calendarPopup dismiss:YES];
}

#pragma mark - textFieldDeleagate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //NSLog(@"return key pressed");
    if (textField == self.titleField || textField == self.descriptionField) {
        [textField resignFirstResponder];
        //the Keyboard is the first responder, should be resigned
    }
    return YES;
    
}


@end
