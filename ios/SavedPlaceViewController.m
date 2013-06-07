//
//  SavedPlaceViewController.m
//  ItuDimana
//
//  Created by Pandu  Pradhana on 9/9/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import "SavedPlaceViewController.h"
#import "SettingsViewController.h"
#import "ItuDimanaAppDelegate.h"
#import "ViewPlaceDetailController.h"
#import "Place.h"

// Private interface 
@interface SavedPlaceViewController (Private)
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath place: (Place *)place;
@end

@implementation SavedPlaceViewController

@synthesize ituDimanaAppDelegate,fetchedResultsController;
@synthesize delegate;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.ituDimanaAppDelegate = (ItuDimanaAppDelegate*) [[UIApplication sharedApplication] delegate];
	// Configure the title, title bar, and table view.
	self.title = @"Saved Place";
	//self.navigationItem.rightBarButtonItem = self.editButtonItem;

	//[self.navigationItem setHidesBackButton:FALSE animated:YES];
	//self.tableView.allowsSelectionDuringEditing = YES;
	
	// Configure the save and cancel buttons.
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
													target:self action:@selector(done:)] autorelease];
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"ASUK Unresolved error %@, %@", error, [error userInfo]);
		AlertWithTitleAndMessage(@"Unresolved error", [NSString stringWithFormat:@"%@",error]);		
		exit(-1);  // Fail
	}
	
	if ([fetchedResultsController.fetchedObjects count] > 1 ) {
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
	};

}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data.
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self resignFirstResponder];
}




/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Table view data source methods



/**
 Handle deletion of an event.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {    
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        // Delete the managed object at the given index path.
		//NSManagedObject *placeToDelete = [fetchedResultsController objectAtIndexPath:indexPath];	
		//[[ituDimanaAppDelegate managedObjectContext] deleteObject:placeToDelete];
		
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];		
		
		// Update the array and table view.
        //[eventsArray removeObjectAtIndex:indexPath.row];
		
		// Commit the change.
		NSError *error;
		if (![context save:&error]) {
			// Handle the error.
			NSLog(@"PAS DELETE Unresolved error %@, %@", error, [error userInfo]);
			/*
			NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
			if(detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NSLog(@"  DetailedError: %@", [detailedError userInfo]);
				}
			}
			else {
				NSLog(@"  %@", [error userInfo]);
			}		
			 */
		}
		
		//[tableView reloadData];
    }   
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 1 section
    return [[fetchedResultsController sections] count];;
	//return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//[self.ituDimanaAppDelegate]
    //return [[[self fetchedResultsController] sections] count];
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	//NSLog(@"Jumlah %d",[[fetchedResultsController fetchedObjects] count]);
	//NSLog(@"Jumlah Section %d",[[fetchedResultsController sections] count]);
	return [sectionInfo numberOfObjects];	
	//return [[fetchedResultsController fetchedObjects] count];
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    	
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}				
	
	/*
	 * Since the table row looks like to be bind by the data
	 * We skip the null place name
	 */
	Place *place = [fetchedResultsController objectAtIndexPath:indexPath];
	if (place.name != nil) {
		[self configureCell:cell atIndexPath:indexPath place:place];		
	}	
	
    // Configure the cell.
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath place:(Place *)place {
	//NSString *thelabel = [NSString stringWithFormat:@"%@ %@",place.name,place.category];
	cell.textLabel.text = place.name;
	cell.detailTextLabel.text = place.category;
}

/*
 
 DONT USE THIS IF YOU DONT WANT TO PRINT TITLE IN SECTION
 
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// Display the authors' names as section headings.
    return [[[fetchedResultsController sections] objectAtIndex:section] name];
}
*/


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow selection if editing.
    //return (self.editing) ? indexPath : nil;
	return indexPath;
}



/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	/*
	if (!self.editing) return;
	
    EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
    
    controller.editedObject = book;
    switch (indexPath.row) {
        case 0: {
            controller.editedFieldKey = @"title";
            controller.editedFieldName = NSLocalizedString(@"title", @"display name for title");
            controller.editingDate = NO;
        } break;
        case 1: {
            controller.editedFieldKey = @"author";
			controller.editedFieldName = NSLocalizedString(@"author", @"display name for author");
			controller.editingDate = NO;
        } break;
        case 2: {
            controller.editedFieldKey = @"copyright";
			controller.editedFieldName = NSLocalizedString(@"copyright", @"display name for copyright");
			controller.editingDate = YES;
        } break;
    }
	
    [self.navigationController pushViewController:controller animated:YES];
	[controller release];
	 */
	
	/*
	 * Since the table row looks like to be bind by the data
	 * We skip the null place name
	 */
	Place *place = [fetchedResultsController objectAtIndexPath:indexPath];	
	if (place != nil) {
		/*
		CLLocationCoordinate2D _coordinate; 	
		_coordinate.latitude = [place.gpslat doubleValue];
		_coordinate.longitude = [place.gpslon doubleValue];		
		 */
		ViewPlaceDetailController *viewPlaceDetailController = 
			[[ViewPlaceDetailController alloc] initWithNibName:@"ViewPlaceDetailController" bundle:nil place: place];
		[self.navigationController pushViewController:viewPlaceDetailController animated:YES];
		[place release];
		[viewPlaceDetailController release];
	}
	
}


/*
 DONT UNCOMMENT THIS UNLESS YOU DON'T WANT TO EDIT :p
 
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}
*/




#pragma mark -
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
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
	//NSSortDescriptor *categoryDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES];
	//NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, categoryDescriptor, nil];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = 
						[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
										managedObjectContext:[ituDimanaAppDelegate managedObjectContext] sectionNameKeyPath:@"name" cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	//[categoryDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}    


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	//Ntar dulu
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath 
	 forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	/* Ntar dulu juga, Soale read-only braee :) */
	 
	 UITableView *tableView = self.tableView;
	 
	 switch(type) {
	 
		 case NSFetchedResultsChangeInsert:
			 [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			 break;
	 
		 case NSFetchedResultsChangeDelete:
			 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			 break;
	 
		 case NSFetchedResultsChangeUpdate: {
				/*
				 * Since the table row looks like to be bind by the data
				 * We skip the null place name
				 */
				Place *place = [fetchedResultsController objectAtIndexPath:indexPath];
				if (place.name != nil) {			 
					[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath place:place];
				}
			}
			 break;
	 
		 case NSFetchedResultsChangeMove:
			 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			 // Reloading the section inserts a new row and ensures that titles are updated appropriately.
			 [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
			 break;
	 }
	 
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo 
		   atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	/* Ntar dulu juga, Soale read-only braee :) */
	 switch(type) {
	 
	 case NSFetchedResultsChangeInsert:
			 [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
	 break;
	 
	 case NSFetchedResultsChangeDelete:
			 [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
	 break;
	 }
	 
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	
	//Ntar dulu juga, Soale read-only braee :) 
	[self.tableView endUpdates];
}



- (IBAction)done:(id)sender {
	[delegate addViewController:self didFinishWithSave:YES];
}



#pragma mark --- Memory Management


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}



- (void)dealloc {
	[fetchedResultsController setDelegate:nil];
	[fetchedResultsController release];
	[ituDimanaAppDelegate release];
    [super dealloc];
}


@end
