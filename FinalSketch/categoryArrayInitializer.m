//
//  categoryArrayInitializer.m
//  FinalSketch
//
//  Created by xiaoyifan on 3/6/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "categoryArrayInitializer.h"

@interface categoryArrayInitializer()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation categoryArrayInitializer

-(instancetype)init{
    
    self.array  =[[NSMutableArray alloc] init];
    
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:@"food" forKey:@"description"];
    [dic1 setObject:[UIImage imageNamed:@"food"] forKey:@"pic"];
    
    [self.array insertObject:dic1 atIndex:0];
    
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:@"clothing" forKey:@"description"];
    [dic2 setObject:[UIImage imageNamed:@"clothing"] forKey:@"pic"];
    
    [self.array insertObject:dic2 atIndex:0];
    
    NSMutableDictionary *dic3 = [[NSMutableDictionary alloc] init];
    [dic3 setObject:@"electronics" forKey:@"description"];
    [dic3 setObject:[UIImage imageNamed:@"electronics"] forKey:@"pic"];
    
    [self.array insertObject:dic3 atIndex:0];
    
    NSMutableDictionary *dic4 = [[NSMutableDictionary alloc] init];
    [dic4 setObject:@"housing" forKey:@"description"];
    [dic4 setObject:[UIImage imageNamed:@"housing"] forKey:@"pic"];
    
    [self.array insertObject:dic4 atIndex:0];
    
    NSMutableDictionary *dic5 = [[NSMutableDictionary alloc] init];
    [dic5 setObject:@"music" forKey:@"description"];
    [dic5 setObject:[UIImage imageNamed:@"music"] forKey:@"pic"];
    
    [self.array insertObject:dic5 atIndex:0];
    
    NSMutableDictionary *dic6 = [[NSMutableDictionary alloc] init];
    [dic6 setObject:@"book" forKey:@"description"];
    [dic6 setObject:[UIImage imageNamed:@"book"] forKey:@"pic"];
    
    [self.array insertObject:dic6 atIndex:0];
    
    NSMutableDictionary *dic7 = [[NSMutableDictionary alloc] init];
    [dic7 setObject:@"trip" forKey:@"description"];
    [dic7 setObject:[UIImage imageNamed:@"trip"] forKey:@"pic"];
    
    [self.array insertObject:dic7 atIndex:0];
    
    NSMutableDictionary *dic8 = [[NSMutableDictionary alloc] init];
    [dic8 setObject:@"investment" forKey:@"description"];
    [dic8 setObject:[UIImage imageNamed:@"investment"] forKey:@"pic"];
    
    [self.array insertObject:dic8 atIndex:0];
    
    NSMutableDictionary *dic9 = [[NSMutableDictionary alloc] init];
    [dic9 setObject:@"entertainment" forKey:@"description"];
    [dic9 setObject:[UIImage imageNamed:@"entertainment"] forKey:@"pic"];
    
    [self.array insertObject:dic9 atIndex:0];
    
    NSMutableDictionary *dic10 = [[NSMutableDictionary alloc] init];
    [dic10 setObject:@"transportation" forKey:@"description"];
    [dic10 setObject:[UIImage imageNamed:@"transportation"] forKey:@"pic"];
    
    [self.array insertObject:dic10 atIndex:0];
    
    
    NSMutableDictionary *dic11 = [[NSMutableDictionary alloc] init];
    [dic11 setObject:@"medical" forKey:@"description"];
    [dic11 setObject:[UIImage imageNamed:@"medical"] forKey:@"pic"];
    
    [self.array insertObject:dic11 atIndex:0];
    
    NSMutableDictionary *dic12 = [[NSMutableDictionary alloc] init];
    [dic12 setObject:@"tax" forKey:@"description"];
    [dic12 setObject:[UIImage imageNamed:@"tax"] forKey:@"pic"];
    
    [self.array insertObject:dic12 atIndex:0];
    
    NSMutableDictionary *dic13 = [[NSMutableDictionary alloc] init];
    [dic13 setObject:@"study" forKey:@"description"];
    [dic13 setObject:[UIImage imageNamed:@"study"] forKey:@"pic"];
    
    [self.array insertObject:dic13 atIndex:0];
    
    NSMutableDictionary *dic14 = [[NSMutableDictionary alloc] init];
    [dic14 setObject:@"beauty" forKey:@"description"];
    [dic14 setObject:[UIImage imageNamed:@"beauty"] forKey:@"pic"];
    
    [self.array insertObject:dic14 atIndex:0];
    
    
    NSMutableDictionary *dic15 = [[NSMutableDictionary alloc] init];
    [dic15 setObject:@"kids" forKey:@"description"];
    [dic15 setObject:[UIImage imageNamed:@"kids"] forKey:@"pic"];
    
    [self.array insertObject:dic15 atIndex:0];
    
    
    NSMutableDictionary *dic16 = [[NSMutableDictionary alloc] init];
    [dic16 setObject:@"other" forKey:@"description"];
    [dic16 setObject:[UIImage imageNamed:@"other"] forKey:@"pic"];
    
    [self.array insertObject:dic16 atIndex:0];
    
    return self;
}


-(NSMutableArray *)getTheCategories{
    
    return self.array;
}

@end
