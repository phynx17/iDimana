//
//  ParkPlaceMark.h
//  ItuDimana
//
//	http://blog.objectgraph.com/index.php/2009/04/08/iphone-sdk-30-playing-with-map-kit-part-3/
//
//  Created by Pandu  Pradhana on 9/18/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface ParkPlaceMark : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *subtitle;
	NSString *title;	
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *title;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;
/*
- (NSString *)subtitle;
- (NSString *)title;
*/
@end

