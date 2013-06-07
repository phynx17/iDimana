//
//  ViewPlaceDetail.h
//  ItuDimana
//
//  Created by Pandu  Pradhana on 9/17/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Place.h"

@interface ViewPlaceDetailController : UIViewController <MKMapViewDelegate>{
	IBOutlet MKMapView *googleMap;
	//CLLocationCoordinate2D _coordinate; 
	Place *place;
}

@property (nonatomic,retain)IBOutlet MKMapView *googleMap;
@property (nonatomic,retain) Place *place;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil place:(Place *) place;

@end
