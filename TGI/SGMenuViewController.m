//
//  SGMenuViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGMenuViewController.h"
#import "SGDwellTimeViewController.h"
#import "SGDwellTimeTabBarController.h"
#import "SGUserSettings.h"

@implementation SGMenuViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [SGUserSettings company];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == self.dwellTimeCell) {
        SGDwellTimeTabBarController *viewController = segue.destinationViewController;
        [viewController dwellTime];
    } else if (sender == self.detentionTimeCell) {
        SGDwellTimeTabBarController *viewController = segue.destinationViewController;
        [viewController detentionTime];
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

@end
