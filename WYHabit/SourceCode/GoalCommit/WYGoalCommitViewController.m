//
//  WYGoalCommitViewController.m
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYGoalCommitViewController.h"

#import "WYMyGoalView.h"
#import "WYUIContants.h"

#define kAmountOfMyGoals    5
#define kRadiusOfDoneButton 100

#define kRadiusOfMyGoalView 25

@interface WYGoalCommitViewController ()

@property (strong, nonatomic) NSArray *myGoalButtons;
@property (assign, nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) UIGestureRecognizer *longPressAndDragGoalGestureRecognizer;

@end

@implementation WYGoalCommitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self drawDoneButton];
    [self drawMyGoalButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Drawing

- (void)drawDoneButton {
    self.doneButton.backgroundColor = [UIColor orangeColor];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.doneButton.clipsToBounds = YES;
    self.doneButton.layer.cornerRadius = kRadiusOfDoneButton;
}

- (void)drawMyGoalButtons {
    NSMutableArray *mutableMyGoalButtons = [NSMutableArray arrayWithCapacity:kAmountOfMyGoals];
    CGFloat horizontalMargin = 20;
    CGFloat horizontalSpacing = (UI_SCREEN_WIDTH - (kAmountOfMyGoals * 2 * kRadiusOfMyGoalView) - (2 * horizontalMargin)) / (kAmountOfMyGoals - 1);
    CGFloat yOfMyGoalViews = UI_SCREEN_HEIGHT - 75;
    for (int i = 0; i < kAmountOfMyGoals; ++i) {
        WYMyGoalView *eachMyGoalView = [[WYMyGoalView alloc] initWithFrame:CGRectMake((horizontalMargin + i * (horizontalSpacing + 2 *kRadiusOfMyGoalView)), yOfMyGoalViews, 2 * kRadiusOfMyGoalView, 2 * kRadiusOfMyGoalView)];
        eachMyGoalView.goalIndexInContainer = i;
        eachMyGoalView.backgroundColor = [UIColor orangeColor];
        eachMyGoalView.radius = kRadiusOfMyGoalView;
        eachMyGoalView.clipsToBounds = YES;
        eachMyGoalView.layer.cornerRadius = kRadiusOfMyGoalView;
        self.longPressAndDragGoalGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [eachMyGoalView addGestureRecognizer:self.longPressAndDragGoalGestureRecognizer];
        [self.view addSubview:eachMyGoalView];
    }
    self.myGoalButtons = mutableMyGoalButtons;
}

#pragma mark - Responser

- (void)didDraggingIntoDoneButton:(UIButton *)sender {
    self.doneButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
}

- (void)longPress:(UILongPressGestureRecognizer *)sender {
    WYMyGoalView *senderView = (WYMyGoalView *)sender.view;
    CGPoint locationInGoalCommitView = [sender locationInView:self.view];
    self.selectedIndex = senderView.goalIndexInContainer;
//    NSLog(@"x=%f, y=%f", locationInGoalCommitView.x, locationInGoalCommitView.y);
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {

            break;
        }

        case UIGestureRecognizerStateChanged: {
            senderView.center = locationInGoalCommitView;
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
//            [self.doneButton removeTarget:self action:@selector(draggingIntoDoneButton:) forControlEvents:UIControlEventTouchDragEnter];
        }
        default:
            break;
    }
}

@end
