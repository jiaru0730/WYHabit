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

static const int kCommitButtonSectionHeight = 250;
static const int kCommitButtonTopMargin = 40;
static const int kCommitButtonRedius = 200;

static const int kChartsSectionHeight = 800;






@interface WYMainContainerViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *mainContainerScrollView;

@property (strong, nonatomic) NSArray *liveGoalViewModelList;

// this is not used
@property (strong, nonatomic) UIPageControl *mainContainerPageControl;

@end

@implementation WYMainContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _liveGoalViewModelList = [[WYDataManager sharedInstance] getMainViewLiveGoalViewModelList];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    CGSize sizeOfScrollView = self.mainContainerScrollView.frame.size;
    self.mainContainerScrollView.contentSize = CGSizeMake(sizeOfScrollView.width * self.liveGoalViewModelList.count, sizeOfScrollView.height);
    
    for (int i = 0; i < self.liveGoalViewModelList.count; ++i) {
        CGRect frameOfSingleGoalView = (CGRect){.origin=CGPointMake(sizeOfScrollView.width * i, 0), .size=sizeOfScrollView};
        UIScrollView *singleGoalScrollView = [self drawVerticalScrollViewByGoal:[self.liveGoalViewModelList objectAtIndex:i]];
        singleGoalScrollView.frame = frameOfSingleGoalView;
        [self.mainContainerScrollView addSubview:singleGoalScrollView];
        if (i % 2 == 0) {
            singleGoalScrollView.backgroundColor = [UIColor whiteColor];
        } else {
            singleGoalScrollView.backgroundColor = UI_COLOR_GRAY_LIGHT;
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)drawVerticalScrollViewByGoal:(WYGoalInMainViewModel *)goalViewModel {
    UIScrollView *singleGoalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    singleGoalScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, kCommitButtonSectionHeight + kChartsSectionHeight);
    
    [self drawCommitButtonOnScrollView:singleGoalScrollView];
    [self drawChartsOnScrollView:singleGoalScrollView];
    
    return singleGoalScrollView;
}

- (void)drawCommitButtonOnScrollView:(UIScrollView *)singleGoalScrollView {
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [singleGoalScrollView addSubview:commitButton];
    //    commitButton.backgroundColor = UI_COLOR_GRAY_LIGHT;
    CGFloat frameOfCommitButtonX = (UI_SCREEN_WIDTH - kCommitButtonRedius) / 2;
    commitButton.frame = CGRectMake(frameOfCommitButtonX, kCommitButtonTopMargin, kCommitButtonRedius, kCommitButtonRedius);
    commitButton.clipsToBounds = YES;
    CALayer *commitButtonLayer = [commitButton layer];
    commitButtonLayer.cornerRadius = kCommitButtonRedius / 2;
    commitButtonLayer.borderWidth = 2.0f;
    commitButtonLayer.borderColor = [UI_COLOR_ORANGE CGColor];
    
    [commitButton setTitle:@"I am kool!" forState:UIControlStateNormal];
    [commitButton setTitleColor:UI_COLOR_ORANGE forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont boldSystemFontOfSize:35];
}

- (void)drawChartsOnScrollView:(UIScrollView *)singleGoalScrollView {
    UIView *chartsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, kCommitButtonSectionHeight, UI_SCREEN_WIDTH, kChartsSectionHeight)];
    [singleGoalScrollView addSubview:chartsContainerView];
    UIView *calendarContainerView = [[UIView alloc] initWithFrame:CGRectMake(8, 30, 309, 255)];
    [chartsContainerView addSubview:calendarContainerView];
    calendarContainerView.clipsToBounds = YES;
    ITTCalendarView *calendarView = [ITTCalendarView viewFromNib];
    ITTBaseDataSourceImp *dataSource = [[ITTBaseDataSourceImp alloc] init];
    calendarView.date = [NSDate dateWithTimeIntervalSinceNow:2*24*60*60];
    calendarView.dataSource = dataSource;
    //    calendarView.delegate = self;
    calendarView.frame = CGRectMake(0, 0, 309, 410);
    calendarView.allowsMultipleSelection = YES;
    [calendarView showInView:calendarContainerView];
    
}


@end
