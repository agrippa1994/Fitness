//
//  Storage.h
//  Fitness
//
//  Created by Mani on 25.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Storage : NSObject

+ (NSMutableArray *)trainings;
+ (BOOL)saveTrainings:(NSArray *)trainings;

@end
