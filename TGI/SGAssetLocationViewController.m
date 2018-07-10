//
//  SGAssetLocationViewController.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGAssetLocationViewController.h"
#import "SGAssetLocation.h"

#define METERS_PER_MILE 1609.344

@implementation SGAssetLocationViewController {
    double _zoom;
}

- (void)viewDidLoad {
    self.zoomStepper.value = 18;
    self.zoomStepper.minimumValue = 0;
    self.zoomStepper.maximumValue = 18;
    
    self.mapView.mapType = MKMapTypeStandard;
    
    NSLog(@"Latitude: %@, longitude: %@", self.latitude, self.longitude);
    SGAssetLocation *location = [[SGAssetLocation alloc] initWithLatitude:self.latitude
                                                                longitude:self.longitude];
    [self.mapView addAnnotation:location];
    
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//                                                                       5 * METERS_PER_MILE,
//                                                                       5 * METERS_PER_MILE);
    MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
    [self adjustCoordinateSpan:&span zoom:self.zoomStepper.value];
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onMapTypeChanged:(id)sender {
    UISegmentedControl *control = sender;
    if (control.selectedSegmentIndex == 0) {
        self.mapView.mapType = MKMapTypeStandard;
    } else {
        self.mapView.mapType = MKMapTypeSatellite;
    }
}

- (IBAction)zoomChanged:(UIStepper *)sender {
    MKCoordinateRegion region = self.mapView.region;
    MKCoordinateSpan span = self.mapView.region.span;
    [self adjustCoordinateSpan:&span zoom:sender.value];
    region.span = span;
    [self.mapView setRegion:region animated:YES];
}

- (void)adjustCoordinateSpan:(MKCoordinateSpan *)span zoom:(int)zoomLevel {
    span->latitudeDelta = [self zoomToDelta:zoomLevel];
    span->longitudeDelta = [self zoomToDelta:zoomLevel];
}

- (CLLocationDegrees)zoomToDelta:(int)zoom {
    if (zoom == 0) {
        return 50;
    } else if (zoom == 1) {
        return 25;
    } else if (zoom == 2) {
        return 10;
    } else if (zoom == 3) {
        return 5;
    } else if (zoom == 4) {
        return 2;
    } else if (zoom == 5) {
        return 1.5;
    } else if (zoom == 6) {
        return 1.25;
    } else if (zoom == 7) {
        return 1.0;
    } else if (zoom == 8) {
        return 0.75;
    } else if (zoom == 9) {
        return 0.5;
    } else if (zoom == 10) {
        return 0.25;
    } else if (zoom == 11) {
        return 0.1;
    } else if (zoom == 12) {
        return 0.075;
    } else if (zoom == 13) {
        return 0.05;
    } else if (zoom == 14) {
        return 0.025;
    } else if (zoom == 15) {
        return 0.0125;
    } else if (zoom == 16) {
        return 0.01;
    } else if (zoom == 17) {
        return 0.0075;
    } else if (zoom == 18) {
        return 0.005;
    } else {
        return 1.0;
    }
}

@end
