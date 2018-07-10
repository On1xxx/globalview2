//
//  SGYardCheckListViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGYardCheckListViewController.h"
#import "SGYardCheckViewController.h"
#import "SGYardCheckListCell.h"
#import "SGYardCheck.h"
#import "SGYardCheckParser.h"
#import "SGPortlet.h"
#import "SGLoadingView.h"

@implementation SGYardCheckListViewController
{
    NSArray *array;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    SGLoadingView *loadingView = [SGLoadingView loadingView:self.view];
    
    SGYardCheckParser *parser = [[SGYardCheckParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"TRKYARDCHECK"
                                                     parser:parser
                                                  onSuccess:^() {
                                                      NSLog(@"result = %@", parser.array);
                                                      if (parser.array != NULL) {
                                                          array = parser.array;
                                                          [loadingView removeFromSuperview];
                                                          [self.tableView reloadData];
                                                      }
                                                  }
                                                    onError:^() {
                                                        [loadingView dismiss];
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                    }];
    [portlet invoke];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"Location (# Units), Grp, Sub Grp, Type";
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return @"Location (# Units), Grp, Sub Grp, Type";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGYardCheck *item = [array objectAtIndex:indexPath.row];
    SGYardCheckListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YardCheckListCell"];
    [cell setYardCheck:item];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    SGYardCheckViewController *viewController = segue.destinationViewController;
    viewController.yardCheck = [array objectAtIndex:indexPath.row];
}

@end
