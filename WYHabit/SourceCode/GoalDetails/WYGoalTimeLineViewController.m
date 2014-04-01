//
//  WYGoalTimeLineViewController.m
//  WYHabit
//
//  Created by Jia Ru on 3/29/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYGoalTimeLineViewController.h"
#import "WYGoal.h"
#import "WYDataManager.h"
#import "WYDate.h"


static int heightForSingleRow = 22;

static int heightForTableViewFooter = 50;
static int heightForFinishButton = 40;
static int widthOfKeyword = 100;

@interface WYGoalTimeLineViewController ()

@property (copy, nonatomic) NSString *goalID;

@property (strong, nonatomic) WYGoal *goal;
@property (assign, nonatomic) int elapsedDays;
@property (assign, nonatomic) int longestSequence;
@property (assign, nonatomic) float percentageInAll;
@property (assign, nonatomic) int rankingInAll;

@property (strong, nonatomic) NSArray *numberOfRowsInCell;


@end

@implementation WYGoalTimeLineViewController

- (id)initWithGoal:(NSString *)goalID {
    self = [super init];
    if (self) {
        _goalID = goalID;
        _goal = [[WYDataManager sharedInstance] getGoalByID:self.goalID];
        
        _numberOfRowsInCell = @[@(3), @(3), @(3), @(3), @(3), @(2), @(4)];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.isPresented) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50)];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, heightForTableViewFooter)];
        UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        finishButton.frame = CGRectMake(10, (heightForTableViewFooter - heightForFinishButton) / 2, 300, heightForFinishButton);
        finishButton.clipsToBounds = YES;
        finishButton.layer.cornerRadius = 5;
        [finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        finishButton.backgroundColor = UI_COLOR_ORANGE;
        [finishButton addTarget:self action:@selector(finishButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView.tableFooterView addSubview:finishButton];
    }
}

