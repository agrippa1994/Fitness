//
//  Storage.m
//  Fitness
//
//  Created by Mani on 25.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import "Storage.h"

#define KEY "trainings"

@implementation Storage

#pragma mark Methods
+ (NSMutableArray *)trainings {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@KEY];
    if(data == nil)
        return [NSMutableArray array];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (BOOL)saveTrainings:(NSArray *)trainings {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:trainings];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@KEY];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
