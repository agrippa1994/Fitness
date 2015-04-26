//
//  Exercise.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import <ResearchKit/ResearchKit.h>
#import <ResearchKit/ORKCountdownStep.h>
#import <ResearchKit/ORKWalkingTaskStep.h>
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

#pragma mark Static Methods
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

#pragma mark Dynamic Methods
- (NSArray *)createResearchKitTasks {
    ORKInstructionStep *instructionStep = [[ORKInstructionStep alloc] initWithIdentifier:@"task"];
    instructionStep.title = [[self class] exerciseTypeToString: self.type];
    
    ORKCountdownStep *countdown = [[ORKCountdownStep alloc] initWithIdentifier:@"countdown"];
    countdown.stepDuration = [self.warmup integerValue];
    countdown.shouldPlaySoundOnFinish = YES;
    countdown.shouldSpeakCountDown = YES;
    countdown.title = @"Vorbereitung";
    countdown.text = @"Bereite dich auf die Übung vor";
    
    ORKCountdownStep *training = [[ORKCountdownStep alloc] initWithIdentifier:@"training"];
    training.stepDuration = [self.interval integerValue];
    training.shouldPlaySoundOnFinish = YES;
    training.shouldSpeakCountDown = YES;
    training.title = [[self class] exerciseTypeToString: self.type];
    training.subtitle = @"";
    
    return @[instructionStep, countdown, training];
}

@end
