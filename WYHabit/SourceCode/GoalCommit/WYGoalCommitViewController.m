//
//  WYGoalCommitViewController.m
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYGoalCommitViewController.h"


#define kRadiusOfGoalButton 100

@interface WYGoalCommitViewController ()

@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation WYGoalCommitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.goalButton.backgroundColor = [UIColor orangeColor];
    [self.goalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.goalButton.clipsToBounds = YES;
    self.goalButton.layer.cornerRadius = kRadiusOfGoalButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
