//
//  SGInspectionListTabBarController.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionListTabBarController.h"
#import "SGInspectionTabBarController.h"
#import "SGPendingInspectionListController.h"

NSInteger const BUTTON_CANCEL = 0;
NSInteger const BUTTON_OK = 1;

@implementation SGInspectionListTabBarController

- (void)viewDidLoad {
    SGPendingInspectionListController *controller = self.viewControllers[1];
    [controller findPendingInspections];
}

- (void)newInspection {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New inspection"
                                                        message:@"Enter asset id:"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder = @"Asset ID";
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == BUTTON_CANCEL) {
        return;
    }
    UITextField *textField = [alertView textFieldAtIndex:0];
    [self performSegueWithIdentifier:@"NEW_INSPECTION" sender:textField.text];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"New inspection, asset id: %@", sender);
    SGInspectionTabBarController *controller = segue.destinationViewController;
    controller.assetId = sender;
}

@end
