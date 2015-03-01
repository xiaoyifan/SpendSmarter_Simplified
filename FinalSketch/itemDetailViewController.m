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

@interface itemDetailViewController ()<CLLocationManagerDelegate>

@end

@implementation itemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mainScrollView.delegate = self;
    self.mainScrollView.scrollEnabled = YES;
    //self.mainScrollView.contentSize = self.view.frame.size;
    
    self.itemImage.image = [UIImage imageNamed:@"superstar.png"];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
    
    
    self.mapView.showsUserLocation = YES;
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    CLLocationCoordinate2D zoomLocation;
//    zoomLocation.latitude = 39.281516;
//    zoomLocation.longitude= -76.580806;
//    
//    // 2
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
//    
//    // 3
//    [self.mapView setRegion:viewRegion animated:YES];
//}

- (void)viewDidLayoutSubviews {
    [self.mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1150)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse|| status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager setDistanceFilter:100];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setHeadingFilter:kCLDistanceFilterNone];
        self.locationManager.activityType = CLActivityTypeFitness;
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[CLLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
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
