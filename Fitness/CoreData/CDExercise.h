//
//  CDExercise.h
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDTraining;

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
    ExerciseTypePause,
    ExerciseTypeCount
};


@interface CDExercise : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic) enum ExerciseType type;
@property (nonatomic, retain) NSNumber * warmup;
@property (nonatomic, retain) NSNumber * interval;
@property (nonatomic, retain) CDTraining *training;

+ (NSDictionary *)exerciseTypes;
+ (NSString *)exerciseTypeToString:(enum ExerciseType)type;

@end
