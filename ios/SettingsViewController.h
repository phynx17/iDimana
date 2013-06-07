//
//  SettingsViewController.h
//  ItuDimana
//
//  Created by Pandu  Pradhana on 8/30/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavedPlaceViewController.h"
#import "ItuDimanaAppDelegate.h"


@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SavedPlaceViewControllerDelegate> {
	UITableView	*myTableView;	
	UISwitch *offlinemodeSwitch;
	UIButton *btnSavedData;
	UIButton *btnUploadData;	
	ItuDimanaAppDelegate *ituDimanaAppDelegate;
	NSMutableData* receivedData;
}

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) ItuDimanaAppDelegate *ituDimanaAppDelegate;

#pragma mark -- For HTTP Connection 
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void) connectionDidFinishLoading:(NSURLConnection *)connection;


@end
