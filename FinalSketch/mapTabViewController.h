//
//  mapTabViewController.h
//  FinalSketch
//
//  Created by XiaoYifan on 3/12/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyLocation.h"

@interface mapTabViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;


@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) CLLocation* initialLocation;

@property (nonatomic, strong) NSMutableArray *itemArray;


@end
