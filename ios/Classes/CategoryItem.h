//
//  CategoryItem.h
//  ItuDimana
//
//  Created by Pandu  Pradhana on 8/30/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryItem : NSObject {
	NSString *displayName;
	NSString *itemValue;
}

@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSString *itemValue;

-(id)initWithName:(NSString *)name value:(NSString *)value;

@end
