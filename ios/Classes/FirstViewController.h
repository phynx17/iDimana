//
//  FirstViewController.h
//  ItuDimana
//
//  Created by Pandu  Pradhana on 8/17/09.
//  Copyright Melati Group 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"
#import "Alerts.h"
#import "TheCLController.h"
#import "ItuDimanaAppDelegate.h"

@interface FirstViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,TheCLControllerDelegate> {
	IBOutlet UITextView *lblGPS;
	IBOutlet UITextField *txtName;
	//IBOutlet UITextField *txtCategory;
	IBOutlet UIButton *btnStartStop;
	IBOutlet UIButton *btnCategory;	
	IBOutlet UIButton *btnSubmit;
	IBOutlet UIActivityIndicatorView *spinner;
	
	BOOL isCurrentlyUpdating;
	BOOL firstUpdate;	
	//Place *place;
    
	// Overall state of the parser, used to exit the run loop.
    BOOL done;
	
    UIWindow *window;	
	IBOutlet ItuDimanaAppDelegate *delegate;
	
	/**
	 * For Core Data
	 *
	 */
    NSManagedObjectContext *managedObjectContext;	    
	NSFetchedResultsController *fetchedResultsController;	
    NSManagedObjectContext *addingManagedObjectContext;		
	
	NSString *category;
	NSString *gpsLat;
	NSString *gpsLon;
	
}

@property BOOL done;
@property (nonatomic, retain) UITextView *lblGPS;
@property (nonatomic, retain) UITextField *txtName;
//@property (nonatomic, retain) UITextField *txtCategory;
@property (nonatomic, retain) UIButton *btnStartStop;
@property (nonatomic, retain) UIButton *btnSubmit;
@property (nonatomic, retain) UIButton *btnCategory;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

//@property (nonatomic, retain) Place *place;

@property (nonatomic, retain) ItuDimanaAppDelegate *delegate;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) NSString *category;
//@property (nonatomic, retain) NSString *gpsLat;
//@property (nonatomic, retain) NSString *gpsLon;


- (IBAction) submitButtonPressed:(id)sender;
- (IBAction) startStopButtonPressed:(id)sender;
- (IBAction) loadCategory:(id)sender;

- (void) sendRequest;


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void) connectionDidFinishLoading:(NSURLConnection *)connection;

@end
