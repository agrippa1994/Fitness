//
//  Exercise.h
//  Kraft-Ausdauer
//
//  Created by Mani on 12.03.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Training;

typedef enum : int16_t {
    ExerciseTypeRunning
} ExerciseType;

@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic) ExerciseType type;
@property (nonatomic, retain) Training *training;

@end
