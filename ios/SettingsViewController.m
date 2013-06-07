//
//  SettingsViewController.m
//  ItuDimana
//
//  Created by Pandu  Pradhana on 8/30/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import "SettingsViewController.h"
#import "DisplayCell.h"
#import "Constants.h"
#import "ItuDimanaAppDelegate.h"
#import "SavedPlaceViewController.h"
#import "Alerts.h"
#import "Place.h"


// Private interface 
@interface SettingsViewController (Private)
- (void) createOfflineSwitch;
- (void) createButton;
- (void) createButtonUpload;
- (void) sendRequest:(Place *) place;
- (void) removeWaitIndicator;
@end


@implementation SettingsViewController

@synthesize myTableView, ituDimanaAppDelegate;


/**
 * Enumeration sections
 *
 */
enum SettingsSections {
	offlinemode_section = 0,
	localdata_section,
	localdata_section2,
};


BOOL isLastDataUploaded = FALSE;
NSArray *thelocaldata = nil;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
											   style:UITableViewStyleGrouped];	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.autoresizesSubviews = YES;

	//[[self navigationItem] setTitle:@"Settings"];
	//Title ini akan muncul di TabBar, jadi gak perlu di ubah uda di set di IB
	//[self setTitle:@"Settings"];	
	
	self.view = myTableView;
	
	[self createOfflineSwitch];
	[self createButton];
	[self createButtonUpload];
	
	self.ituDimanaAppDelegate = (ItuDimanaAppDelegate*) [[UIApplication sharedApplication] delegate];	
	/*
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"At Startup Unresolved error %@, %@", error, [error userInfo]);
		AlertWithTitleAndMessage(@"Unresolved error", [NSString stringWithFormat:@"%@",error]);
		exit(-1);  // Fail
	}	
	 */
	
}



-(void) viewDidAppear:(BOOL) animated {
	//[super viewWillAppear:animated];
	[super viewDidAppear:animated];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tempat" inManagedObjectContext: [ituDimanaAppDelegate managedObjectContext]];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSSortDescriptor *categoryDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, categoryDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSError *error;
	thelocaldata = [[ituDimanaAppDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	if (!thelocaldata) {
		// Update to handle the error appropriately.
		NSLog(@"Pas viewDidLoad SettingsViewController %@, %@", error, [error userInfo]);
		AlertWithTitleAndMessage(@"Unresolved error", [NSString stringWithFormat:@"%@",error]);
		exit(-1);  // Fail
	}	
	
	
	// Memory management.
	[fetchRequest release];
	[nameDescriptor release];
	[categoryDescriptor release];
	[sortDescriptors release];
	
	NSLog(@"Boo %d",[thelocaldata count]);
	if ([thelocaldata count] > 0) {
		btnUploadData.enabled = TRUE;
	} else {
		btnUploadData.enabled = FALSE;
		[btnUploadData setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
	}
	
	
}



#pragma mark - UITableView delegates

// if you want the entire table to just be re-orderable then just return UITableViewCellEditingStyleNone
//
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3; //[SettingsSections size];
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *title;
	switch (section) {
		case offlinemode_section: {
			title = @"";
			break;
		}			
		case localdata_section: {
			title = @"Local Data";
			break;
		}			
		case localdata_section2: {
			title = @"";
			break;
		}			
			
	}
	return title;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case offlinemode_section: {
			return 1;
		}			
		case localdata_section: {
			return 1;
		}
		case localdata_section2: {
			return 1;
		}				
	}
	//Default
	return 3;
}

// to determine specific row height for each cell, override this.  In this example, each row is determined
// buy the its subviews that are embedded.
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat result;
	
	switch ([indexPath row])
	{
		case 0:
		{
			result = kUIRowHeight;
			break;
		}
		case 1:
		{
			result = kUIRowLabelHeight;
			break;
		}
	}
	
	return result;
}
*/
 
 
// utility routine leveraged by 'cellForRowAtIndexPath' to determine which UITableViewCell to be used on a given row
//
/**
 * Actually taken from from UICatalog example, and how here we don't need categorization
 * for the double row cell section, since we don't use a section here
 */
- (UITableViewCell *)obtainTableCellForRow:(NSInteger)row {
	UITableViewCell *cell = nil;

	if (row == 0) {
		cell = [myTableView dequeueReusableCellWithIdentifier:kDisplayCell_ID];
	}
	
	if (cell == nil) {
		/* Currently all cells are equal
		if (row == 0) {
			cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:kDisplayCell_ID] autorelease];
		} else if (row == 1) {
			cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:kDisplayCell_ID] autorelease];
		} else if (row == 2) {
			cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:kDisplayCell_ID] autorelease];
		}*/
		cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:kDisplayCell_ID] autorelease];
	}
	
	return cell;
}
 


// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger row = [indexPath row];	
	UITableViewCell *cell = [self obtainTableCellForRow:row];
	
	//We don't deadl with indexPath section
	switch (indexPath.section) {
		case offlinemode_section: {
			if (row == 0) {
				// this cell hosts the gray button
				//((DisplayCell *)cell).nameLabel.text = @"Offline Mode";
				//((DisplayCell *)cell).view = grayButton;
				//cell = offlinemodeSwitch;
				((DisplayCell *)cell).nameLabel.text = @"Offline Mode";
				((DisplayCell *)cell).view = offlinemodeSwitch;
				
			}
			break;
		}
		case localdata_section: {
			if (row == 0) {
				((DisplayCell *)cell).nameLabel.text = @"Saved Locations";
				((DisplayCell *)cell).view = btnSavedData;				
			}
			break;
		}
		case localdata_section2: {
			if (row == 0) {
				((DisplayCell *)cell).nameLabel.text = @"Upload Saved Place";
				((DisplayCell *)cell).view = btnUploadData;				
			}	
			break;
		}			
			
	}
	
	return cell;
}


#pragma mark -- Create the UI

- (void)createOfflineSwitch {	
	CGRect frame = CGRectMake(0.0, 0.0, kStdSwitchWidth, kStdSwitchHeight);	
	offlinemodeSwitch = [[UISwitch alloc] initWithFrame:frame];
	[offlinemodeSwitch addTarget:self action:@selector(switchAction:) 
					forControlEvents:UIControlEventValueChanged];

	ItuDimanaAppDelegate *appDelegate = (ItuDimanaAppDelegate *) [[UIApplication sharedApplication] delegate];
	offlinemodeSwitch.on = [appDelegate offlineMode];
}


- (void)createButton {	
	//CGRect frame = CGRectMake(0.0, 0.0, kStdSwitchWidth, kStdSwitchHeight);	
	btnSavedData = [[UIButton buttonWithType:UIButtonTypeDetailDisclosure] retain];
	btnSavedData.frame =  CGRectMake(0.0, 0.0, kStdSwitchWidth, kStdSwitchHeight);	
	[btnSavedData addTarget:self action:@selector(seeSavedData:) forControlEvents:UIControlEventTouchUpInside];	
}


- (void) createButtonUpload {
	//CGRect frame = CGRectMake(0.0, 0.0, kStdSwitchWidth, kStdSwitchHeight);	
	btnUploadData = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[btnUploadData setTitle:@"Upload" forState: UIControlStateNormal];
	btnUploadData.frame =  CGRectMake(0.0, 0.0, kStdSwitchWidth-10, kStdSwitchHeight-10);	
	[btnUploadData addTarget:self action:@selector(uploadData:) forControlEvents:UIControlEventTouchUpInside];	
	
}



#pragma mark -- Action to buttons



- (void)switchAction:(id)sender {
	ItuDimanaAppDelegate *appDelegate = (ItuDimanaAppDelegate *) [[UIApplication sharedApplication] delegate];
	appDelegate.offlineMode = [sender isOn];
}


