//
//  WYMainContainerViewController.m
//  WYHabit
//
//  Created by Jia Ru on 3/26/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYMainContainerViewController.h"
#import "ITTCalendarView.h"
#import "ITTBaseDataSourceImp.h"
#import "WYDataManager.h"
#import "WYGoalInMainViewModel.h"
#import "WYAllGoalDetailsViewController.h"
#import "WYUIElementManager.h"
#import "WYToggleButton.h"
#import "WYGoalTimeLineViewController.h"

static const int kCommitButtonSectionHeight = 250;
static const int kCommitButtonTopMargin = 40;
static const int kCommitButtonRedius = 200;

static const int kTextHeight = 70;

static const int kCalendarTopMargin = 30;
static const int kCalendarHeight = 280;
//static const int kLineChratTopSpacingToCalendar = 30;
//static const int kLineChartHeight = 255;
//static const int kChartsSectionHeight = kCalendarTopMargin + kCalendarHeight + kLineChratTopSpacingToCalendar + kLineChartHeight;
static const int kChartsSectionHeight = kCalendarTopMargin + kCalendarHeight;

static const int kOperationSectionHeight = 100;
static const int kOperationButtonRadius = 80;
static const int kOperationButtonSideMargin = 10;

static const int kAddGoalOKAndCancelButtonY = 190;

@interface WYMainContainerViewController ()

// UI elements
@property (strong, nonatomic) UIScrollView *mainContainerScrollView;
@property (strong, nonatomic) UIScrollView *addGoalView;
@property (strong, nonatomic) UIButton *addGoalButton;
@property (strong, nonatomic) UITextField *addGoalActionNameTextField;
@property (strong, nonatomic) UIButton *addGoalOKButton;
@property (strong, nonatomic) UIButton *addGoalCancelButton;
@property (strong, nonatomic) UINavigationController *allGoalDetailsNavigationController;

@property (strong, nonatomic) NSMutableArray *elementGoalViewList;
@property (strong, nonatomic) NSArray *liveGoalViewModelList;
@property (strong, nonatomic) NSArray *elementScrollViewList;
@property (assign, nonatomic) int currentPageIndex;

// this is not used
//@property (strong, nonatomic) UIPageControl *mainContainerPageControl;

@end

@implementation WYMainContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _liveGoalViewModelList = [[WYDataManager sharedInstance] getMainViewLiveGoalViewModelList];
        _currentPageIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self drawMainContainerScrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyRefreshGoalMetaData:) name:kNotifyRefreshGoalMetaData object:nil];
}

