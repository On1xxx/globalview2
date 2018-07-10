//
//  SGDwellTimeTabBarController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGDwellTimeTabBarController.h"
#import "SGDwellTimeParser.h"
#import "SGPortlet.h"
#import "SGDwellTimeCell.h"
#import "SGDwellTime.h"
#import "SGLoadingView.h"
#import "SGDwellTimeViewController.h"
#import "SGDwellTimeByAssetViewController.h"
#import "SGDwellTimeByLandmarkViewController.h"

@implementation SGDwellTimeTabBarController
{
    NSString *_portletName;
    UIBarButtonItem *item;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        item = [[UIBarButtonItem alloc] initWithTitle:@"Sort"
                                                style:UIBarButtonItemStyleBordered
                                               target:self
                                               action:@selector(willSort:)];
        self.navigationItem.rightBarButtonItem = item;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)viewDidLoad
{
    SGLoadingView *loadingView = [SGLoadingView loadingView:self.view];
    
    SGDwellTimeParser *parser = [[SGDwellTimeParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:_portletName
                                                     parser:parser
                                                  onSuccess:^() {
                                                      if (parser.array != nil) {
                                                          self.array = parser.array;
                                                          self.navigationItem.rightBarButtonItem.enabled = YES;
                                                          [loadingView removeFromSuperview];
                                                      }
                                                  }
                                                    onError:^() {
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                    }];
    [portlet invoke];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UIViewController *dataViewController = [self.viewControllers objectAtIndex:0];
    if (viewController == dataViewController) {
        self.navigationItem.rightBarButtonItem = item;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)willSort:(id)sender
{
    SGDwellTimeViewController *viewController = [self.viewControllers objectAtIndex:0];
    [viewController willSort];
}

- (void)setArray:(NSArray *)array
{
    _array = array;
    
    SGDwellTimeViewController *viewController = [self.viewControllers objectAtIndex:0];
    viewController.array = self.array;
    
    SGDwellTimeByAssetViewController *byAssetController = [self.viewControllers objectAtIndex:1];
    byAssetController.array = self.array;
    
    SGDwellTimeByLandmarkViewController *byLandmarkController = [self.viewControllers objectAtIndex:2];
    byLandmarkController.array = self.array;
}

- (void)dwellTime
{
    _portletName = @"TRKDWELLTIMELMRE";
    self.title = @"Dwell Time";
    
    SGDwellTimeViewController *viewController = [self.viewControllers objectAtIndex:0];
    viewController.title = self.title;
}

- (void)detentionTime
{
    _portletName = @"TRKDETENTIONTIMERE";
    self.title = @"Detention Time";
    
    SGDwellTimeViewController *viewController = [self.viewControllers objectAtIndex:0];
    viewController.title = self.title;
}

@end
