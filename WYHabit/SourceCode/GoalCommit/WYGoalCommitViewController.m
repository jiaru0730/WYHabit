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

#define kRadiusOfMyGoalView 24

#define kDoneSectionScaleReset          2.0f
#define kDoneSectionScaleExtended       2.7f
#define kDoneSectionEquationSlope       0.25
#define kDoneSectionEquationIntercept   392

@interface WYGoalCommitViewController ()

@property (strong, nonatomic) NSArray *myGoalButtons;
@property (assign, nonatomic, getter = isDraggingGoalInDoneSection) BOOL draggingGoalInDoneSection;
@property (strong, nonatomic) UIView *doneSectionRing;

@property (strong, nonatomic) UIButton *editButton;
@property (strong, nonatomic) UIButton *optionButton;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@property (assign, nonatomic) NSInteger selectedIndex;
@property (assign, nonatomic) CommitViewStatus *viewStatus;

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
    
    self.view.backgroundColor = [UIColor blackColor];
    [self drawEditButton];
    [self drawDoneSectionRing];
    [self drawDoneButton];
    [self drawMyGoalButtons];

    
//    [self drawOptionButton];
    self.viewStatus = CommitViewModeCommit;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Drawing

- (void)drawDoneButton {
    self.doneButton.backgroundColor = UI_COLOR_GREEN_GRASS;
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.doneButton.clipsToBounds = YES;
    self.doneButton.layer.cornerRadius = kRadiusOfDoneButton;
    self.doneButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.doneButton addTarget:self action:@selector(enterEditModeAnimated) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:self.doneButton];
}

- (void)drawEditButton {
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = self.doneButton.frame;
    [self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    self.editButton.backgroundColor = UI_COLOR_ORANGE;
    self.editButton.clipsToBounds = YES;
    self.editButton.layer.cornerRadius = kRadiusOfDoneButton;
    self.editButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.editButton addTarget:self action:@selector(cancelEditModeAnimated) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editButton];
}

- (void)drawMyGoalButtons {
    NSMutableArray *mutableMyGoalButtons = [NSMutableArray arrayWithCapacity:kAmountOfMyGoals];
    CGFloat horizontalMargin = 14;
    CGFloat horizontalSpacing = (UI_SCREEN_WIDTH - (kAmountOfMyGoals * 2 * kRadiusOfMyGoalView) - (2 * horizontalMargin)) / (kAmountOfMyGoals - 1);
    CGFloat yOfMyGoalViews = UI_SCREEN_HEIGHT - 75;
    for (int i = 0; i < kAmountOfMyGoals; ++i) {
        WYMyGoalView *eachMyGoalView = [[WYMyGoalView alloc] initWithFrame:CGRectMake((horizontalMargin + i * (horizontalSpacing + 2 *kRadiusOfMyGoalView)), yOfMyGoalViews, 2 * kRadiusOfMyGoalView, 2 * kRadiusOfMyGoalView)];
        eachMyGoalView.goalIndexInContainer = i;
        eachMyGoalView.backgroundColor = UI_COLOR_ORANGE;
        eachMyGoalView.radius = kRadiusOfMyGoalView;
        eachMyGoalView.clipsToBounds = YES;
        eachMyGoalView.layer.cornerRadius = kRadiusOfMyGoalView;
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [eachMyGoalView addGestureRecognizer:self.panGestureRecognizer];
        [self.view addSubview:eachMyGoalView];
    }
    self.myGoalButtons = mutableMyGoalButtons;
}

- (void)drawDoneSectionRing {
    UIView *doneSectionRing = [[UIView alloc] initWithFrame:self.doneButton.frame];
    doneSectionRing.clipsToBounds = YES;
    CALayer *doneSectionRingLayer = doneSectionRing.layer;
    doneSectionRingLayer.cornerRadius = kRadiusOfDoneButton;
    doneSectionRingLayer.borderWidth = 2;
    doneSectionRingLayer.borderColor = UI_COLOR_GREEN_GRASS.CGColor;
    doneSectionRingLayer.anchorPoint = CGPointMake(0.5, 0.5);
    doneSectionRing.backgroundColor = [UIColor clearColor];
    [self.view addSubview:doneSectionRing];
    self.doneSectionRing = doneSectionRing;
}

