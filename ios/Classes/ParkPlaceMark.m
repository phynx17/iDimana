//
//  ParkPlaceMark.m
//  ItuDimana
//
//  Created by Pandu  Pradhana on 9/18/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import "ParkPlaceMark.h"

@implementation ParkPlaceMark

@synthesize coordinate;
@synthesize subtitle, title;

/*
- (NSString *)subtitle{
	return @"Put some text here";
}
- (NSString *)title{
	return @"Parked Location";
}
 */

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}
@end