//
//  FirstViewController.m
//  ItuDimana
//
//  Created by Pandu  Pradhana on 8/17/09.
//  Copyright Melati Group 2009. All rights reserved.
//

#import "FirstViewController.h"
#import "ChooseCategoryViewController.h"
#import "Constants.h"


#define HTTP_RESP_BAD_REQUEST 400

// Private interface 
@interface FirstViewController (Private)
- (void) setUIEnabled:(BOOL)isEnabled;
- (void) sendRequest;
- (void) getCurrentLocation;
- (void) removeWaitIndicator;
- (void) onFinishSubmit;
- (void) saveToLocal;
@end

static NSString *SCAN_LOCATION = @"Scan Location";
static NSString *STOPSCAN_LOCATION = @"Stop Scan Location";
static NSString *BOOKMARK_LOCATION = @"Bookmark";
static NSString *SAVING_LOCATION = @"Saving..";
static NSString *SCANNING_LOCATION = @"Scanning..";


@implementation FirstViewController

NSMutableData* receivedData;
//NSString *tmpGpsLat;
//NSString *tmpGpsLon;


@synthesize done, lblGPS, txtName, btnSubmit, btnStartStop, btnCategory, spinner,window,delegate;
//@synthesize place;
//@synthesize gpsLat, gpsLon;
@synthesize  managedObjectContext, addingManagedObjectContext,fetchedResultsController,category;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
    [super viewDidLoad];

	//Initialize ManagedObjectContext
	self.managedObjectContext = [delegate managedObjectContext];
	
	//place = [[Place alloc] init];
	
	[lblGPS setText:@""];
	[lblGPS setEditable:FALSE];

	[self setUIEnabled:FALSE];
	[btnStartStop setEnabled:TRUE];
	isCurrentlyUpdating = NO;
	firstUpdate = YES;
	
	[TheCLController sharedInstance].delegate = self;
	
	// Check to see if the user has disabled location services all together
    // In that case, we just print a message and disable the "Start" button
    if ( ! [TheCLController sharedInstance].locationManager.locationServicesEnabled ) {
        //[self addTextToLog:NSLocalizedString(@"NoLocationServices", @"User disabled location services")];
		[lblGPS setText: @"User disabled location services. Please turn on the Location Based Service from Settings"];
        btnStartStop.enabled = NO;
    }
	spinner.hidden = TRUE;
	[spinner setHidesWhenStopped:TRUE];
	[spinner stopAnimating];

	[txtName setKeyboardType:UIKeyboardTypeDefault];
	[txtName setReturnKeyType:UIReturnKeyDone];
	
	//Biar ada tanda 'x'-nya di field
	//[txtName setClearButtonMode:UITextFieldViewModeWhileEditing];
	
	//Manual assignment
	[txtName setDelegate:self];	
	//NSXMLParser *parser = [[NSXMLParser alloc] initWithData:<#(NSData *)data#>

	
	// Create a new managed object context for the new book --
	//set its persistent store coordinator to the same as that from the fetched results controller's context.
	/*
	NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	self.addingManagedObjectContext = addingContext;
	[addingContext release];
	
	[addingManagedObjectContext setPersistentStoreCoordinator:[[fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
	*/
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark ---- Button Action  ----

/**
 * This implementation 
 *
 */
