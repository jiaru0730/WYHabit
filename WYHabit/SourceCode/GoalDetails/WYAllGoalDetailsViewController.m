//
//  WYAllGoalStatisticsViewController.m
//  WYHabit
//
//  Created by Jia Ru on 3/28/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYAllGoalDetailsViewController.h"

#import "WYDataManager.h"
#import "WYGoalInDetailViewModel.h"


static const int kNumberOfSectionsInAllDetailTableView = 2;
static const int kSectionNumberOfLiveGoal       = 0;
static const int kSectionNumberOfAchievedGoal   = 1;


@interface WYAllGoalDetailsViewController ()

@property (strong, nonatomic) UIBarButtonItem *editTableViewItem;
@property (strong, nonatomic) UIBarButtonItem *finishEditTableViewItem;


@property (strong, nonatomic) NSArray *allGoalViewModelList;
@property (strong, nonatomic) NSArray *liveGoalViewModelList;
@property (strong, nonatomic) NSArray *achievedGoalViewModelList;

@property (assign, nonatomic) NSIndexPath *renameIndexPath;


@end

@implementation WYAllGoalDetailsViewController

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
    
    self.allGoalDetailTableView.dataSource = self;
    self.allGoalDetailTableView.delegate = self;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelItemPressed:)];
    self.editTableViewItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableViewItemPressed:)];
    self.finishEditTableViewItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEditTableViewItemPressed:)];
    self.navigationItem.rightBarButtonItem = self.editTableViewItem;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyRefreshGoalMetaData:) name:kNotifyRefreshGoalMetaData object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadAllGoalViewModel];
    [self.allGoalDetailTableView reloadData];
}

- (void)loadAllGoalViewModel {
    self.allGoalViewModelList = [[WYDataManager sharedInstance] getAllGoalDetailViewModelList];
    
    NSMutableArray *mutableLiveGoalModelViewList = [NSMutableArray array];
    NSMutableArray *mutableAchievedGoalModelViewList = [NSMutableArray array];
    
    for (WYGoalInDetailViewModel *goalInDetailViewModel in self.allGoalViewModelList) {
        BOOL isGoalAchieved = [goalInDetailViewModel.goal.achiveTime timeIntervalSince1970] > 0;
        if (isGoalAchieved) {
            [mutableAchievedGoalModelViewList addObject:goalInDetailViewModel];
        } else {
            [mutableLiveGoalModelViewList addObject:goalInDetailViewModel];
        }
    }
    
    self.liveGoalViewModelList = mutableLiveGoalModelViewList.copy;
    self.achievedGoalViewModelList = mutableAchievedGoalModelViewList.copy;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (void)cancelItemPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editTableViewItemPressed:(id)sender {
    [self.allGoalDetailTableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = self.finishEditTableViewItem;
}

- (void)finishEditTableViewItemPressed:(id)sender {
    [self.allGoalDetailTableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = self.editTableViewItem;
}

#pragma mark - UITableView DataSource & Delegate

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSectionsInAllDetailTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int numberOfRowsInSection = 0;
    switch (section) {
        case kSectionNumberOfLiveGoal:
            numberOfRowsInSection = self.achievedGoalViewModelList.count;
            break;
        case kSectionNumberOfAchievedGoal:
            numberOfRowsInSection = self.liveGoalViewModelList.count;
            break;
        default:
            break;
    }
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellReuseIdentifier = @"allGoalDetailTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuseIdentifier];
    }
    
//    WYGoal *goalForCell = ((WYGoalInDetailViewModel *)[self.allGoalViewModelList objectAtIndex:indexPath.row]).goal;
    WYGoalInDetailViewModel *goalViewModelForCell = nil;
    switch (indexPath.section) {
        case kSectionNumberOfLiveGoal:
            goalViewModelForCell = self.liveGoalViewModelList[indexPath.row];
            break;
        case kSectionNumberOfAchievedGoal:
            goalViewModelForCell = self.achievedGoalViewModelList[indexPath.row];
            break;
        default:
            goalViewModelForCell = self.liveGoalViewModelList[indexPath.row];
            break;
    }
    WYGoal *goalForCell = goalViewModelForCell.goal;
    
    if ([goalForCell.achiveTime timeIntervalSince1970] == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = UI_COLOR_GRAY_LIGHT;
    }
    cell.textLabel.text = goalForCell.action;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", goalForCell.totalDays];
    cell.editingAccessoryType = UITableViewCellAccessoryDetailButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete goal at index path.
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    self.renameIndexPath = indexPath;
    [self showRenameAlert];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = nil;
    switch (section) {
        case kSectionNumberOfLiveGoal:
            sectionTitle = @"Live goals";
            break;
        case kSectionNumberOfAchievedGoal:
            sectionTitle = @"Achieved goals";
            break;
        default:
            sectionTitle = @"";
            break;
    }
    return sectionTitle;
}

#pragma mark - Button and Notification actions

- (void)notifyRefreshGoalMetaData:(NSNotification *)notification {
    self.allGoalViewModelList = [[WYDataManager sharedInstance] getAllGoalDetailViewModelList];
    [self.allGoalDetailTableView reloadData];
}
                                 
#pragma mark - UI Utils

- (void)showRenameAlert {
    NSString *oldName = ((WYGoalInDetailViewModel *)[self.allGoalViewModelList objectAtIndex:self.renameIndexPath.row]).goal.action;
    UIAlertView *renameAlertView = [[UIAlertView alloc] initWithTitle:@"Rename goal" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Rename", nil];
    renameAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [renameAlertView textFieldAtIndex:0].text = oldName;
    [renameAlertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        WYGoal *renamedGoal = ((WYGoalInDetailViewModel *)[self.allGoalViewModelList objectAtIndex:self.renameIndexPath.row]).goal;
        renamedGoal.action = [alertView textFieldAtIndex:0].text;
        [[WYDataManager sharedInstance] updateGoal:renamedGoal];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyRefreshGoalMetaData object:self];
    }
}

@end
