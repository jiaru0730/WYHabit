//
//  WYAllGoalStatisticsViewController.m
//  WYHabit
//
//  Created by Jia Ru on 3/28/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYAllGoalStatisticsViewController.h"

#import "WYDataManager.h"
#import "WYGoalInDetailViewModel.h"


@interface WYAllGoalStatisticsViewController ()

@property (strong, nonatomic) UIBarButtonItem *editTableViewItem;
@property (strong, nonatomic) UIBarButtonItem *finishEditTableViewItem;


@property (strong, nonatomic) NSArray *allGoalViewModelList;

@property (assign, nonatomic) NSIndexPath *renameIndexPath;


@end

@implementation WYAllGoalStatisticsViewController

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelItemPressed:)];
    self.editTableViewItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableViewItemPressed:)];
    self.finishEditTableViewItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEditTableViewItemPressed:)];
    self.navigationItem.rightBarButtonItem = self.editTableViewItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadAllGoalViewModel];
    [self.allGoalDetailTableView reloadData];
}

- (void)loadAllGoalViewModel {
    self.allGoalViewModelList = [[WYDataManager sharedInstance] getAllGoalDetailViewModelList];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allGoalViewModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor greenColor];
    cell.textLabel.text = ((WYGoalInDetailViewModel *)[self.allGoalViewModelList objectAtIndex:indexPath.row]).goal.action;
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
                                 
                                 
#pragma mark - UI Utils

- (void)showRenameAlert {
    NSString *oldName = ((WYGoalInDetailViewModel *)[self.allGoalViewModelList objectAtIndex:self.renameIndexPath.row]).goal.action;
    UIAlertView *renameAlertView = [[UIAlertView alloc] initWithTitle:@"Rename goal" message:[NSString stringWithFormat:@"Old Name: %@", oldName] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Rename", nil];
    renameAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [renameAlertView show];
}

@end