- (IBAction)submitButtonPressed:(id)sender {
	//NSLog(@"Submit button Pressed");
	//[lblGPS setText:@"Sending Request to server"];
	[btnSubmit setTitle:SAVING_LOCATION forState: UIControlStateNormal];
	[btnSubmit setEnabled:FALSE];

	//NSLog(@"The Category %@",[place category]);
	//[place setName:[txtName text]];
	
	//UIActivityIndicatorView  *av = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
	UIActivityIndicatorView  *av = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	av.frame=CGRectMake(125, 150, 65, 65);
	av.tag  = 1;
	[av startAnimating];	
	[window addSubview:av];
	
	
	//NSString *_tmplat = [[place gpslat] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
	//NSString *_tmploc = [[place gpslon] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
	// open an alert with just an OK button
	if ((!gpsLat) || [gpsLat isEqualToString:@""]
		|| (!gpsLon) || [gpsLon isEqualToString:@""]) {
		AlertWithTitleAndMessage(@"Failed on GPS coordinate", @"Please wait while we're getting your location");
		[btnSubmit setTitle:BOOKMARK_LOCATION forState: UIControlStateNormal];		
		[self removeWaitIndicator];	
		[self onFinishSubmit];
		[self getCurrentLocation];		
		return;
	}
	
	NSString *_tmpname = [[txtName text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
	NSString *_tmpcat = [[self category] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
	
	// open an alert with just an OK button
	if ((!_tmpname) || [_tmpname isEqualToString:@""]) {
		AlertWithTitleAndMessage(@"Missing required value", @"Name cannot be empty");
		[btnSubmit setTitle:BOOKMARK_LOCATION forState: UIControlStateNormal];				
		[self removeWaitIndicator];					
		[self onFinishSubmit];
		[self getCurrentLocation];
		return;
	}
	if ((!_tmpcat) || [_tmpcat isEqualToString:@""]) {
		AlertWithTitleAndMessage(@"Missing required value", @"Category cannot be empty");
		[btnSubmit setTitle:BOOKMARK_LOCATION forState: UIControlStateNormal];				
		[self removeWaitIndicator];					
		[self onFinishSubmit];
		[self getCurrentLocation];
		return;		
	}
	
	
	if (![delegate offlineMode]) {
		//NSLog(@"Online Saving..  %@",[place name]);		
		[self sendRequest];
	} else {
		//NSLog(@"Saving..  %@, with category: %@",[place name], [place category]);
		[self saveToLocal];
		
	}
}

- (IBAction)startStopButtonPressed:(id)sender {
	if (isCurrentlyUpdating) {
		[self setUIEnabled:FALSE];
		[[TheCLController sharedInstance].locationManager stopUpdatingLocation];
		isCurrentlyUpdating = NO;
		[btnStartStop setTitle:SCAN_LOCATION forState: UIControlStateNormal];
		[spinner stopAnimating];
		NSString *_tstr = [[lblGPS text] stringByReplacingOccurrencesOfString:@"GPS" withString:@"Last Scan Location"];
		//[NSString stringWithFormat:@"%@\n%@",@"Last scan:",[lblGPS text]];
		[lblGPS setText:_tstr];		
	} else {
		[self setUIEnabled:TRUE];
		[[TheCLController sharedInstance].locationManager startUpdatingLocation];
		isCurrentlyUpdating = YES;
		[btnStartStop setTitle:STOPSCAN_LOCATION forState: UIControlStateNormal];
		[lblGPS setText:SCANNING_LOCATION];
		spinner.hidden = FALSE;
		[spinner startAnimating];
	}	
	
}


#pragma mark ---- Load Category Picker View 

- (IBAction) loadCategory:(id)sender {
	ChooseCategoryViewController *secondViewController = 
				[[[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil] autorelease];
	
	//[secondViewController setPlaceHolderDelegate:self];
	[secondViewController setThisViewParent:self];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:secondViewController];	
	[self presentModalViewController:navController animated:TRUE];	
	[navController release];	
	//NSLog(@"The view category is loaded");			
}



	
/**
 * Untuk Handle TextField
 * Current controller will automatically will be the responder
 *
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Revert the text field to the previous value.
	//textField.text = self.string; 
	[super touchesBegan:touches withEvent:event];
}
 */
	

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if ((theTextField == txtName)) {
		[theTextField resignFirstResponder];	
	}	
	return YES;
}

- (IBAction) doneButtonOnKeyboardPressed:(id)sender {  
}  


- (void)dealloc {
	[lblGPS release];
	[txtName release];
	[btnCategory release];
	[btnSubmit release];
	[btnStartStop release];
	[spinner release];
	//[place release];
	
	if (self.managedObjectContext) {
		[managedObjectContext release];
	}
	if (self.addingManagedObjectContext) {
		[addingManagedObjectContext release];
	}
	if (self.fetchedResultsController) {
		[fetchedResultsController setDelegate:nil];
		[fetchedResultsController release];
	}	
	//[place release];	
	[window release];
	[delegate release];	
    [super dealloc];
}



#pragma mark ---- NSURLConnection delegate implementation ----

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {  
	[receivedData setLength:0];  	

	if ([response isKindOfClass:[NSHTTPURLResponse self]]) {
		/* just an example of how to use NSHTTPURLResponse
		NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
		NSString *modified = [headers objectForKey:@"Last-Modified"];
		if (modified) {
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
			self.lastModified = [dateFormatter dateFromString:modified];
			[dateFormatter release];
		}
		else {
			self.lastModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
		}*/
		
		
		//Gak Pelu karena bakal di panggil di connectionDidFinishLoading
		//[self removeWaitIndicator];
		//[self onFinishSubmit];		
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
		if ([httpResponse statusCode] == HTTP_RESP_BAD_REQUEST) {
			AlertWithTitleAndMessage(@"Error while sending request to server", @"One of field is missing");
		}
	}	
}  

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {  
    [receivedData appendData:data];  
	done = YES;	
}  


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self removeWaitIndicator];	
	
	//URLCacheAlertWithError(error);
	//[self.delegate connectionDidFail:self];
	//NSLog(@"Error gilak %@",error);
	//AlertWithError(error);
	AlertWithTitleAndMessage(@"Failed",@"Error can't connect to Host, make sure you are connected to the internet");
	[connection release];
	done = YES;
	[self onFinishSubmit];	

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection  
{  
	[self removeWaitIndicator];	
    // do something with the data  
    // receivedData is declared as a method instance elsewhere  
	NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);  
	NSString *aStr = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];  
	NSLog(aStr);  
	
    // release the connection, and the data object  
    //[receivedData release];  
	[connection release];
	done = YES;	

	/* -- A fuckin stupid code :p */
	[self setUIEnabled:FALSE];
	[[TheCLController sharedInstance].locationManager stopUpdatingLocation];
	isCurrentlyUpdating = NO;
	[btnStartStop setTitle:SCAN_LOCATION forState: UIControlStateNormal];
	[spinner stopAnimating];
	[lblGPS setText:@""];

	AlertWithTitleAndMessage(@"Success", 
							 [NSString stringWithFormat:@"%@ is inserted to server",[txtName text]]);

	[self onFinishSubmit];

}  



