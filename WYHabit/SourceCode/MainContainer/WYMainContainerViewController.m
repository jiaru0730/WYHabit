//
//  WYMainContainerViewController.m
//  WYHabit
//
//  Created by Jia Ru on 3/26/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYMainContainerViewController.h"

@interface WYMainContainerViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *mainContainerScrollView;
@property (strong, nonatomic) UIPageControl *mainContainerPageControl;

@end

@implementation WYMainContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize sizeOfScrollView = self.mainContainerScrollView.frame.size;
    self.mainContainerScrollView.contentSize = CGSizeMake(sizeOfScrollView.width * 5, sizeOfScrollView.height);
    
    for (int i = 0; i < 5; ++i) {
        UIView *elementView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(sizeOfScrollView.width * i, 0), .size=sizeOfScrollView}];
        [self.mainContainerScrollView addSubview:elementView];
        if (i % 2 == 0) {
            elementView.backgroundColor = [UIColor orangeColor];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
