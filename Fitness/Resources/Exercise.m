//
//  Exercise.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import "Exercise.h"
#import "Training.h"
#import "Helpers.h"

@interface Exercise () <NSCoding, NSCopying, NSMutableCopying>

+ (NSDictionary *)exerciseTypes;

@end

@implementation Exercise

- (id)init {
    self = [super init];
    
    self.type = 0;
    self.warmup = @5;
    self.interval = @60;
    
    return self;
}

#pragma mark NSCoding Protocol
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    
    DECODE_ENUM(self.type, aDecoder);
    DECODE_OBJ(self.warmup, aDecoder);
    DECODE_OBJ(self.interval, aDecoder);
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    ENCODE_ENUM(self.type, aCoder);
    ENCODE_OBJ(self.warmup, aCoder);
    ENCODE_OBJ(self.interval, aCoder);
}

#pragma mark NSCopying Protocol
- (id)copyWithZone:(NSZone *)zone {
    Exercise *newObject = [[self class] allocWithZone:zone];
    
    newObject->_type = self.type;
    newObject->_warmup = [self.warmup copyWithZone:zone];
    newObject->_interval = [self.interval copyWithZone:zone];
    
    return newObject;
}

#pragma mark NSMutableCopying Protocol
- (id)mutableCopyWithZone:(NSZone *)zone {
    Exercise *newObject = [[self class] allocWithZone:zone];
    
    newObject->_type = self.type;
    newObject->_warmup = [self.warmup copyWithZone:zone];
    newObject->_interval = [self.interval copyWithZone:zone];
    
    return newObject;
}

#pragma mark Methods
+ (NSDictionary *)exerciseTypes {
    return @{
             @(ExerciseTypeRunning): @"Laufen",
             @(ExerciseTypeBreast): @"Brust",
             @(ExerciseTypeBack): @"Rücken",
             @(ExerciseTypeTriceps): @"Trizeps",
             @(ExerciseTypeBiceps): @"Bizeps",
             @(ExerciseTypeLegs): @"Beine",
             @(ExerciseTypeCalves): @"Waden",
             @(ExerciseTypeShoulders): @"Schultern",
             @(ExerciseTypeStomach): @"Bauch",
             @(ExerciseTypeLowerBack): @"Kreuz",
             @(ExerciseTypePause): @"Pause"
    };
}
+ (NSString *)exerciseTypeToString:(enum ExerciseType)type {
    if(type < 0 || type >= ExerciseTypeCount)
        return @"";
    
    return [[self exerciseTypes] objectForKey:@(type)];
}

@end
