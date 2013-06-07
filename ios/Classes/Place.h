//
//  Place.h
//  ItuDimana
//
//  Created by Pandu  Pradhana on 8/21/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Place : NSManagedObject {
	/*
	NSString *gpslat;
	NSString *gpslon;
	NSString *name;
	NSString *category;
	*/
}

@property (nonatomic, retain) NSString *gpslat;
@property (nonatomic, retain) NSString *gpslon;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *category;

@end
