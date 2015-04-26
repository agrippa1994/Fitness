//
//  TrainingTableViewCell.h
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrainingTableViewCell;

@protocol TrainingTableViewCellDelegate
- (void)trainingTableViewCell:(TrainingTableViewCell *)cell didEnteredText:(NSString *)text;
@end

@interface TrainingTableViewCell : UITableViewCell
@property(weak) id<TrainingTableViewCellDelegate> delegate;

- (NSString *)inputText;
- (void)setInputText:(NSString *)text;

@end
