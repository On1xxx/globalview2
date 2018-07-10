//
//  SGFindAssetShortInfoViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGFindAssetShortInfoViewController.h"
#import "SGFindAssetFullInfoViewController.h"
#import "SGAssetFullInfoCell.h"
#import "SGColor.h"
#import "SGPair.h"
#import "SGAssetLocationViewController.h"

@implementation SGFindAssetShortInfoViewController
{
    NSMutableArray *_fields;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithTitle:@"Map"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(showMap)];
        
        UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithTitle:@"More"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(showMore)];

        self.navigationItem.rightBarButtonItems = @[moreItem, mapItem];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)appendFieldWithLabel:(NSString *)label key:(NSString *)key
{
    [_fields addObject:[SGPair pairWithKey:key value:label]];
}

- (void)appendFieldWithPattern:(NSString *)pattern labelFormat:(NSString *)format
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionSearch | NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        return;
    }
    for (NSString *key in _asset) {
        NSArray *matches = [regex matchesInString:key
                                          options:0
                                            range:NSMakeRange(0, [key length])];
        for (NSTextCheckingResult *match in matches) {
            if ([match numberOfRanges] == 2) {
                NSRange range = [match rangeAtIndex:1];
                NSString *name = [key substringWithRange:range];
                NSLog(@"name: %@", name);
                NSString *label = [NSString stringWithFormat:format, name];
                NSLog(@"label: %@", label);
                [self appendFieldWithLabel:label key:key];
            }
        }
    }
}

- (void)setAsset:(NSDictionary *)asset
{
    _asset = asset;
    
    _fields = [[NSMutableArray alloc] init];
    
    [self appendFieldWithLabel:@"Status" key:@"Status"];
    [self appendFieldWithLabel:@"Last Landmark" key:@"Last_Landmark"];
    [self appendFieldWithLabel:@"Last Msg Date" key:@"Last_Message_date"];
    [self appendFieldWithPattern:@"Last_Message_date_(.*)" labelFormat:@"Last Msg Date %@"];
    [self appendFieldWithLabel:@"Last Loc" key:@"Last_Location"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : [_fields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGAssetFullInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetDetailsCell"];
    
    if (indexPath.section == 0) {
        [cell setLabel:@"Asset ID" value:[_asset valueForKey:@"Asset_ID"] color:[SGColor orange]];
    } else {
        SGPair *f = [_fields objectAtIndex:indexPath.row];
        NSString *label = f.value;
        NSString *value = [_asset valueForKey:f.key];
        [cell setLabel:label value:value color:[UIColor blackColor]];
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SHOW_MORE"]) {
        SGFindAssetFullInfoViewController *controller = segue.destinationViewController;
        controller.asset = self.asset;
    } else {
        SGAssetLocationViewController *controller = segue.destinationViewController;
        controller.latitude = [self.asset valueForKey:@"Last_Latitude"];
        controller.longitude = [self.asset valueForKey:@"Last_Longitude"];
    }
}

- (void)showMap {
    NSLog(@"Showing map");
    [self performSegueWithIdentifier:@"SHOW_MAP" sender:self];
}

- (void)showMore {
    NSLog(@"Showing more");
    [self performSegueWithIdentifier:@"SHOW_MORE" sender:self];
}

@end
