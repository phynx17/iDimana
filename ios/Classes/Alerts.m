//
//  Alerts.m
//  ItuDimana
//
//  Created by Pandu  Pradhana on 8/22/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import "Alerts.h"

NSString *ALERT_TITLE = @"Alert Title";


void AlertWithError(NSError *error)
{
	/*
    NSString *message = [NSString stringWithFormat:@"Error! %@ %@",
						 [error localizedDescription],
						 [error localizedFailureReason]];
	*/
    NSString *message = [NSString stringWithFormat:@"Error! %@",
						 [error localizedDescription]];
	
	AlertWithTitleAndMessage (@"Error",message);
}


void AlertWithMessage(NSString *message)
{
	/* open an alert with an OK button */
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
										message:message
										delegate:nil 
										cancelButtonTitle:@"OK" 
										otherButtonTitles: nil];
	[alert show];
	[alert release];
}


void AlertWithTitleAndMessage(NSString *title, NSString *message) {
	/* open an alert with an OK button */
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release];	
}



void AlertWithMessageAndDelegate(NSString *message, id delegate)
{
	/* open an alert with OK and Cancel buttons */
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
													message:message
												   delegate:delegate 
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles: @"OK", nil];
	[alert show];
	[alert release];
}

