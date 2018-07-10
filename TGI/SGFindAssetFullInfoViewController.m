//
//  SGFindAssetFullInfoViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGFindAssetFullInfoViewController.h"
#import "SGAssetFullInfoCell.h"
#import "SGColor.h"
#import "SGFindAssetField.h"
#import "SGAssetLocationViewController.h"

@implementation SGFindAssetFullInfoViewController
{
    NSDictionary *_asset;
    NSMutableArray *fields;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithTitle:@"Map"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(showMap)];
        
        self.navigationItem.rightBarButtonItem = mapItem;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)appendFieldWithLabel:(NSString *)label key:(NSString *)key resize:(BOOL)resize
{
    SGFindAssetField *f = [[SGFindAssetField alloc] init];
    f.label = label;
    f.key = key;
    f.resize = resize;
    
    [fields addObject:f];
}

- (void)appendFieldWithLabel:(NSString *)label key:(NSString *)key
{
    [self appendFieldWithLabel:label key:key resize:NO];
}

- (void)appendFieldWithPattern:(NSString *)pattern labelFormat:(NSString *)format
{
    [self appendFieldWithPattern:pattern labelFormat:format resize:NO];
}

- (void)appendFieldWithPattern:(NSString *)pattern labelFormat:(NSString *)format resize:(BOOL)resize
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
                [self appendFieldWithLabel:label key:key resize:resize];
            }
        }
    }
}

- (void)setAsset:(NSDictionary *)asset
{
    _asset = asset;
    
    fields = [[NSMutableArray alloc] init];
    
    [self appendFieldWithLabel:@"Status" key:@"Status"];
    [self appendFieldWithLabel:@"Group" key:@"Group"];
    [self appendFieldWithLabel:@"Sub group" key:@"SubGroup"];
    [self appendFieldWithLabel:@"Type" key:@"Type"];
    [self appendFieldWithLabel:@"Description" key:@"Description"];
    [self appendFieldWithLabel:@"Battery Status" key:@"Battery_Status"];
    [self appendFieldWithLabel:@"Battery Status Date" key:@"Battery_Status_date"];
    [self appendFieldWithPattern:@"Battery_Status_date_(.+)" labelFormat:@"Battery Status Date %@" resize:YES];
    [self appendFieldWithLabel:@"ESN" key:@"ESN"];
    [self appendFieldWithLabel:@"Last Msg Date" key:@"Last_Message_date"];
    [self appendFieldWithPattern:@"Last_Message_date_(.+)" labelFormat:@"Last Msg Date %@"];
    [self appendFieldWithLabel:@"Last Loc" key:@"Last_Location"];
    [self appendFieldWithLabel:@"Last Latitude" key:@"Last_Latitude"];
    [self appendFieldWithLabel:@"Last Longitude" key:@"Last_Longitude"];
    [self appendFieldWithLabel:@"Last Landmark Date" key:@"Last_Landmark_Date"];
    [self appendFieldWithPattern:@"Last_Landmark_Date_(.+)" labelFormat:@"Last Landmark Date %@" resize:YES];
    [self appendFieldWithLabel:@"Last Landmark" key:@"Last_Landmark"];
    [self appendFieldWithLabel:@"VIN" key:@"VIN"];
    [self appendFieldWithLabel:@"Plate#" key:@"Plate_number"];
    [self appendFieldWithLabel:@"Serial#" key:@"Serial_number"];
    [self appendFieldWithLabel:@"Manufacture" key:@"Manufacture"];
    [self appendFieldWithLabel:@"Model" key:@"Model"];
    [self appendFieldWithLabel:@"Model Year" key:@"Model_year"];
    [self appendFieldWithLabel:@"Asset Currency" key:@"Asset_Currency"];
    [self appendFieldWithLabel:@"Asset Value" key:@"Asset_Value"];
    [self appendFieldWithLabel:@"Purchase Currency" key:@"Purchase_Currency"];
    [self appendFieldWithLabel:@"Purchase Value" key:@"Purchase_Value"];
    [self appendFieldWithLabel:@"Battery Status" key:@"Battery_Status"];
    [self appendFieldWithLabel:@"Battery Status Date" key:@"Battery_Status_date"];
    [self appendFieldWithPattern:@"Battery_Status_date_(.+)" labelFormat:@"Battery Status Date %@" resize:YES];
    [self appendFieldWithLabel:@"Odometer" key:@"Odometer"];
    [self appendFieldWithLabel:@"Odometer Date" key:@"Odometer_Date"];
    [self appendFieldWithPattern:@"Odometer_Date_(.+)" labelFormat:@"Odometer Date %@"];
    [self appendFieldWithLabel:@"Purchase" key:@"Purchase_Date"];
    [self appendFieldWithPattern:@"Purchase_Date_(.+)" labelFormat:@"Purchase %@"];
    [self appendFieldWithLabel:@"Fleet" key:@"Fleet_Date"];
    [self appendFieldWithPattern:@"Fleet_Date_(.+)" labelFormat:@"Fleet %@"];
    [self appendFieldWithLabel:@"Retire" key:@"Retire_Date"];
    [self appendFieldWithPattern:@"Retire_Date_(.+)" labelFormat:@"Retire %@"];
    [self appendFieldWithLabel:@"Activation" key:@"Activation_Date"];
    [self appendFieldWithPattern:@"Activation_Date_(.+)" labelFormat:@"Activation %@"];
    [self appendFieldWithLabel:@"Date 1" key:@"User_Date1"];
    [self appendFieldWithPattern:@"User_Date1_(.+)" labelFormat:@"Date 1 %@"];
    [self appendFieldWithLabel:@"Date 2" key:@"User_Date2"];
    [self appendFieldWithPattern:@"User_Date2_(.+)" labelFormat:@"Date 2 %@"];
    [self appendFieldWithLabel:@"Date 3" key:@"User_Date3"];
    [self appendFieldWithPattern:@"User_Date3_(.+)" labelFormat:@"Date 3 %@"];
    [self appendFieldWithLabel:@"Amount 1" key:@"User_Amount1"];
    [self appendFieldWithLabel:@"Amount 2" key:@"User_Amount2"];
    [self appendFieldWithLabel:@"Amount 3" key:@"User_Amount3"];
    [self appendFieldWithLabel:@"Code 1" key:@"User_Code1"];
    [self appendFieldWithLabel:@"Code 2" key:@"User_Code2"];
    [self appendFieldWithLabel:@"Code 3" key:@"User_Code3"];
    [self appendFieldWithLabel:@"Text 1" key:@"User_Text1"];
    [self appendFieldWithLabel:@"Text 2" key:@"User_Text2"];
    [self appendFieldWithLabel:@"Text 3" key:@"User_Text3"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : [fields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGAssetFullInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetDetailsCell"];

    if (indexPath.section == 0) {
        [cell setLabel:@"Asset ID" value:[_asset valueForKey:@"Asset_ID"] color:[SGColor orange]];
    } else {
        SGFindAssetField *f = [fields objectAtIndex:indexPath.row];
        [cell setLabel:f.label value:[_asset valueForKey:f.key] color:[UIColor blackColor]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 52;
    } else {
        SGFindAssetField *f = [fields objectAtIndex:indexPath.row];
        return f.resize ? 73 : 52;
    }
}

- (void)showMap {
    NSLog(@"Showing map");
    [self performSegueWithIdentifier:@"SHOW_MAP" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SGAssetLocationViewController *controller = segue.destinationViewController;
    controller.latitude = [_asset valueForKey:@"Last_Latitude"];
    controller.longitude = [_asset valueForKey:@"Last_Longitude"];
}

@end