- (int)calculateElapsedDays {
    NSDate *endDateOfTimeline = [NSDate date];
    if ([self isGoalAchieved]) {
        endDateOfTimeline = self.goal.achiveTime;
    }
    NSTimeInterval elapsedTimeInterval = [endDateOfTimeline timeIntervalSinceDate:self.goal.startTime];
    return (elapsedTimeInterval / kSecondsPerDay) + 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfRows = 6;
    if ([self isGoalAchieved]) {
        numberOfRows += 1;
    }
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int rowInFullTimeline = indexPath.row;
    if (rowInFullTimeline > 0 && ![self isGoalAchieved]) {
        rowInFullTimeline += 1;
    }
    CGFloat heightForRow = [self.numberOfRowsInCell[rowInFullTimeline] intValue] * heightForSingleRow + 20;
    return heightForRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"timeLineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    CGRect frameOfCell = [tableView rectForRowAtIndexPath:indexPath];
    
    int rowInFullTimeline = indexPath.row;
    if (rowInFullTimeline > 0 && ![self isGoalAchieved]) {
        rowInFullTimeline += 1;
    }
    
    int numberOfRowsForDetailLabel = [self.numberOfRowsInCell[rowInFullTimeline] intValue];
    
    UILabel *keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(frameOfCell) - heightForSingleRow) / 2, widthOfKeyword - 12, heightForSingleRow)];
    keywordLabel.textAlignment = NSTextAlignmentRight;
    keywordLabel.textColor = UI_COLOR_ORANGE;
    keywordLabel.font = [UIFont boldSystemFontOfSize:17];

    int numberOfTimeLineRows = 4;
    if ([self isGoalAchieved]) {
        numberOfTimeLineRows += 1;
    }
    if (indexPath.row <= numberOfTimeLineRows) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(widthOfKeyword - 6, 0, 2, CGRectGetHeight(frameOfCell))];
        line.backgroundColor = UI_COLOR_GRAY_LIGHT;
        [cell.contentView addSubview:line];
        
        UIImageView *smallIconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commit_button.png"]];
        CGFloat smallIconRadius = 10;
        smallIconImage.frame = CGRectMake(widthOfKeyword - 10, (CGRectGetHeight(frameOfCell) - smallIconRadius) /2 , smallIconRadius, smallIconRadius);
        [cell.contentView addSubview:smallIconImage];
    }
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthOfKeyword + 4, (CGRectGetHeight(frameOfCell) - numberOfRowsForDetailLabel * heightForSingleRow) / 2, UI_SCREEN_WIDTH - widthOfKeyword - 10, numberOfRowsForDetailLabel * heightForSingleRow)];
    [detailLabel setNumberOfLines:0];
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.textColor = [UIColor grayColor];
    
    NSString *timelineDetailText = nil;
    NSString *timelineKeywordText = nil;
    
    switch (rowInFullTimeline) {
        case 0: {
            WYDate *startWYDate = [[WYDataManager sharedInstance] convertDateToWYDate:self.goal.startTime];
            timelineKeywordText = [NSString stringWithFormat:@"%d.%d.%d", startWYDate.year, startWYDate.month, startWYDate.day];
            timelineDetailText = [NSString stringWithFormat:@"%d.%d.%d你在Habit添加了习惯\"%@\"", startWYDate.year, startWYDate.month, startWYDate.day, self.goal.action];
            break;
        }
        case 1: {
            WYDate *achiveWYDate = [[WYDataManager sharedInstance] convertDateToWYDate:self.goal.achiveTime];
            timelineKeywordText = [NSString stringWithFormat:@"%d.%d.%d", achiveWYDate.year, achiveWYDate.month, achiveWYDate.day];
            timelineDetailText = [NSString stringWithFormat:@"到%d.%d.%d你成功养成了这个习惯", achiveWYDate.year, achiveWYDate.month, achiveWYDate.day];
            break;
        }
        case 2:
            timelineKeywordText = [NSString stringWithFormat:@"%d", [self calculateElapsedDays]];
            timelineDetailText = [NSString stringWithFormat:@"%@习惯的养成一共经历了%d天", self.goal.action, [self calculateElapsedDays]];
            break;
        case 3: {
            timelineKeywordText = [NSString stringWithFormat:@"%d", [[WYDataManager sharedInstance] calculateContinueSequenceForGoal:self.goalID]];
            timelineDetailText = [NSString stringWithFormat:@"在这%d天内你有%d天未间断地在坚持", [self calculateElapsedDays], [[WYDataManager sharedInstance] calculateContinueSequenceForGoal:self.goalID]];
            break;
        }
        case 4:
            timelineKeywordText = [NSString stringWithFormat:@"%.2f%%", [[WYDataManager sharedInstance] calculateCommitPercentageForGoal:self.goalID] * 100];
            timelineDetailText = [NSString stringWithFormat:@"你所有习惯中, %@花费时间占据%.2f%%", self.goal.action, [[WYDataManager sharedInstance] calculateCommitPercentageForGoal:self.goalID] * 100];
            break;
        case 5:
            timelineKeywordText = [NSString stringWithFormat:@"%d", [[WYDataManager sharedInstance] calculateCommitRankingForGoal:self.goalID]];
            timelineDetailText = [NSString stringWithFormat:@"排在第%d位", [[WYDataManager sharedInstance] calculateCommitRankingForGoal:self.goalID]];
            break;
        case 6:
            detailLabel.frame = CGRectMake(0, (CGRectGetHeight(frameOfCell) - numberOfRowsForDetailLabel * heightForSingleRow) / 2, UI_SCREEN_WIDTH, numberOfRowsForDetailLabel * heightForSingleRow);
            detailLabel.textAlignment = NSTextAlignmentCenter;
            timelineKeywordText = [NSString stringWithFormat:@""];
            timelineDetailText = @"改变自己，就是用更多的好习惯来替代原有习惯。你已在变得更好的路上又前进了一步。Habit愿伴随你的每一步.";
            break;
        default:
            timelineKeywordText = [NSString stringWithFormat:@""];
            timelineDetailText = [NSString stringWithFormat:@""];
            break;
    }
    
    
    
    keywordLabel.text = timelineKeywordText;
    detailLabel.text = timelineDetailText;
    
    [cell.contentView addSubview:keywordLabel];
    [cell.contentView addSubview:detailLabel];
    
    
    return cell;
}

#pragma mark - Button actions

- (void)finishButtonPressed:(id)UIButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (BOOL)isGoalAchieved {
    return [self.goal.achiveTime timeIntervalSince1970] > 0;
}

@end