- (void)drawMainContainerScrollView {
    self.mainContainerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    self.mainContainerScrollView.pagingEnabled = YES;
    [self.view addSubview:self.mainContainerScrollView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CGSize sizeOfMainScrollView = self.mainContainerScrollView.frame.size;
    self.mainContainerScrollView.contentSize = CGSizeMake(sizeOfMainScrollView.width * (self.liveGoalViewModelList.count + 1), sizeOfMainScrollView.height);
    self.mainContainerScrollView.delegate = self;
    
    NSMutableArray *mutableScrollViewList = [NSMutableArray array];
    for (int i = 0; i <= self.liveGoalViewModelList.count; ++i) {
        UIScrollView *elementScrollView = nil;
        if (i < self.liveGoalViewModelList.count) {
            elementScrollView = [self drawVerticalScrollViewByGoal:[self.liveGoalViewModelList objectAtIndex:i]];
            [self.elementGoalViewList addObject:elementScrollView];
        } else if (i == self.liveGoalViewModelList.count) {
            elementScrollView = [self drawAddGoalView];
        }
        
        CGRect frameOfSingleGoalView = (CGRect){.origin=CGPointMake(sizeOfMainScrollView.width * i, 0), .size=sizeOfMainScrollView};
        elementScrollView.frame = frameOfSingleGoalView;
        [self.mainContainerScrollView addSubview:elementScrollView];
        
        if (i % 2 == 0) {
            elementScrollView.backgroundColor = [UIColor whiteColor];
        } else {
            elementScrollView.backgroundColor = UI_COLOR_MAIN_BACKGROUND_GRAY_EXSTREAM_LIGHT;
        }
        [mutableScrollViewList addObject:elementScrollView];
    }
    self.elementScrollViewList = [mutableScrollViewList copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)drawVerticalScrollViewByGoal:(WYGoalInMainViewModel *)goalViewModel {
    NSLog(@"Draw view for goal: %@", goalViewModel.goal.action);
    UIScrollView *singleGoalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    singleGoalScrollView.showsVerticalScrollIndicator = NO;
    singleGoalScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, kCommitButtonSectionHeight + kChartsSectionHeight + kOperationSectionHeight);
    
    [self drawCommitButtonOnSingleGoalView:singleGoalScrollView goal:goalViewModel];
    [self drawChartsOnSingleGoalView:singleGoalScrollView goal:goalViewModel];
    [self drawOperationButtonsOnSingleGoalView:singleGoalScrollView];
    
    return singleGoalScrollView;
}

- (UIScrollView *)drawAddGoalView {
    self.addGoalView = [[UIScrollView alloc] init];
    
    UIButton *hideKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hideKeyboardButton.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
    [hideKeyboardButton addTarget:self action:@selector(hideKeyboardButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.addGoalView addSubview:hideKeyboardButton];
    
    self.addGoalButton = [self drawMainButtonOnView:self.addGoalView];
    CALayer *addGoalButtonLayer = self.addGoalButton.layer;
    addGoalButtonLayer.borderWidth = 0;
    
    self.addGoalButton.backgroundColor = UI_COLOR_ORANGE;
    [self.addGoalButton setTitle:@"ADD" forState:UIControlStateNormal];
    [self.addGoalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addGoalButton.titleLabel.font = [UIFont systemFontOfSize:35];
    [self.addGoalButton addTarget:self action:@selector(addGoalButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.addGoalActionNameTextField = [[UITextField alloc] init];
    [self setFrameAndAlphaOfAddGoalActionNameTextFieldToHidePosition];
    self.addGoalActionNameTextField.font = [UIFont boldSystemFontOfSize:25];
    self.addGoalActionNameTextField.textColor = UI_COLOR_ORANGE;
    self.addGoalActionNameTextField.backgroundColor = [UIColor whiteColor];
    self.addGoalActionNameTextField.placeholder = @"Habit Name";
    self.addGoalActionNameTextField.hidden = YES;
    self.addGoalActionNameTextField.textAlignment = NSTextAlignmentCenter;
    [self.addGoalButton addSubview:self.addGoalActionNameTextField];
    
    self.addGoalOKButton = [[WYUIElementManager sharedInstance] createRoundButtonWithRadius:kOperationButtonRadius];
    self.addGoalOKButton.backgroundColor = UI_COLOR_ORANGE;
    [self.addGoalOKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addGoalOKButton setTitle:@"Add" forState:UIControlStateNormal];
    [self.addGoalOKButton addTarget:self action:@selector(addGoalOKButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.addGoalView addSubview:self.addGoalOKButton];
    
    self.addGoalCancelButton = [[WYUIElementManager sharedInstance] createRoundButtonWithRadius:kOperationButtonRadius];
    self.addGoalCancelButton.layer.borderWidth = 1.0f;
    self.addGoalCancelButton.layer.borderColor = UI_COLOR_ORANGE.CGColor;
    self.addGoalCancelButton.backgroundColor = [UIColor whiteColor];
    [self.addGoalCancelButton setTitleColor:UI_COLOR_ORANGE forState:UIControlStateNormal];
    [self.addGoalCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.addGoalCancelButton addTarget:self action:@selector(addGoalCancelButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.addGoalView addSubview:self.addGoalCancelButton];
    
    UILabel *addNotice = [[UILabel alloc] initWithFrame:CGRectMake(0, 270, UI_SCREEN_WIDTH, 120)];
    [addNotice setNumberOfLines:0];
    addNotice.textAlignment = NSTextAlignmentCenter;
    addNotice.textColor = UI_COLOR_GRAY_LIGHT;
    addNotice.font = [UIFont systemFontOfSize:26];
    addNotice.text = @"Start a good habit here\n and \nkeep it everyday.";
    [self.addGoalView addSubview:addNotice];
    
    [self setFrameOfAddGoalCheckButtonsToHidePosition];
    
    return self.addGoalView;
}

- (void)drawCommitButtonOnSingleGoalView:(UIScrollView *)singleGoalScrollView goal:(WYGoalInMainViewModel *)goalViewModel {
    WYToggleButton *commitButton = [self drawMainButtonOnView:singleGoalScrollView];
    
    [commitButton setTitle:goalViewModel.goal.action forState:UIControlStateNormal];
    [commitButton setTitleColor:UI_COLOR_ORANGE forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont boldSystemFontOfSize:35];
    commitButton.actionHasPerformed = goalViewModel.hasCommitToday;
    [self refreshCommitButton:commitButton];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(commitButtonLongPressed:)];
    longPressGesture.minimumPressDuration = 0.05f;
    [commitButton addGestureRecognizer:longPressGesture];
//    [commitButton addTarget:self action:@selector(commitGoalButtonPressed:) forControlEvents:UIControlEventTouchDown];
}

- (void)commitButtonLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            WYToggleButton *commitButton = (WYToggleButton *)gestureRecognizer.view;
            [self commitGoalButtonPressed:commitButton];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
        }
        default:
            break;
    }
}

- (WYToggleButton *)drawMainButtonOnView:(UIView *)parentView {
    WYToggleButton *commitButton = [WYToggleButton buttonWithType:UIButtonTypeCustom];
    [parentView addSubview:commitButton];
    
    CGFloat frameOfCommitButtonX = (UI_SCREEN_WIDTH - kCommitButtonRedius) / 2;
    commitButton.frame = CGRectMake(frameOfCommitButtonX, kCommitButtonTopMargin, kCommitButtonRedius, kCommitButtonRedius);
    commitButton.clipsToBounds = YES;
    CALayer *commitButtonLayer = [commitButton layer];
    commitButtonLayer.cornerRadius = kCommitButtonRedius / 2;
    commitButtonLayer.borderWidth = 2.0f;
    commitButtonLayer.borderColor = [UI_COLOR_ORANGE CGColor];
    
    return commitButton;
}

- (void)drawChartsOnSingleGoalView:(UIScrollView *)singleGoalScrollView goal:(WYGoalInMainViewModel *)goalViewModel {
    UIView *chartsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, kCommitButtonSectionHeight, UI_SCREEN_WIDTH, kChartsSectionHeight)];
    [singleGoalScrollView addSubview:chartsContainerView];
    
    UIView *calendarContainerView = [[UIView alloc] initWithFrame:CGRectMake(8, kCalendarTopMargin, 309, kCalendarHeight)];
    [chartsContainerView addSubview:calendarContainerView];
    calendarContainerView.clipsToBounds = YES;
    ITTCalendarView *calendarView = [ITTCalendarView viewFromNib];
    [calendarView setSelectedDays:[goalViewModel.commitLogIntValueSet allObjects]];
    ITTBaseDataSourceImp *dataSource = [[ITTBaseDataSourceImp alloc] init];
    calendarView.date = [NSDate dateWithTimeIntervalSinceNow:2*24*60*60];
    calendarView.dataSource = dataSource;
    //    calendarView.delegate = self;
    calendarView.frame = CGRectMake(0, 0, 309, 410);
    calendarView.allowsMultipleSelection = YES;
    
    [calendarView showInView:calendarContainerView];
    
//    UIView *lineChartView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarContainerView.frame) +  kLineChratTopSpacingToCalendar, UI_SCREEN_WIDTH, kLineChartHeight)];
//    lineChartView.backgroundColor = UI_COLOR_GRAY_LIGHT;
//    [chartsContainerView addSubview:lineChartView];
}

- (void)drawOperationButtonsOnSingleGoalView:(UIScrollView *)singleGoalScrollView {
    UIView *operationSectionContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, kCommitButtonSectionHeight + kChartsSectionHeight, UI_SCREEN_WIDTH, kOperationSectionHeight)];
    [singleGoalScrollView addSubview:operationSectionContainerView];
    
    UIButton *finishGoalButton = [[WYUIElementManager sharedInstance] createRoundButtonWithRadius:kOperationButtonRadius];
    finishGoalButton.frame = CGRectMake(kOperationButtonSideMargin, (kOperationSectionHeight - kOperationButtonRadius) / 2, kOperationButtonRadius, kOperationButtonRadius);
    finishGoalButton.layer.borderWidth = 2.0f;
    finishGoalButton.layer.borderColor = [UI_COLOR_ORANGE CGColor];
    [finishGoalButton setTitleColor:UI_COLOR_ORANGE forState:UIControlStateNormal];
    [finishGoalButton setTitle:@"Achieve" forState:UIControlStateNormal];
    [operationSectionContainerView addSubview:finishGoalButton];
    
    [finishGoalButton addTarget:self action:@selector(finishGoalButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *allGoalDetailsButton = [[WYUIElementManager sharedInstance] createRoundButtonWithRadius:kOperationButtonRadius];
    allGoalDetailsButton.backgroundColor = UI_COLOR_ORANGE;
    [allGoalDetailsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    allGoalDetailsButton.frame = CGRectMake(UI_SCREEN_WIDTH - kOperationButtonRadius - kOperationButtonSideMargin, (kOperationSectionHeight - kOperationButtonRadius) / 2, kOperationButtonRadius, kOperationButtonRadius);
    [allGoalDetailsButton setTitle:@"View All" forState:UIControlStateNormal];
    [allGoalDetailsButton addTarget:self action:@selector(detailButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [operationSectionContainerView addSubview:allGoalDetailsButton];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPageIndex = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
    [self updateCurrentPageIndex:currentPageIndex];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self cancelEditGoalNameViewAnimated];
}

#pragma mark - Button and Notification Actions

- (void)detailButtonPressed:(id)sender {
    [self presentAllGoalDetailsViewController];
}

- (void)addGoalButtonPressed:(id)sender {
    [self showEditGoalNameViewAnimated];
}

- (void)addGoalOKButtonPressed:(id)sender {
    [self addGoalWithName:self.addGoalActionNameTextField.text];
}

- (void)addGoalCancelButtonPressed:(id)sender {
    [self cancelEditGoalNameViewAnimated];
}

- (void)hideKeyboardButtonPressed:(id)sender {
    [self.addGoalActionNameTextField resignFirstResponder];
}

- (void)commitGoalButtonPressed:(id)sender {
    NSLog(@"Commit goal on page: %d", self.currentPageIndex);
    WYToggleButton *commitButton = (WYToggleButton *)sender;
    commitButton.actionHasPerformed = !commitButton.actionHasPerformed;
    [self refreshCommitButton:commitButton];
    if (commitButton.actionHasPerformed) {
        [self commitGoalInCurrentPage];
    } else {
        [self revertGoalInCurrentPage];
    }
}

- (void)finishGoalButtonPressed:(id)sender {
    NSLog(@"Archieve goal on page: %d", self.currentPageIndex);
    WYGoal *finishGoal = ((WYGoalInMainViewModel *)[self.liveGoalViewModelList objectAtIndex:self.currentPageIndex]).goal;
    UIAlertView *finishGoalAlertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Archieve %@", finishGoal.action] message:@"Do you really want to Archieve this goal?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Archieve", nil];
    [finishGoalAlertView show];
}

- (void)notifyRefreshGoalMetaData:(NSNotification *)notification {
    [self refreshMainContainerScrollViewAfterGoalMetaDataChanges];
}

#pragma mark - UIUtilities

- (void)refreshMainContainerScrollViewAfterGoalMetaDataChanges {
    self.liveGoalViewModelList = [[WYDataManager sharedInstance] getMainViewLiveGoalViewModelList];
    [self.mainContainerScrollView removeFromSuperview];
    self.mainContainerScrollView = nil;
    [self drawMainContainerScrollView];
    self.currentPageIndex = (int)MIN(self.currentPageIndex, self.liveGoalViewModelList.count - 1);
    self.mainContainerScrollView.contentOffset = CGPointMake(UI_SCREEN_WIDTH * self.currentPageIndex, 0);
}

- (void)showEditGoalNameViewAnimated {
    [self.addGoalActionNameTextField becomeFirstResponder];
    self.addGoalActionNameTextField.text = @"";
    self.addGoalActionNameTextField.hidden = NO;
    [self.addGoalButton setTitle:nil forState:UIControlStateNormal];
    [UIView animateWithDuration:kAnimationDurationNormal animations:^(void) {
        [self setFrameAndAlphaOfAddGoalActionnameTextFieldToShowPosition];
        [self setFrameOfAddGoalCheckButtonToShowPosition];
    }];
}

- (void)cancelEditGoalNameViewAnimated {
    [self.addGoalActionNameTextField resignFirstResponder];
    [UIView animateWithDuration:kAnimationDurationNormal animations:^(void) {
        [self setFrameAndAlphaOfAddGoalActionNameTextFieldToHidePosition];
        [self setFrameOfAddGoalCheckButtonsToHidePosition];
    }completion:^(BOOL finished) {
        self.addGoalActionNameTextField.hidden = YES;
        [self.addGoalButton setTitle:@"ADD" forState:UIControlStateNormal];
    }];
}

- (void)setFrameAndAlphaOfAddGoalActionNameTextFieldToHidePosition {
    self.addGoalActionNameTextField.alpha = 0.0f;
    CGFloat heightOfTextFieldHide = 1.0f;
    self.addGoalActionNameTextField.frame = CGRectMake(0, (kCommitButtonRedius - heightOfTextFieldHide) / 2, kCommitButtonRedius, heightOfTextFieldHide);
}

- (void)setFrameAndAlphaOfAddGoalActionnameTextFieldToShowPosition {
    self.addGoalActionNameTextField.alpha = 1.0f;
    self.addGoalActionNameTextField.frame = CGRectMake(0, (kCommitButtonRedius - kTextHeight) / 2, kCommitButtonRedius, kTextHeight);
}

- (void)setFrameOfAddGoalCheckButtonsToHidePosition {
    self.addGoalOKButton.frame = CGRectMake(UI_SCREEN_WIDTH + kOperationButtonRadius, kAddGoalOKAndCancelButtonY, kOperationButtonRadius, kOperationButtonRadius);
    self.addGoalCancelButton.frame = CGRectMake(-kOperationButtonRadius, kAddGoalOKAndCancelButtonY, kOperationButtonRadius, kOperationButtonRadius);
}

- (void)setFrameOfAddGoalCheckButtonToShowPosition {
    self.addGoalOKButton.frame = CGRectMake(UI_SCREEN_WIDTH - kOperationButtonSideMargin - kOperationButtonRadius, kAddGoalOKAndCancelButtonY, kOperationButtonRadius, kOperationButtonRadius);
    self.addGoalCancelButton.frame = CGRectMake(kOperationButtonSideMargin, kAddGoalOKAndCancelButtonY, kOperationButtonRadius, kOperationButtonRadius);
}

- (void)presentAllGoalDetailsViewController {
    if (nil == self.allGoalDetailsNavigationController) {
        self.allGoalDetailsNavigationController = [[UINavigationController alloc] initWithRootViewController:[[WYAllGoalDetailsViewController alloc] initWithNibName:nil bundle:nil]];
    }
    [self presentViewController:self.allGoalDetailsNavigationController animated:YES completion:nil];
}

- (void)refreshCommitButton:(WYToggleButton *)commitButton {
    if (commitButton.actionHasPerformed) {
        [commitButton setBackgroundImage:[UIImage imageNamed:@"commit_button.png"] forState:UIControlStateNormal];
        commitButton.layer.borderWidth = 0;
        [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [commitButton setBackgroundImage:nil forState:UIControlStateNormal];
        commitButton.layer.borderWidth = 2;
        [commitButton setTitleColor:UI_COLOR_ORANGE forState:UIControlStateNormal];
    }
}

#pragma mark - GoalOperations

-(void)commitGoalInCurrentPage {
    WYGoal *commitGoal = ((WYGoalInMainViewModel *)[self.liveGoalViewModelList objectAtIndex:self.currentPageIndex]).goal;
    commitGoal.totalDays++;
    [[WYDataManager sharedInstance] updateGoal:commitGoal];
    
    WYCommitLog *commitLog = [[WYCommitLog alloc] init];
    [commitLog setWYDate:[NSDate date]];
    commitLog.goalID = commitGoal.goalID;
    commitLog.totalDaysUntilNow = commitGoal.totalDays;
    
    [[WYDataManager sharedInstance] updateCommitLog:commitLog];
    [self updateViewModelAndRefreshCurrentView];
}

- (void)revertGoalInCurrentPage {
    WYGoal *commitGoal = ((WYGoalInMainViewModel *)[self.liveGoalViewModelList objectAtIndex:self.currentPageIndex]).goal;
    commitGoal.totalDays--;
    [[WYDataManager sharedInstance] updateGoal:commitGoal];
    
    WYCommitLog *commitLog = [[WYCommitLog alloc] init];
    commitLog.goalID = commitGoal.goalID;
    [commitLog setWYDate:[NSDate date]];
    
    [[WYDataManager sharedInstance] deleteCommitLog:commitLog];
    [self updateViewModelAndRefreshCurrentView];
}

- (void)updateViewModelAndRefreshCurrentView {
    self.liveGoalViewModelList = [[WYDataManager sharedInstance] getMainViewLiveGoalViewModelList];
    [self drawChartsOnSingleGoalView:self.elementScrollViewList[self.currentPageIndex] goal:self.liveGoalViewModelList[self.currentPageIndex]];
}

- (void)finishGoalInCurrentPage {
    WYGoal *finishGoal = ((WYGoalInMainViewModel *)[self.liveGoalViewModelList objectAtIndex:self.currentPageIndex]).goal;
    finishGoal.achiveTime = [NSDate date];
    [[WYDataManager sharedInstance] updateGoal:finishGoal];
}

- (void)addGoalWithName:(NSString *)nameOfNewGoal {
    if (nameOfNewGoal.length > 0) {
        WYGoal *newGoal = [[WYDataManager sharedInstance] addGoalNamed:nameOfNewGoal];
        if (nil != newGoal) {
            [self refreshMainContainerScrollViewAfterGoalMetaDataChanges];
            self.mainContainerScrollView.contentOffset = CGPointMake(UI_SCREEN_WIDTH * (self.liveGoalViewModelList.count - 1), 0);
        }
    } else {
        UIAlertView *emptyGoalNameAlertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please enter name of new goal." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [emptyGoalNameAlertView show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self finishGoalInCurrentPage];
        WYGoal *finishGoal = ((WYGoalInMainViewModel *)[self.liveGoalViewModelList objectAtIndex:self.currentPageIndex]).goal;
        WYGoalTimeLineViewController *goalTimeLineViewController = [[WYGoalTimeLineViewController alloc] initWithGoal:finishGoal.goalID];
        [self presentViewController:goalTimeLineViewController animated:YES completion:^(void) {
            [self refreshMainContainerScrollViewAfterGoalMetaDataChanges];
        }];
    }
}

#pragma mark - Other

- (void)updateCurrentPageIndex:(int)pageIndex {
    NSLog(@"Update currentPageIndex: %d", pageIndex);
    self.currentPageIndex = pageIndex;
}
@end