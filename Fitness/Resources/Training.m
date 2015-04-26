//
//  Training.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import <ResearchKit/ResearchKit.h>
#import "Training.h"
#import "Exercise.h"
#import "Helpers.h"

@interface Training () <NSCoding, NSCopying, NSMutableCopying>

@end

@implementation Training

- (id)init {
    self = [super init];
    
    self.name = @"";
    self.exercises = [NSMutableArray array];
    
    return self;
}

#pragma mark NSCoding Protocol
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    
    DECODE_OBJ(self.name, aDecoder);
    DECODE_OBJ(self.exercises, aDecoder);
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    ENCODE_OBJ(self.name, aCoder);
    ENCODE_OBJ(self.exercises, aCoder);
}

#pragma mark NSCopying Protocol
- (id)copyWithZone:(NSZone *)zone {
    Training *newObject = [[self class] allocWithZone:zone];
    
    newObject->_name = [self.name copyWithZone:zone];
    newObject->_exercises = [[NSMutableArray allocWithZone:zone] initWithArray:self.exercises copyItems:YES];
    
    return newObject;
}

#pragma mark NSMutableCopying Protocol
- (id)mutableCopyWithZone:(NSZone *)zone {
    Training *newObject = [[self class] allocWithZone:zone];
    
    newObject->_name = [self.name mutableCopyWithZone:zone];
    newObject->_exercises = [[NSMutableArray allocWithZone:zone] initWithArray:self.exercises copyItems:YES];
    
    return newObject;
}

#pragma mark Methods
- (NSTimeInterval)exerciseDuration {
    NSTimeInterval duration = 0;
    
    for(Exercise *exercise in self.exercises)
        duration += [exercise.interval integerValue];
    
    return duration;
}

- (ORKOrderedTask *)trainingTask {
    NSMutableArray *exerciseTasks = [NSMutableArray array];
    
    for(Exercise *exercise in self.exercises)
        for(ORKStep *step in [exercise createResearchKitTasks])
            [exerciseTasks addObject:step];
    
    return [[ORKOrderedTask alloc] initWithIdentifier:@"trainingTask" steps:exerciseTasks];
}

@end
