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

@property (strong, nonatomic) NSArray *allGoalViewModelList;

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

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allGoalViewModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = ((WYGoalInDetailViewModel *)[self.allGoalViewModelList objectAtIndex:indexPath.row]).goal.action;
    return cell;
}
#pragma mark - UI Utils

@end
