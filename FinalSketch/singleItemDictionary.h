//
//  singleItemDictionary.h
//  FinalSketch
//
//  Created by xiaoyifan on 3/5/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface singleItemDictionary : NSMutableDictionary

@property NSString* itemTitle;

@property NSString* itemDescription;

@property UIImage* image;

@property NSString* itemCategory;

@property CLLocation *itemLocation;

@property NSDate *itemDate;

@property double itemPrice;

//set basic properties for the single item


-(void)initWithTitle: (NSString *)title
      andDescription:(NSString *)description
      andImage:(UIImage *)image
      andCategory:(NSString *)category
      andlocation:(CLLocation *)location
      andDate:(NSDate *)date
      andPrice:(double)price;

@end
