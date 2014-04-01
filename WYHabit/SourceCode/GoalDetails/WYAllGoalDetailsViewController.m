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
#import "WYGoalTimeLineViewController.h"

static const int kNumberOfSectionsInAllDetailTableView = 2;
static const int kSectionNumberOfLiveGoal       = 0;
static const int kSectionNumberOfAchievedGoal   = 1;

static const int kTagOfRenameAlertView  = 1001;
static const int kTagOfDeleteAlertView  = 1002;

@interface WYAllGoalDetailsViewController ()

@property (strong, nonatomic) UIBarButtonItem *editTableViewItem;
@property (strong, nonatomic) UIBarButtonItem *finishEditTableViewItem;


@property (strong, nonatomic) NSArray *allGoalViewModelList;
@property (strong, nonatomic) NSArray *liveGoalViewModelList;
@property (strong, nonatomic) NSArray *achievedGoalViewModelList;

@property (copy, nonatomic) NSIndexPath *renameIndexPath;
@property (copy, nonatomic) NSIndexPath *deleteIndexPath;


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
            numberOfRowsInSection = MAX(1, self.achievedGoalViewModelList.count);
            break;
        case kSectionNumberOfAchievedGoal:
            numberOfRowsInSection = MAX(1, self.liveGoalViewModelList.count);
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
    
    WYGoalInDetailViewModel *goalViewModelForCell = [self getGoalViewModelAtIndexPath:indexPath];
    WYGoal *goalForCell = goalViewModelForCell.goal;
    
    if (nil != goalForCell) {
        cell.textLabel.text = goalForCell.action;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", goalForCell.totalDays];
        cell.editingAccessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        cell.textLabel.text = @"No habit.";
        cell.detailTextLabel.text = @"";
    }
    
    if (indexPath.section == kSectionNumberOfLiveGoal) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = UI_COLOR_GRAY_LIGHT;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WYGoalInDetailViewModel *goalInDetailViewModel = [self getGoalViewModelAtIndexPath:indexPath];
    WYGoalTimeLineViewController *goalTimelineViewController = [[WYGoalTimeLineViewController alloc] initWithGoal:goalInDetailViewModel.goal.goalID];
    goalTimelineViewController.isPresented = NO;
    [self.navigationController pushViewController:goalTimelineViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.deleteIndexPath = indexPath;
        [self showDeleteAlert];
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
            sectionTitle = @"Live habit(s)";
            break;
        case kSectionNumberOfAchievedGoal:
            sectionTitle = @"Achieved habit(s)";
            break;
        default:
            sectionTitle = @"";
            break;
    }
    return sectionTitle;
}

#pragma mark - Button and Notification actions

- (void)notifyRefreshGoalMetaData:(NSNotification *)notification {
    [self loadAllGoalViewModel];
    [self.allGoalDetailTableView reloadData];
}
                                 
#pragma mark - UI Utils

- (void)showRenameAlert {
    NSString *oldName = [self getGoalViewModelAtIndexPath:self.renameIndexPath].goal.action;
    UIAlertView *renameAlertView = [[UIAlertView alloc] initWithTitle:@"Rename habit" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Rename", nil];
    renameAlertView.tag = kTagOfRenameAlertView;
    renameAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [renameAlertView textFieldAtIndex:0].text = oldName;
    [renameAlertView show];
}

- (void)showDeleteAlert {
    NSString *nameOfGoalToDelete = [self getGoalViewModelAtIndexPath:self.deleteIndexPath].goal.action;
    UIAlertView *deleteAlertView = [[UIAlertView alloc] initWithTitle:@"Delete habit" message:[NSString stringWithFormat:@"Are you sure you want to delete %@? (This action cannot be undo.)", nameOfGoalToDelete] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Delete", nil];
    deleteAlertView.tag = kTagOfDeleteAlertView;
    [deleteAlertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case kTagOfRenameAlertView:
            if (buttonIndex == 1) {
                WYGoal *renamedGoal = [self getGoalViewModelAtIndexPath:self.renameIndexPath].goal;
                renamedGoal.action = [alertView textFieldAtIndex:0].text;
                [[WYDataManager sharedInstance] updateGoal:renamedGoal];
            }
            break;
        case kTagOfDeleteAlertView:
            if (buttonIndex == 1) {
                WYGoal *goalToDelete = [self getGoalViewModelAtIndexPath:self.deleteIndexPath].goal;
                [[WYDataManager sharedInstance] deleteGoalByID:goalToDelete.goalID];
            }
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyRefreshGoalMetaData object:self];
}

#pragma mark - Other

- (WYGoalInDetailViewModel *)getGoalViewModelAtIndexPath:(NSIndexPath *)indexPath {
    WYGoalInDetailViewModel *goalViewModelAtIndexPath = nil;
    switch (indexPath.section) {
        case kSectionNumberOfLiveGoal:
            if (indexPath.row >= self.liveGoalViewModelList.count) {
                goalViewModelAtIndexPath = nil;
            } else {
                goalViewModelAtIndexPath = self.liveGoalViewModelList[indexPath.row];
            }
            break;
        case kSectionNumberOfAchievedGoal:
            if (indexPath.row >= self.achievedGoalViewModelList.count) {
                goalViewModelAtIndexPath = nil;
            } else {
                goalViewModelAtIndexPath = self.achievedGoalViewModelList[indexPath.row];
            }
            break;
        default:
            break;
    }
    return goalViewModelAtIndexPath;
}

@end