#pragma mark ---- delegate methods for the TheCLController class ----

-(void)newLocationUpdate:(NSString *)text {
	[lblGPS setText:text];
}

-(void)newError:(NSString *)text {
	[lblGPS setText:text];
}


- (void) setNewGpsLat: (NSString* ) aGpslat {
	[gpsLat release];
	gpsLat = aGpslat;
	[aGpslat retain];
}


-(void) setNewGpsLon: (NSString* ) aGpslon {
	[gpsLon release];
	gpsLon = aGpslon;
	[aGpslon retain];	
}




#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	//Nothing man.
}




/**
 * Privates
 *
 */
- (void) setUIEnabled:(BOOL) isEnabled {

	[btnSubmit setEnabled: (BOOL)isEnabled];
	[btnSubmit setHidden:!isEnabled];
	[btnCategory setEnabled:isEnabled];
	
	
	//[btnStartStop setEnabled: (BOOL)!isEnabled];
	if (!isEnabled) {
		[txtName setText:@""];
	}
	[txtName setEnabled:(BOOL)isEnabled];	
}


/**
 * Send the request
 *
 */
- (void) sendRequest {
	
	NSMutableString *parameters = [[[NSMutableString alloc] init] autorelease];	
	[parameters appendFormat:@"gpsloclat=%@",gpsLat];
	[parameters appendFormat:@"&gpsloclon=%@",gpsLon];
	[parameters appendFormat:@"&name=%@",[txtName text]];
	[parameters appendFormat:@"&category=%@",[self category]];
	
	
	NSURL *url = [NSURL URLWithString:SERVER_URL_PUT_PLACE];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url]; 
	//NSString *post = @"gpslat=12.909090&gpslon=-109.1231234&name=test&category=aja";
	NSData *requestData = [parameters dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	/* This set of header IS A MUST */
	[request setHTTPMethod: @"POST"]; 
	[request setValue:[NSString stringWithFormat:@"%d",[requestData length]] forHTTPHeaderField:@"Content-Length"];  
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:requestData]; 
	
	done = FALSE;
	
	NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];  
    if (conn) {  
        receivedData = [[NSMutableData data] retain];  
    }   
    else {  
        // inform the user that the download could not be made  
		//NSLog(@"Error braee");
		AlertWithTitleAndMessage(@"Send information failed", @"Cannot connect to server");
    }  	
	
	/*
	 do {
	 NSLog(@"dudeee");
	 [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	 } while (!done);	
	 */
	
}



