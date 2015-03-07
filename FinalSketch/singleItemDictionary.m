//
//  singleItemDictionary.m
//  FinalSketch
//
//  Created by xiaoyifan on 3/5/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "singleItemDictionary.h"

@implementation singleItemDictionary


-(instancetype)initWithTitle: (NSString *)title
      andDescription:(NSString *)description
            andImage:(UIImage *)image
         andCategory:(NSMutableDictionary *)category
         andlocation:(CLLocation *)location
            andLocationDescription: (NSString *)locationDescription
             andDate:(NSString *)date
            andPrice:(NSString *)price{
    
    self.itemTitle = title;
    self.itemDescription = description;
    self.image = image;
    self.itemCategory = category;
    self.itemLocation = location;
    self.locationDescription  = locationDescription;
    self.itemDate = date;
    self.itemPrice = price;
    
    
    [self setObject:self.itemTitle forKey:@"title"];
    [self setObject:self.itemDescription forKey:@"description"];
    [self setObject:self.image forKey:@"image"];
    [self setObject:self.itemCategory forKey:@"category"];
    [self setObject:self.itemLocation forKey:@"location"];
    [self setObject:self.locationDescription forKey:@"locationDescription"];
    [self setObject:self.itemDate forKey:@"date"];
    [self setObject:self.itemPrice forKey:@"price"];

    
    return self;
}

@end
