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

@property NSMutableDictionary* itemCategory;

@property CLLocation *itemLocation;

@property NSString *locationDescription;

@property NSString *itemDate;

@property NSString * itemPrice;

//set basic properties for the single item



-(instancetype)initWithTitle: (NSString *)title
      andDescription:(NSString *)description
      andImage:(UIImage *)image
      andCategory:(NSMutableDictionary *)category
      andlocation:(CLLocation *)location
      andLocationDescription: (NSString *)locationDescription
      andDate:(NSString *)date
      andPrice:(NSString *)price;

@end