- (void) getCurrentLocation {
	// If it's not possible to get a location, then return.
	CLLocation *location = [[[TheCLController sharedInstance] locationManager] location];
	if (!location) {
		return;
	}
	
	// Configure the new event with information from the location.
	CLLocationCoordinate2D coordinate = [location coordinate];
	NSMutableString *update = [[[NSMutableString alloc] init] autorelease];
	[update appendFormat:
	 @"GPS:\nLat: %f\nLon: %f", 
	 coordinate.latitude,
	 coordinate.longitude];
	[update appendString:@"\n"];
	
	//[place setGpslat:[NSString stringWithFormat:@"%f",coordinate.latitude]];
	//[place setGpslon:[NSString stringWithFormat:@"%f",coordinate.longitude]];
	
	gpsLat =  [NSString stringWithFormat:@"%f",coordinate.latitude];
	gpsLon =  [NSString stringWithFormat:@"%f",coordinate.longitude];
	
	[self newLocationUpdate: update];
}
	

- (void) removeWaitIndicator {
	UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[window viewWithTag:1];
	[tmpimg removeFromSuperview];		
	
}


- (void) onFinishSubmit {
	[btnSubmit setEnabled:TRUE];
	[btnSubmit setTitle:BOOKMARK_LOCATION forState: UIControlStateNormal];		
}

/**
 * Make the place persistence
 *
 */
- (void) saveToLocal {
	
	// Create a new managed object context for the new book --
	//set its persistent store coordinator to the same as that from the fetched results controller's context.
	/*
	NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	self.addingManagedObjectContext = addingContext;
	[addingContext release];
	
	[addingManagedObjectContext setPersistentStoreCoordinator:[[fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
	
	 */
	 
	//addViewController.Place = (Place *)[NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:addingContext];

	[self removeWaitIndicator];	
	
	Place* _tosave = (Place *)[NSEntityDescription insertNewObjectForEntityForName:@"Tempat" inManagedObjectContext:self.managedObjectContext];		
	_tosave.name = [txtName text];
	_tosave.category = [self category];
	_tosave.gpslat = gpsLat;
	_tosave.gpslon = gpsLon;
	
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		NSString *errMessage = [NSString stringWithFormat: @"Message: %@",error];
		AlertWithTitleAndMessage(@"Error while saving to local", errMessage);
		//exit(-1);  // Fail
    } else {
		AlertWithTitleAndMessage(@"Success", 
								 [NSString stringWithFormat:@"%@ is inserted to local",[txtName text]]);
		
	}
		
	/* -- A fuckin stupid code :p */
	[self setUIEnabled:FALSE];
	[[TheCLController sharedInstance].locationManager stopUpdatingLocation];
	isCurrentlyUpdating = NO;
	[btnStartStop setTitle:SCAN_LOCATION forState: UIControlStateNormal];
	[spinner stopAnimating];
	[lblGPS setText:@""];
		
	[self onFinishSubmit];		
	
}


@end
