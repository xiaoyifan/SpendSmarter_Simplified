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


@interface itemDetailViewController ()<CLLocationManagerDelegate, CKCalendarDelegate,MKMapViewDelegate>

@end

@implementation itemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mainScrollView.delegate = self;
    self.mainScrollView.scrollEnabled = YES;
    //self.mainScrollView.contentSize = self.view.frame.size;
    
    self.itemImage.image = self.detailItem.image;
    self.dateLabel.text  =self.detailItem.date;
    self.itemTitle.text  =self.detailItem.title;
    self.itemDescription.text = self.detailItem.description;

    
    
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
{
    if ( !self.initialLocation )
    {
        self.initialLocation = userLocation.location;
        
        MKCoordinateRegion region;
        region.center = mapView.userLocation.coordinate;
        region.span = MKCoordinateSpanMake(0.1, 0.1);
        
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
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


- (IBAction)mapViewLongTapToDropPin:(UILongPressGestureRecognizer *)sender {
 
    NSLog(@"The map view is tapped");
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    // Then all you have to do is create the annotation and add it to the map
    
    CLLocationCoordinate2D coordinates;
        coordinates.latitude = locCoord.latitude;
        coordinates.longitude =locCoord.longitude;
    
    for (MyLocation *annotation in self.mapView.annotations) {
        
        if ((annotation.coordinate.latitude == coordinates.latitude)&&(annotation.coordinate.longitude == coordinates.longitude) ) {
            return;
        }
        else{
                [self.mapView removeAnnotation:annotation];
            MyLocation *annotation = [[MyLocation alloc] initWithName:@"Address" address:@"" coordinate:coordinates];
            [self.mapView addAnnotation:annotation];
        }
        
    }
    //long tap to add the droppin in the mapView
    //the pin won't be added to the same point twice
    
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
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];

}



@end
