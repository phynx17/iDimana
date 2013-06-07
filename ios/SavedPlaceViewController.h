//
//  SavedPlaceViewController.h
//  ItuDimana
//
//  Created by Pandu  Pradhana on 9/9/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alerts.h"

@protocol SavedPlaceViewControllerDelegate;

@class ItuDimanaAppDelegate;

@interface SavedPlaceViewController : UITableViewController<NSFetchedResultsControllerDelegate> {
	ItuDimanaAppDelegate *ituDimanaAppDelegate;
	id <SavedPlaceViewControllerDelegate> delegate;	
	NSFetchedResultsController *fetchedResultsController;		
}


@property (nonatomic, assign) id <SavedPlaceViewControllerDelegate> delegate;
@property(nonatomic, retain) ItuDimanaAppDelegate *ituDimanaAppDelegate;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (IBAction)done:(id)sender;

@end

/**
 * Now the delegate for this controller
 *
 */
@protocol SavedPlaceViewControllerDelegate
- (void)addViewController:(SavedPlaceViewController *)controller didFinishWithSave:(BOOL)save;
@end