- (void)uploadData:(id)sender {
	UIWindow *window = 	[[self.ituDimanaAppDelegate window] retain];
	UIActivityIndicatorView  *av = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	av.frame=CGRectMake(125, 150, 65, 65);
	av.tag  = 1;
	[av startAnimating];	
	
	[window addSubview:av];
	[window release];
	
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tempat" inManagedObjectContext:[ituDimanaAppDelegate managedObjectContext]];
	[request setEntity:entity];
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;	
	NSMutableArray *mutableFetchResults = [[[ituDimanaAppDelegate managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		NSLog(@"FUCK");
	}

	NSLog(@"Cont %d",[mutableFetchResults count]);
	Place *place;
	NSInteger idx = 0;
	for (place in mutableFetchResults) {
		idx = idx + 1;
		NSLog(@" The Place : %@",place);
		if (idx = [mutableFetchResults count]) {
			isLastDataUploaded = TRUE;
			NSLog(@" Last DATA %d",idx);
		}
		[self sendRequest:place];
		
		/**
		 * Now delete the entry
		 *
		 */
		[[ituDimanaAppDelegate managedObjectContext] deleteObject:place];		
		// Update the array and table view.
        //[mutableFetchResults removeObjectAtIndex:indexPath.row];
		
		// Commit the change.
		NSError *error;
		if (![[ituDimanaAppDelegate managedObjectContext] save:&error]) {
			// Handle the error.
			[self removeWaitIndicator];
			NSLog(@"PAS DELETE Unresolved error %@, %@", error, [error userInfo]);
			AlertWithTitleAndMessage(@"Unresolved error", [NSString stringWithFormat:@"%@",error]);
			exit(-1);  // Fail			
		}
		
	}
	[mutableFetchResults release];

	//Now Check again for the data
	NSMutableArray *amutableFetchResults = [[[ituDimanaAppDelegate managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
	if ([amutableFetchResults count] > 0) {
		btnUploadData.enabled = TRUE;
	} else {
		btnUploadData.enabled = FALSE;
		[btnUploadData setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
	}	
	[amutableFetchResults release];
	[request release];
	
	//[self removeWaitIndicator];
}


- (void)seeSavedData:(id)sender {
    SavedPlaceViewController *savedDataViewController = [[SavedPlaceViewController alloc] initWithStyle:UITableViewStylePlain];
	savedDataViewController.delegate = self;
	//addViewController.delegate = self;	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:savedDataViewController];	
    [self.navigationController presentModalViewController:navController animated:YES];
	//[self.navigationController pushViewController:navController animated:YES];	
	[savedDataViewController release];
	[navController release];	
}

/**
 Add controller's delegate method; informs the delegate that the add operation has completed, 
 and indicates whether the user saved the new book.
 */
- (void)addViewController:(SavedPlaceViewController *)controller didFinishWithSave:(BOOL)save {
	[self dismissModalViewControllerAnimated:YES];
}


/**
 * Send the request
 *
 */
- (void) sendRequest:(Place *)place {
	
	NSMutableString *parameters = [[[NSMutableString alloc] init] autorelease];	
	[parameters appendFormat:@"gpsloclat=%@",[place gpslat]];
	[parameters appendFormat:@"&gpsloclon=%@",[place gpslon]];
	[parameters appendFormat:@"&name=%@",[place name]];
	[parameters appendFormat:@"&category=%@",[place category]];
	
	NSURL *url = [NSURL URLWithString:SERVER_URL_PUT_PLACE];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url]; 
	NSData *requestData = [parameters dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	/* This set of header IS A MUST */
	[request setHTTPMethod: @"POST"]; 
	[request setValue:[NSString stringWithFormat:@"%d",[requestData length]] forHTTPHeaderField:@"Content-Length"];  
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:requestData]; 

	
	NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];  
    if (conn) {  
        receivedData = [[NSMutableData data] retain];  
    }   
    else {  
        // inform the user that the download could not be made  
		//NSLog(@"Error braee");
		AlertWithTitleAndMessage(@"Send information failed", @"Cannot connect to server");
    }  	
}



- (void) removeWaitIndicator {
	UIWindow *window = 	[[self.ituDimanaAppDelegate window] retain];
	UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[window viewWithTag:1];
	[tmpimg removeFromSuperview];		
	[window release];
	
}


/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
		return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Tempat entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tempat" inManagedObjectContext: [ituDimanaAppDelegate managedObjectContext]];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSSortDescriptor *categoryDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, categoryDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = 
	[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
										managedObjectContext:[ituDimanaAppDelegate managedObjectContext] sectionNameKeyPath:@"name" cacheName:@"Root"];
	//self.fetchedResultsController = aFetchedResultsController;
	//fetchedResultsController.delegate = self;
	
	NSError *error;
	[[ituDimanaAppDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	[categoryDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}    
 */



#pragma mark ---- NSURLConnection delegate implementation ----

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {  
	[receivedData setLength:0];  		
	if ([response isKindOfClass:[NSHTTPURLResponse self]]) {
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
		if ([httpResponse statusCode] == 403) {
			AlertWithTitleAndMessage(@"Error while sending request to server", @"One of field is missing");
		}
	}	
}  

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {  
    [receivedData appendData:data];  
	//done = YES;	
}  


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self removeWaitIndicator];	
	//NSLog(@"Error gilak %@",error);
	AlertWithTitleAndMessage(@"Failed",@"Error can't connect to Host, make sure you are connected to the internet");
	[connection release];
	//done = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection  
{  
    // do something with the data  
    // receivedData is declared as a method instance elsewhere  
	NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);  
	NSString *aStr = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];  
	NSLog(aStr);  
	
    // release the connection, and the data object  
    //[receivedData release];  
	[connection release];
	//done = YES;		
	
	if (isLastDataUploaded) {
		[self removeWaitIndicator];
		isLastDataUploaded = FALSE;
		AlertWithTitleAndMessage(@"Success",@"All data has been uploaded to server");		
	}
	
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


- (void)dealloc {
	[myTableView setDelegate:nil];
	[ituDimanaAppDelegate release];
	[offlinemodeSwitch release];
	[btnSavedData release];
	[btnUploadData release];	
	[myTableView release];	
    [super dealloc];
}


@end
