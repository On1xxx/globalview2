//
//  SGESNCheckSearchViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGESNCheckSearchViewController.h"
#import "SGESNCheckViewController.h"
#import "SGESNCheckParser.h"
#import "SGPortlet.h"
#import "SGLoadingView.h"

@implementation SGESNCheckSearchViewController
{
    NSDictionary *searchResult;
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
    [self.esnTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self search:textField];
    return NO;
}

- (IBAction)search:(id)sender
{
    NSString* esn = self.esnTextField.text;
    [self.esnTextField resignFirstResponder];
    
    NSLog(@"Search ESN: %@", esn);
    
    SGLoadingView *loadingView = [SGLoadingView loadingView:self.view];
    
    SGESNCheckParser *parser = [[SGESNCheckParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"ESNCHECK"
                                                     parser:parser
                                                  onSuccess:^() {
                                                      NSLog(@"result = %@", parser.result);
                                                      if (parser.result != NULL) {
                                                          [loadingView removeFromSuperview];
                                                          searchResult = parser.result;
                                                          [self performSegueWithIdentifier:@"ESNCheckSegue" sender:self];
                                                      }
                                                  }
                                                    onError:^() {
                                                        [loadingView removeFromSuperview];
                                                    }];
    [portlet addParameter:@"esn" value:self.esnTextField.text];
    [portlet invoke];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SGESNCheckViewController *viewController = segue.destinationViewController;
    viewController.result = searchResult;
}

@end
