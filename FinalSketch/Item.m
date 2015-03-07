//
//  Article.m
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/20/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "Item.h"

@implementation Item


//Implement the encoding method
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.itemDescription forKey:@"description"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.category forKey:@"category"];
    [encoder encodeObject:self.categoryPic forKey:@"categoryPic"];
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:self.locationDescription forKey:@"locationDescription"];
    [encoder encodeObject:self.price forKey:@"price"];
    
}

//implement the decoding method
- (id) initWithCoder:(NSCoder *)decoder {
    self = [super init];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.itemDescription = [decoder decodeObjectForKey:@"description"];
    self.date = [decoder decodeObjectForKey:@"date"];
    self.image = [decoder decodeObjectForKey:@"image"];
    self.category = [decoder decodeObjectForKey:@"category"];
    self.categoryPic = [decoder decodeObjectForKey:@"categoryPic"];
    self.location = [decoder decodeObjectForKey:@"location"];
    self.locationDescription = [decoder decodeObjectForKey:@"locationDescription"];
    self.price = [decoder decodeObjectForKey:@"price"];

    return self;
}

@end
