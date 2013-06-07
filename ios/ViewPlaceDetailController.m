//
//  ViewPlaceDetail.m
//  ItuDimana
//
//  Created by Pandu  Pradhana on 9/17/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import "ViewPlaceDetailController.h"
#import "ParkPlaceMark.h"


@implementation ViewPlaceDetailController

@synthesize googleMap, place;


// The designated initializer. 
//Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil place:(Place *) place {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		//_coordinate = coordinate;		
		[self setPlace:place];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	MKCoordinateRegion region;
	/*
	region.center.latitude = -6.291013;
	region.center.longitude = 106.802304;
	*/
	
	region.center.latitude = [place.gpslat doubleValue];
	region.center.longitude = [place.gpslon doubleValue];	
	
	region.span.latitudeDelta = 0.0039;
	region.span.longitudeDelta = 0.0034;
	[googleMap setRegion:region animated:TRUE];
	googleMap.showsUserLocation = TRUE;
	[googleMap regionThatFits:region];

	/*
	CLLocationCoordinate2D location;
	location.latitude = -6.291013;
	location.longitude = 106.802304;
	 */
	
	ParkPlaceMark *placemark=[[ParkPlaceMark alloc] initWithCoordinate:region.center];
	placemark.title = place.name;
	placemark.subtitle = place.category;
	[googleMap addAnnotation:placemark];
	
	[placemark release];
	
	//Gak perlu dulu deh
	//[googleMap setDelegate:self];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark --- For MKMapViewDelegate

/*
 Ntar dulu deh
 
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
	NSLog(@"This is called");
	MKPinAnnotationView *test=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingloc"];
	if([annotation title]==@"SHIT Parked Location")
	{
		[test setPinColor:MKPinAnnotationColorPurple];
	}
	else
	{
		[test setPinColor:MKPinAnnotationColorGreen];
	}
	return test;
}
*/


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
