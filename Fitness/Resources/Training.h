//
//  Training.h
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORKOrderedTask;

@interface Training : NSObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSMutableArray *exercises;

- (NSTimeInterval)exerciseDuration;
- (ORKOrderedTask *)trainingTask;

@end
