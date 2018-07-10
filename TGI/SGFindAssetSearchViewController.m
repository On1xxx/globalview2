//
//  SGFindAssetSearchViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGFindAssetSearchViewController.h"
#import "SGFindAssetShortInfoViewController.h"
#import "SGPortlet.h"
#import "SGFindAssetParser.h"
#import "SGLoadingView.h"

@implementation SGFindAssetSearchViewController
{
    NSDictionary *asset;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)viewDidLoad
{
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.assetIdField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAsset:textField];
    return NO;
}

- (IBAction)searchAsset:(id)sender
{
    [self.assetIdField resignFirstResponder];
    
    NSString *assetId = self.assetIdField.text;
    NSLog(@"Searching for asset: [%@]", assetId);
    
    SGLoadingView *loadingView = [SGLoadingView loadingView:self.view];
    
    SGFindAssetParser *parser = [[SGFindAssetParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"TRKASSETSIMPLEDETAIL" 
                                                     parser:parser
                                                  onSuccess:^() {
                                                      if (parser.asset != NULL) {
                                                          NSLog(@"Asset %@ found", assetId);
                                                          asset = parser.asset;
                                                          [loadingView removeFromSuperview];
                                                          [self performSegueWithIdentifier:@"AssetFound" sender:self];
                                                      } else {
                                                          NSLog(@"Asset %@ not found", assetId);
                                                      }
                                                  }
                                                  onError:^() {
                                                      [loadingView dismiss];
                                                  }];
    [portlet addParameter:@"asset_id" value:assetId];
    [portlet invoke];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    SGFindAssetShortInfoViewController *controller = segue.destinationViewController;
    controller.asset = asset;
}

@end
