//
//  Exercise.h
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import <Foundation/Foundation.h>


enum ExerciseType: int16_t {
    ExerciseTypeRunning = 0,
    ExerciseTypeBreast,
    ExerciseTypeBack,
    ExerciseTypeTriceps,
    ExerciseTypeBiceps,
    ExerciseTypeLegs,
    ExerciseTypeCalves,
    ExerciseTypeShoulders,
    ExerciseTypeStomach,
    ExerciseTypeLowerBack,
    ExerciseTypePause,
    ExerciseTypeCount
};


@interface Exercise : NSObject

@property (nonatomic) enum ExerciseType type;
@property (nonatomic, retain) NSNumber * warmup;
@property (nonatomic, retain) NSNumber * interval;

+ (NSString *)exerciseTypeToString:(enum ExerciseType)type;

@end
