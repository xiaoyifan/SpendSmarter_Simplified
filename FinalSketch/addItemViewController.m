//
//  addItemViewController.m
//  FinalSketch
//
//  Created by XiaoYifan on 2/28/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "addItemViewController.h"
#import "CKCalendarView.h"
#import <MobileCoreServices/MobileCoreServices.h>



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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue{
    
    mapViewController *source = [segue sourceViewController];
    CLLocation *itemLocation = source.selectedLocation;
    NSString *address = source.selectedLocationAddress;
    NSLog(@"the selected location is: %f, %f", itemLocation.coordinate.latitude, itemLocation.coordinate.longitude);
    
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
    
//    singleItemDictionary *newItem = [singleItemDictionary alloc] initWithTitle:self.title
//                                                                 andDescription:self.description
//                                                                 andImage:self.smallImageView.image
//                                                                 andCategory:self.category
//                                                                 andlocation:self.location
//                                                                 andDate:self.date
//                                                                 andPrice:self.price];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    
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
