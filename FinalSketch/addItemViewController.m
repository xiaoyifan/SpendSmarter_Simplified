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


@interface addItemViewController()<CKCalendarDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate, MKMapViewDelegate>

@property BOOL inputingDecimal;
@property int decimalCount;

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
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue{
    
    mapViewController *source = [segue sourceViewController];
    CLLocation *itemLocation = source.selectedLocation;
    NSString *address = source.selectedLocationAddress;
    self.itemLocation = [[CLLocation alloc] initWithLatitude:itemLocation.coordinate.latitude longitude:itemLocation.coordinate.longitude];
    
    NSLog(@"the selected location is: %f, %f", self.itemLocation.coordinate.latitude, self.itemLocation.coordinate.longitude);

    
    
    if (itemLocation != nil) {
        self.locationLabel.text = [NSString stringWithFormat:@"%@",address];
    }
    
}

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
    
    self.priceLabel.text = [self.priceLabel.text substringWithRange:NSMakeRange(0, self.priceLabel.text.length-2)];
    
}


- (IBAction)doneIsTapped:(id)sender {
    //Save the data first
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    Item *newItem = [[Item alloc] init];
    
    newItem.title = @"New Item";
    newItem.itemDescription = @"essentials";
    newItem.date = self.dateLabel.text;
    newItem.image = self.smallImageView.image;
    newItem.category = self.categorySelected;
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
    newItem.price = self.priceLabel.text;
    
    
    NSURL *fileURL = [FileSession getListURLOf:@"items.plist"];

    NSMutableArray *itemArray = [NSMutableArray arrayWithArray:[FileSession readDataFromList:fileURL]];

    [itemArray addObject:newItem];
    
    [FileSession writeData:itemArray ToList:fileURL];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic = [self.categoryArray objectAtIndex:indexPath.row];
    NSString *description = [dic objectForKey:@"description"];
    self.categoryImageView.image = [dic objectForKey:@"pic"];
    self.categoryPic = [dic objectForKey:@"pic"];
    self.categorySelected = description;

    NSLog(@"%@", description);

}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(50, 50, 50, 50);
}

#pragma mark - dismiss the view controller
- (IBAction)back:(id)sender {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];

}


#pragma mark - picture taking and delegate
- (IBAction)TakingPicture:(id)sender {
    
    UIImagePickerController *camera = [[UIImagePickerController alloc]init];
    
    camera.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    NSString *desired = (NSString *)kUTTypeImage;
    if ([[UIImagePickerController availableMediaTypesForSourceType:camera.sourceType] containsObject:desired]) {
        camera.mediaTypes  = @[desired];
    }
    
    camera.allowsEditing = YES;
    [self presentViewController:camera animated:YES completion:nil];
    
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }

    
    UIImageWriteToSavedPhotosAlbum(image, nil,nil, NULL);
    
    [self dismissViewControllerAnimated:YES
                             completion:^(void){
                                 
                                 self.smallImageView.image = image;
                                 
                                 NSLog(@"the photo is taken");
                                 
                             }];
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)camera{
    
    [self dismissViewControllerAnimated:YES
                             completion:^(void){
                                 
                                 NSLog(@"the photo taking is cancelled.");
                                 
                             }];
    
}


#pragma mark - calendar function and delegate
- (IBAction)showCalendar:(id)sender {
    
    CKCalendarView *calendar = [[CKCalendarView alloc] init];
    calendar.center  = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:calendar];
    calendar.delegate = self;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    self.dateLabel.text = [NSString stringWithFormat:@"%@",date];
    //    [calendar removeFromSuperview];
}


@end
