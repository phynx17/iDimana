//
//  TheCLController.h
//  ItuDimana
//
//	The idea is taken from example code of LocateMe Application by Apple, Inc
//
//  Created by Pandu  Pradhana on 8/18/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import "PlaceHolderDelegate.h"

// This protocol is used to send the text for location updates back to another view controller
@protocol TheCLControllerDelegate <PlaceHolderDelegate>
@required
-(void)newLocationUpdate:(NSString *)text;
-(void)newError:(NSString *)text;
@end

@interface TheCLController : NSObject<CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	id delegate;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic,assign) id <TheCLControllerDelegate> delegate;


- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

+ (TheCLController *)sharedInstance;

@end
