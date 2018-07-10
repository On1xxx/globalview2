//
//  SGTermsOfUseViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGTermsOfUseViewController.h"
#import "SGUserSettings.h"

@implementation SGTermsOfUseViewController
{
    BOOL accepted;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)viewDidLoad
{
    NSDate *date = [SGUserSettings acceptanceDate];
    NSLog(@"acceptance date = %@", date);
    if (date) {
        accepted = YES;
        self.okButtonItem.title = @"OK";
        self.cancelButtonItem.customView = [[UIView alloc] init];
    } else {
        accepted = NO;
    }
}

- (IBAction)ok:(id)sender
{
    [SGUserSettings setAcceptanceDate:[NSDate date]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    exit(0);
}

- (void)viewDidUnload {
    [self setOkButtonItem:nil];
    [self setCancelButtonItem:nil];
    [super viewDidUnload];
}
@end
