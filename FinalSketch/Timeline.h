//
//  Timeline.h
//  FinalSketch
//
//  Created by xiaoyifan on 3/11/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timeline : NSObject<NSCoding>
@property (strong, nonatomic) NSString *timelabel;
@property (strong, nonatomic) NSNumber *dailyAmount;

@end
