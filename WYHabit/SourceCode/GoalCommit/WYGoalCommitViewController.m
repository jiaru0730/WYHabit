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

#define kDragRatioK         300
#define kDoneSectionScale   2.7

@interface WYGoalCommitViewController ()

@property (strong, nonatomic) NSArray *myGoalButtons;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (assign, nonatomic, getter = isDraggingGoalInDoneSection) BOOL draggingGoalInDoneSection;
@property (strong, nonatomic) UIView *doneSectionRing;

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
    
    [self drawDoneSectionRing];
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
    self.doneButton.backgroundColor = [UIColor greenColor];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.doneButton.clipsToBounds = YES;
    self.doneButton.layer.cornerRadius = kRadiusOfDoneButton;
    [self.doneButton addTarget:self action:@selector(dragGoalEnterDoneSection) forControlEvents:UIControlEventTouchDown];
    [self.view bringSubviewToFront:self.doneButton];
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
        self.longPressAndDragGoalGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAndDrag:)];
        [eachMyGoalView addGestureRecognizer:self.longPressAndDragGoalGestureRecognizer];
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
    doneSectionRingLayer.borderColor = [UIColor greenColor].CGColor;
    doneSectionRingLayer.anchorPoint = CGPointMake(0.5, 0.5);
    doneSectionRing.backgroundColor = [UIColor clearColor];
    [self.view addSubview:doneSectionRing];
    self.doneSectionRing = doneSectionRing;
}

#pragma mark - Responser

- (void)dragGoalEnterDoneSection {
    [self extendDoneSectionRingAnimated];
}

- (void)dragGoalExitDoneSection {
    [self resetScaleOfDoneSectionRingAnimated];
}

- (void)extendDoneSectionRingAnimated {
    self.doneSectionRing.alpha = 0.0f;
    [UIView animateWithDuration:kAnimationDurationShort animations:^(void) {
        self.doneSectionRing.alpha = 1.0f;
        self.doneSectionRing.transform = CGAffineTransformMakeScale(kDoneSectionScale, kDoneSectionScale);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)resetScaleOfDoneSectionRingAnimated {
    [UIView animateWithDuration:kAnimationDurationShort animations:^(void) {
        self.doneSectionRing.alpha = 0.0f;
        self.doneSectionRing.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }completion:^(BOOL finished) {
        
    }];
}

- (void)longPressAndDrag:(UILongPressGestureRecognizer *)sender {
    WYMyGoalView *senderView = (WYMyGoalView *)sender.view;
    CGPoint locationInGoalCommitView = [sender locationInView:self.view];
    self.selectedIndex = senderView.goalIndexInContainer;
    NSLog(@"x=%f, y=%f", locationInGoalCommitView.x, locationInGoalCommitView.y);
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {

            break;
        }

        case UIGestureRecognizerStateChanged: {
            if (NO == self.draggingGoalInDoneSection) {
                if ([self isDragUpInsideDoneSection:locationInGoalCommitView]) {
                    NSLog(@"EnterDoneSection.");
                    self.draggingGoalInDoneSection = YES;
                    [self dragGoalEnterDoneSection];
                }
            } else {
                if (![self isDragUpInsideDoneSection:locationInGoalCommitView]) {
                    NSLog(@"ExitDoneSection.");
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
    return (calY < calX + kDragRatioK) && calY < (2 * kDragRatioK - calX);
}

@end