- (void)drawOptionButton {
    UIButton *optionButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    optionButton.center = CGPointMake(UI_SCREEN_WIDTH - 35, 35);
    optionButton.tintColor = UI_COLOR_GREEN_GRASS;
    [optionButton addTarget:self action:@selector(optionButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:optionButton];
    self.optionButton = optionButton;
}

#pragma mark - Done Section

- (void)dragGoalEnterDoneSection {
    [self extendDoneSectionRingAnimated];
}

- (void)dragGoalExitDoneSection {
    [self resetScaleOfDoneSectionRingAnimated];
}

- (void)extendDoneSectionRingAnimated {
    self.doneSectionRing.alpha = 0.0f;
    self.doneSectionRing.transform = CGAffineTransformMakeScale(kDoneSectionScaleReset, kDoneSectionScaleReset);
    [UIView animateWithDuration:kAnimationDurationShort animations:^(void) {
        self.doneSectionRing.alpha = 1.0f;
        self.doneSectionRing.transform = CGAffineTransformMakeScale(kDoneSectionScaleExtended, kDoneSectionScaleExtended);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)resetScaleOfDoneSectionRingAnimated {
    [UIView animateWithDuration:kAnimationDurationShort animations:^(void) {
        self.doneSectionRing.alpha = 0.0f;
        self.doneSectionRing.transform = CGAffineTransformMakeScale(kDoneSectionScaleReset, kDoneSectionScaleReset);
    }completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Edit model

- (void)enterEditModeAnimated {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.7;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    
    
    [[self.doneButton layer] addAnimation:animation forKey:@"animation"];
    [[self.editButton layer] addAnimation:animation forKey:@"animation"];
    
    [self.view exchangeSubviewAtIndex:[self.view.subviews indexOfObject:self.doneButton] withSubviewAtIndex:[self.view.subviews indexOfObject:self.editButton]];
}

- (void)cancelEditModeAnimated {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.7;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    
    [self.view exchangeSubviewAtIndex:[self.view.subviews indexOfObject:self.doneButton] withSubviewAtIndex:[self.view.subviews indexOfObject:self.editButton]];
    
    [[self.doneButton layer] addAnimation:animation forKey:@"animation"];
    [[self.editButton layer] addAnimation:animation forKey:@"animation"];
}

#pragma mark - Other

- (void)pan:(UILongPressGestureRecognizer *)sender {
    WYMyGoalView *senderView = (WYMyGoalView *)sender.view;
    CGPoint locationInGoalCommitView = [sender locationInView:self.view];
    self.selectedIndex = senderView.goalIndexInContainer;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
//            [self extendDoneSectionRingAnimated];
            break;
        }

        case UIGestureRecognizerStateChanged: {
            if (NO == self.draggingGoalInDoneSection) {
                if ([self isDragUpInsideDoneSection:locationInGoalCommitView]) {
                    self.draggingGoalInDoneSection = YES;
                    [self dragGoalEnterDoneSection];
                }
            } else {
                if (![self isDragUpInsideDoneSection:locationInGoalCommitView]) {
                    self.draggingGoalInDoneSection = NO;
                    [self dragGoalExitDoneSection];
                }
            }
            senderView.center = locationInGoalCommitView;
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            [self resetScaleOfDoneSectionRingAnimated];
        }
        default:
            break;
    }
}

- (BOOL)isDragUpInsideDoneSection:(CGPoint)touchPoint {
    CGFloat calX = touchPoint.x;
    CGFloat calY = touchPoint.y;
    return (calY < kDoneSectionEquationSlope * calX + kDoneSectionEquationIntercept) && (calY < (kDoneSectionEquationIntercept + kDoneSectionEquationIntercept * kDoneSectionEquationSlope) - kDoneSectionEquationSlope * calX);
}

- (void)optionButtonPressed:(id)sender {
    [self enterEditModeAnimated];
}

@end
