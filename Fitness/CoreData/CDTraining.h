//
//  CDTraining.h
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDExercise;

@interface CDTraining : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *exercises;
@end

@interface CDTraining (CoreDataGeneratedAccessors)

- (void)addExercisesObject:(CDExercise *)value;
- (void)removeExercisesObject:(CDExercise *)value;
- (void)addExercises:(NSSet *)values;
- (void)removeExercises:(NSSet *)values;

@end
