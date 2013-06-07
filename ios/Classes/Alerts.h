//
//  Alerts.h
//  Holds a convenience method for showing alert. The logic taken from URLCache example from Apple Inc
//
//  Created by Pandu  Pradhana on 8/22/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * We just provide bunch of methods
 *
 */
void AlertWithError(NSError *error);
void AlertWithMessage(NSString *message);
void AlertWithTitleAndMessage(NSString *title, NSString *message);
void AlertWithMessageAndDelegate(NSString *message, id delegate);

