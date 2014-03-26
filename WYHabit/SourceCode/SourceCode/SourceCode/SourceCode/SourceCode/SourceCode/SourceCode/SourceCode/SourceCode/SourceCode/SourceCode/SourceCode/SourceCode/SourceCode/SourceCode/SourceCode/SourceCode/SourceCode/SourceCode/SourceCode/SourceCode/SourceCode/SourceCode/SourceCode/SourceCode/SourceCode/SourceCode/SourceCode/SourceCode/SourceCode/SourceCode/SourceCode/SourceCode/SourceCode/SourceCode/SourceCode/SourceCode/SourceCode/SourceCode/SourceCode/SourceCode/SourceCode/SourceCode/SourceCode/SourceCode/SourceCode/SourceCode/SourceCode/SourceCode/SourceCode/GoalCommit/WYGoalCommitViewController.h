//
//  WYGoalCommitViewController.h

//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum CommitViewMode : NSUInteger
{
    CommitViewModeCommit = 0,
    CommitViewModeEdit = 1,
} CommitViewStatus;

@interface WYGoalCommitViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *doneButton;


@end
