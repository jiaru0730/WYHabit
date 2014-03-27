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
    CGSize sizeOfScrollView = self.mainContainerScrollView.frame.size;
    self.mainContainerScrollView.contentSize = CGSizeMake(sizeOfScrollView.width * self.liveGoalViewModelList.count, sizeOfScrollView.height);
    
    for (int i = 0; i < self.liveGoalViewModelList.count; ++i) {
        UIView *elementView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(sizeOfScrollView.width * i, 0), .size=sizeOfScrollView}];
        [self.mainContainerScrollView addSubview:elementView];
        if (i % 2 == 0) {
            elementView.backgroundColor = [UIColor orangeColor];
        }
        if (i == 0) {
            UIView *calendarContainerView = [[UIView alloc] initWithFrame:CGRectMake(8, 30, 309, 255)];
            [elementView addSubview:calendarContainerView];
            calendarContainerView.clipsToBounds = YES;
            ITTCalendarView *calendarView = [ITTCalendarView viewFromNib];
            ITTBaseDataSourceImp *dataSource = [[ITTBaseDataSourceImp alloc] init];
            calendarView.date = [NSDate dateWithTimeIntervalSinceNow:2*24*60*60];
            calendarView.dataSource = dataSource;
            calendarView.delegate = self;
            calendarView.frame = CGRectMake(0, 0, 309, 410);
            calendarView.allowsMultipleSelection = YES;
            [calendarView showInView:calendarContainerView];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
