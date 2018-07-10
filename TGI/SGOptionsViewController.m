//
//  SGSetupViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGOptionsViewController.h"
#import "SGOptionsFontSizeViewController.h"
#import "SGUserSettings.h"
#import "SGLoadingView.h"
#import "SGPortlet.h"
#import "SGInspectionSchemaParser.h"

@implementation SGOptionsViewController
{
    NSInteger fontSize;
    SGLoadingView *_loadingView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)viewDidLoad
{
    self.companyTextView.text = [SGUserSettings company];
    self.companyTextView.delegate = self;
    self.usernameTextView.text = [SGUserSettings username];
    self.usernameTextView.delegate = self;
    self.passwordTextView.text = [SGUserSettings password];
    self.passwordTextView.delegate = self;
    self.registeredOwnerTextField.text = [SGUserSettings registeredOwner];
    self.registeredOwnerTextField.delegate = self;
    self.inspectorTextField.text = [SGUserSettings inspector];
    self.inspectorTextField.delegate = self;
    self.serverTextField.text = [SGUserSettings serverURL];
    self.serverTextField.delegate = self;
    [self showSchemaAvailability];
    [self setFontSize:[SGUserSettings fontSize]];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:(NSString *)kCFBundleVersionKey];
    self.versionLabel.text = version;
    
    if (![SGUserSettings acceptanceDate]) {
        [self performSegueWithIdentifier:@"TermsSegue" sender:self];
    }
}

- (void)setFontSize:(NSInteger)size
{
    fontSize = size;
    [self setFontSizeText:size];
}

- (void)setFontSizeText:(NSInteger)size
{
    switch (size) {
        case 0:
            self.fontSizeLabel.text = @"Small";
            break;
        case 1:
            self.fontSizeLabel.text = @"Medium";
            break;
        case 2:
            self.fontSizeLabel.text = @"Large";
            break;
    }
}

- (IBAction)save:(id)sender
{
    [SGUserSettings setCompany:self.companyTextView.text];
    [SGUserSettings setUsername:self.usernameTextView.text];
    [SGUserSettings setPassword:self.passwordTextView.text];
    [SGUserSettings setRegisteredOwner:self.registeredOwnerTextField.text];
    [SGUserSettings setInspector:self.inspectorTextField.text];
    [SGUserSettings setServerURL:self.serverTextField.text];
    [SGUserSettings setFontSize:fontSize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    SGOptionsFontSizeViewController *fontSizeController = segue.destinationViewController;
//    fontSizeController.optionsController = self;
//    fontSizeController.fontSize = fontSize;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.getSchemaCell) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Get inspection schema"
                                                            message:@"Enter asset id:"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.placeholder = @"Asset ID";
        [alertView show];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
    NSString *assetId = [alertView textFieldAtIndex:0].text;
    NSLog(@"Asset: %@", assetId);
    [self getInspectionSchemaForAsset:assetId];
}

- (void)getInspectionSchemaForAsset:(NSString *)assetId
{
    _loadingView = [SGLoadingView loadingView:self.view];
    
    SGInspectionSchemaParser *parser = [[SGInspectionSchemaParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"INSPECTION_SCHEMA"
                                                     parser:parser
                                                  onSuccess:^{
                                                      [SGUserSettings setInspectionSchema:parser.xml];
                                                      [self showSchemaAvailability];
                                                      [_loadingView dismiss];
                                                  }];
    [portlet addParameter:@"asset_id" value:assetId];
    [portlet invoke];
}

- (void)showSchemaAvailability
{
    if ([SGUserSettings inspectionSchema] == nil) {
        self.getSchemaCell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.getSchemaCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}


@end
