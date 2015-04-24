//
//  CDExercise.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import "CDExercise.h"
#import "CDTraining.h"


@implementation CDExercise

@dynamic index;
@dynamic type;
@dynamic warmup;
@dynamic interval;
@dynamic training;

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
             @(ExerciseTypePause): @"Pause"
    };
}
+ (NSString *)exerciseTypeToString:(enum ExerciseType)type {
    if(type < 0 || type >= ExerciseTypeCount)
        return @"";
    
    return [[self exerciseTypes] objectForKey:@(type)];
}

@end
