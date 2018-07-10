//
//  SGAssetLocationViewController.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SGAssetLocationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeControl;
@property (weak, nonatomic) IBOutlet UIStepper *zoomStepper;

@property (strong, nonatomic) NSString *assetId;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

- (IBAction)done:(id)sender;
- (IBAction)onMapTypeChanged:(id)sender;
- (IBAction)zoomChanged:(UIStepper *)sender;

@end
