//
//  SGRemoveESNViewController.m
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import "SGRemoveESNViewController.h"
#import "SGRemoveESNParser.h"
#import "SGPortlet.h"
#import "SGFindAssetParser.h"
#import "SGLoadingView.h"
#import "SGRemoveESN.h"
#import "SGRemoveESNCommentViewController.h"

@implementation SGRemoveESNViewController {
    SGRemoveESN *_obj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _obj = [[SGRemoveESN alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    self.commentTextField.text = _obj.comment;
    [super viewWillAppear:animated];
}

- (IBAction)save:(id)sender {
    if (self.assetIdTextField.text.length == 0) {
        [self showError:@"Asset ID must be filled in"];
        return;
    }
    if (self.commentTextField.text.length == 0) {
        [self showError:@"Removal comment must be filled in"];
        return;
    }

    SGLoadingView *loadingView = [SGLoadingView loadingView:self.view];
    
    SGRemoveESNParser *parser = [[SGRemoveESNParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"TRKESNREMOVE"
                                                     parser:parser
                                                  onSuccess:^() {
                                                      if (parser.messages != NULL) {
                                                          [self showMessages:parser.messages];
                                                      }
                                                  }
                                                    onError:^() {
                                                        [loadingView dismiss];
                                                    }];
    [portlet addParameter:@"asset_id" value:self.assetIdTextField.text];
    [portlet addParameter:@"removal_comment" value:self.commentTextField.text];
    [portlet invoke];
}

- (void)showMessages:(NSArray *)messages {
    NSString *title = messages[0];
    NSString *message = messages[1];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showError:(NSString *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:error
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SGRemoveESNCommentViewController *controller = segue.destinationViewController;
    controller.obj = _obj;
}

@end
