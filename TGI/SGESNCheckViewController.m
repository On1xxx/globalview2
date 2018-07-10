//
//  SGESNCheckViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGESNCheckViewController.h"
#import "SGAssetLocationViewController.h"

@implementation SGESNCheckViewController {
    NSString *_latitude;
    NSString *_longitude;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)viewDidLoad
{
    NSString *msg = [self.result objectForKey:@"msg"];
    NSLog(@"msg1 = %@", msg);

    NSString *msgDate = [self.result objectForKey:@"message_date"];
    NSLog(@"msgDate1 = %@", msgDate);
    
    if (msgDate) {
        NSString *msgDate2 = [msgDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSLog(@"msgDate2 = %@", msgDate2);
        
        msg = [msg stringByReplacingOccurrencesOfString:msgDate withString:msgDate2];
        NSLog(@"msg2 = %@", msg);
    }
    
    self.msgCell.detailTextLabel.text = msg;

    NSRange range = [msg rangeOfString:@"(lat, long) of"];
    if (range.length > 0) {
        NSLog(@"Location: %d, length: %d", range.location, range.length);
        NSString *tmp = [msg substringFromIndex:range.location + range.length];
        NSLog(@"Coord string: %@", tmp);
        NSArray *coords = [tmp componentsSeparatedByString:@","];
        NSLog(@"Coord array: %@", coords);
        _latitude = [[coords objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        _longitude = [[coords objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Map"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(showMap)];
        
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)showMap {
    NSLog(@"Showing map, latitude: %@, longitude: %@", _latitude, _longitude);
    [self performSegueWithIdentifier:@"SHOW_MAP" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SGAssetLocationViewController *controller = segue.destinationViewController;
    controller.latitude = _latitude;
    controller.longitude = _longitude;
}

@end
