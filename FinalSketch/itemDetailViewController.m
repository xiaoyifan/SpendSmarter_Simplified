//
//  itemDetailViewController.m
//  FinalSketch
//
//  Created by xiaoyifan on 2/27/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//
#define METERS_PER_MILE 1609.344

#import "itemDetailViewController.h"
#import "FirstViewController.h"
#import "CKCalendarView.h"
#import "KLCPopup.h"
#import "AHKActionSheet.h"
#import <Social/Social.h>


@interface itemDetailViewController ()<CLLocationManagerDelegate, CKCalendarDelegate,MKMapViewDelegate>

@property (nonatomic, strong) KLCPopup *calendarPopup;

@property (weak, nonatomic) IBOutlet UILabel *noImageLabel;



@end

@implementation itemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mainScrollView.delegate = self;
    self.mainScrollView.scrollEnabled = YES;
    //self.mainScrollView.contentSize = self.view.frame.size;
    
    if (self.detailItem.image != nil) {
        self.itemImage.image = self.detailItem.image;
        self.noImageLabel.hidden = YES;
    }
    self.itemImage.backgroundColor = [self randomColor];
    self.dateLabel.text  =self.detailItem.date;
    self.itemTitle.text  =self.detailItem.title;
    self.itemDescription.text = self.detailItem.itemDescription;
    
    //The location will be initialized in the delegate
    
    
    //Location settings
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;

    
}



- (void)viewDidLayoutSubviews {
    [self.mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1450)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - calendar



-(void)didPressDismiss{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - location service implementation

- (IBAction)myLocation:(id)sender {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    NSLog(@"My location %f, %f", region.center.latitude, region.center.longitude);

    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse|| status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager setDistanceFilter:100];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setHeadingFilter:kCLDistanceFilterNone];
        self.locationManager.activityType = CLActivityTypeFitness;
        
        [self.locationManager startUpdatingLocation];
    }
    else if(status == kCLAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loacation serice not authorized" message:@"This app needs you to authorize locations service to work" delegate:nil cancelButtonTitle:@"Gotcha" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else{
        NSLog(@"wrong location status");
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray
                                                                         *)locations
{ 
    NSLog(@"%@", locations); 
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError
                                                                       *)error
{ 
    NSLog(@"Could not find location: %@", error); 
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{NSLog(@"self location: %@", self.detailItem.location);
    if ( !self.initialLocation )
    {
        MKCoordinateRegion region;
        if (!self.detailItem.location) {
            self.initialLocation = self.mapView.userLocation.location;
            region.center = self.mapView.userLocation.location.coordinate;
        }
        else{
            self.initialLocation = self.detailItem.location;
            region.center = self.detailItem.location.coordinate;
        }
        
        region.span = MKCoordinateSpanMake(0.1, 0.1);
        
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
        
         MyLocation *annotation = [[MyLocation alloc] initWithName:[NSString stringWithFormat:@"$%@", [self.detailItem.price stringValue]]
                                                           address:self.detailItem.locationDescription
                                                        coordinate:self.detailItem.location.coordinate];
        
        

        [self.mapView addAnnotation:annotation];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    static NSString *identifier = @"MyLocation";
    
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MyLocation *location = (MyLocation *) annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [theMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:location reuseIdentifier:identifier];
        } else {
            annotationView.annotation = location;
        }
        
        // Set the pin properties
        annotationView.animatesDrop = YES;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
    }
    
    return nil;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"%@ %@",view,control);
}


#pragma mark-geo fencing
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exit Regions:%@",region);
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Goodbye";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Enter region:%@",region);
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Hello";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


- (IBAction)back:(id)sender {
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionReveal;
//    transition.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)actionSheetTouched:(id)sender {
    
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:NSLocalizedString(@"Wanna share this item to friends?", nil)];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Facebook", nil)
                              image:[UIImage imageNamed:@"facebook"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                NSLog(@"Favorite tapped");
                                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                                    SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                                    
                                    NSString *text = [NSString stringWithFormat:@"I just bought %@ at date %@. Cost me $%@ and it's cool!", self.itemTitle.text, self.dateLabel.text, self.detailItem.price];
                                    [facebookPost setInitialText:text];
                                    [facebookPost addImage:self.detailItem.image];
                                    [self presentViewController:facebookPost animated:YES completion:nil];
                                }
                                else{
                                    UIAlertView *alertView = [[UIAlertView alloc]
                                                              initWithTitle:@"Sorry"
                                                              message:@"You can't send a Facebook post now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                                              delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Twitter", nil)
                              image:[UIImage imageNamed:@"twitter"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                NSLog(@"Share tapped");
                                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                                    SLComposeViewController *twitterPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                                    
                                    NSString *text = [NSString stringWithFormat:@"I just bought %@ at date %@. Cost me $%@ and it's cool!", self.itemTitle.text, self.dateLabel.text, self.detailItem.price];
                                    [twitterPost setInitialText:text];
                                    [twitterPost addImage:self.detailItem.image];
                                    [self presentViewController:twitterPost animated:YES completion:nil];
                                }
                                else{
                                    UIAlertView *alertView = [[UIAlertView alloc]
                                                              initWithTitle:@"Sorry"
                                                              message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                                              delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Weibo", nil)
                              image:[UIImage imageNamed:@"weibo"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                NSLog(@"Share tapped");
                                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
                                    SLComposeViewController *weiboPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
                                    
                                    NSString *text = [NSString stringWithFormat:@"I just bought %@ at date %@. Cost me $%@ and it's cool!", self.itemTitle.text, self.dateLabel.text, self.detailItem.price];
                                    [weiboPost setInitialText:text];
                                    [weiboPost addImage:self.detailItem.image];
                                    
                                    [self presentViewController:weiboPost animated:YES completion:nil];
                                }
                                else{
                                    UIAlertView *alertView = [[UIAlertView alloc]
                                                              initWithTitle:@"Sorry"
                                                              message:@"You can't send a weibo right now, make sure your device has an internet connection and you have at least one Weibo account setup"
                                                              delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }];

    [actionSheet show];
    
}

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


@end
