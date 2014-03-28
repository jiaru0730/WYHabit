//
//  WYAllGoalStatisticsViewController.h
//  WYHabit
//
//  Created by Jia Ru on 3/28/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYAllGoalDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *charContainerView;
@property (weak, nonatomic) IBOutlet UITableView *allGoalDetailTableView;

@end
