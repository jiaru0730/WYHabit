//
//  WYGoalTimeLineViewController.h
//  WYHabit
//
//  Created by Jia Ru on 3/29/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYGoalTimeLineViewController : UITableViewController

@property (assign, nonatomic) BOOL isPresented;

- (id)initWithGoal:(NSString *)goalID;


@end
