//
//  singleItemDictionary.m
//  FinalSketch
//
//  Created by xiaoyifan on 3/5/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "singleItemDictionary.h"

@implementation singleItemDictionary


-(void)initWithTitle: (NSString *)title
      andDescription:(NSString *)description
            andImage:(UIImage *)image
         andCategory:(NSString *)category
         andlocation:(CLLocation *)location
             andDate:(NSDate *)date
            andPrice:(double)price{
    
    
    [self setObject:self.itemTitle forKey:@"title"];
    [self setObject:self.itemDescription forKey:@"description"];
    [self setObject:self.image forKey:@"image"];
    [self setObject:self.itemCategory forKey:@"category"];
    [self setObject:self.itemLocation forKey:@"location"];
    [self setObject:self.itemDate forKey:@"date"];

    
}

@end
