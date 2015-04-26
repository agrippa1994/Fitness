//
//  CDTraining.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import "Training.h"
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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    
    DECODE_OBJ(self.name, aDecoder);
    DECODE_OBJ(self.exercises, aDecoder);
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    Training *newObject = [[self class] allocWithZone:zone];
    
    newObject->_name = [self.name copyWithZone:zone];
    newObject->_exercises = [[NSMutableArray allocWithZone:zone] initWithArray:self.exercises copyItems:YES];
    
    return newObject;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    Training *newObject = [[self class] allocWithZone:zone];
    
    newObject->_name = [self.name mutableCopyWithZone:zone];
    newObject->_exercises = [[NSMutableArray allocWithZone:zone] initWithArray:self.exercises copyItems:YES];
    
    return newObject;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    ENCODE_OBJ(self.name, aCoder);
    ENCODE_OBJ(self.exercises, aCoder);
}

@end
