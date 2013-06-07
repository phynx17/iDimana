//
//  PlaceHolderDelegate.h
//  ItuDimana
//
//  Created by Pandu  Pradhana on 8/30/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

@protocol PlaceHolderDelegate <NSObject>
-(void) setNewGpsLat: (NSString* )aGpslat;
-(void) setNewGpsLon: (NSString* )aGpslon;
@end

