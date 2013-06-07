//
//  CategoryItem.m
//  ItuDimana
//
//  Created by Pandu  Pradhana on 8/30/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import "CategoryItem.h"


@implementation CategoryItem

@synthesize itemValue, displayName;

-(id)initWithName:(NSString *)name value:(NSString *)value {
	self = [super init];
	if (self != nil) {
		self.displayName = name;
		self.itemValue = value;
	}
	return self;	
}

@end
