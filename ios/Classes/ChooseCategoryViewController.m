//
//  ChooseCategoryViewController.m
//  ItuDimana
//
//  Created by Pandu  Pradhana on 8/30/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import "ChooseCategoryViewController.h"
#import "CategoryItem.h"

@implementation ChooseCategoryViewController

@synthesize categoryPicker,thisViewParent;



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		categoryItems = [[NSArray alloc] initWithObjects:
						 [[[CategoryItem alloc] initWithName:@"Administration" value:@"administration government"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"Airport" value:@"transportation"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"ATM" value:@"atm"] autorelease],
						 [[[CategoryItem alloc] initWithName:@"Apartment" value:@"apartment"] autorelease],
						 [[[CategoryItem alloc] initWithName:@"Billiard" value:@"sport"] autorelease],						 
						 [[[CategoryItem alloc] initWithName:@"Broadcast Station" value:@"broadcast Station"] autorelease],		
						 [[[CategoryItem alloc] initWithName:@"Bus Station" value:@"transportation"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"Cafe" value:@"fnb cafe"] autorelease],						 
						 [[[CategoryItem alloc] initWithName:@"Church" value:@"worship"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"College" value:@"education college"] autorelease],
						 [[[CategoryItem alloc] initWithName:@"Clinic" value:@"medical clinic"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"Dealer" value:@"automotive dealer"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"Drug Store" value:@"medical drug store"] autorelease],					 					 
						 [[[CategoryItem alloc] initWithName:@"Embassy" value:@"embassy government"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"Etc" value:@"etc"] autorelease], 					 
						 [[[CategoryItem alloc] initWithName:@"Fast Food" value:@"fnb fast food"] autorelease],	
						 [[[CategoryItem alloc] initWithName:@"Gallery" value:@"shop poi"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"Garage" value:@"automotive garage"] autorelease],
						 [[[CategoryItem alloc] initWithName:@"Gas Station" value:@"automotive gas station"] autorelease],
						 [[[CategoryItem alloc] initWithName:@"Golf Course" value:@"sport"] autorelease],
						 [[[CategoryItem alloc] initWithName:@"Gym" value:@"sport"] autorelease],					
						 [[[CategoryItem alloc] initWithName:@"Harbour" value:@"transportation"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"Hotel" value:@"hotel"] autorelease],	
						 [[[CategoryItem alloc] initWithName:@"Hospital" value:@"medical hospital"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"Mall" value:@"shop retail"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"Military" value:@"government military"] autorelease],
						 [[[CategoryItem alloc] initWithName:@"Movie Theater" value:@"movie theater"] autorelease],
						 [[[CategoryItem alloc] initWithName:@"Mosque" value:@"worship"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"Museum" value:@"museum"] autorelease],
						 [[[CategoryItem alloc] initWithName:@"Office Building" value:@"office"] autorelease],	
						 [[[CategoryItem alloc] initWithName:@"Places Of Interest" value:@"poi place of interest"] autorelease],	
						 [[[CategoryItem alloc] initWithName:@"Police Station" value:@"police administration"] autorelease],
						 [[[CategoryItem alloc] initWithName:@"Property" value:@"property"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"Restaurant" value:@"fnb restaurant"] autorelease],	
						 [[[CategoryItem alloc] initWithName:@"Retailer" value:@"retail"] autorelease],	
						 [[[CategoryItem alloc] initWithName:@"Supermarket" value:@"retail market"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"Stadium" value:@"sport"] autorelease],
						 [[[CategoryItem alloc] initWithName:@"Swimming Pool" value:@"sport"] autorelease],			
						 [[[CategoryItem alloc] initWithName:@"Temple" value:@"worship"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"Traditional Market" value:@"retail market"] autorelease],
						 [[[CategoryItem alloc] initWithName:@"Train Station" value:@"transportation"] autorelease],					 
						 [[[CategoryItem alloc] initWithName:@"School" value:@"education school"] autorelease],							 
						 [[[CategoryItem alloc] initWithName:@"University" value:@"education university"] autorelease],	
						 nil
						 ];
		
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *dismissBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
																	style:UIBarButtonItemStyleDone //ato UIBarButtonItemStylePlain
																	target:self 
																	action:@selector(dismiss:)];
	
	self.navigationItem.rightBarButtonItem = dismissBarItem;	
	[dismissBarItem release];
	
	/**
	 * Atur Category disini
	 *
	 *
	 */
	self.navigationItem.title = @"Choose Category";
}


#pragma mark ---- UIPickerViewDataSource delegate methods ----

// returns the number of columns to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

// returns the number of rows
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [categoryItems count];
}

#pragma mark ---- UIPickerViewDelegate delegate methods ----

// returns the title of each row
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	CategoryItem *currentItem = [categoryItems objectAtIndex:row];
	return currentItem.displayName;
}

// gets called when the user settles on a row
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	//nothing
}



- (IBAction)dismiss:(id)sender {		
	CategoryItem *currentItem = [categoryItems objectAtIndex:[categoryPicker selectedRowInComponent:0]];
	[thisViewParent setCategory:[currentItem itemValue]];
	NSString *btnTxt = [NSString stringWithFormat:@"Category: %@",currentItem.displayName];
	[[thisViewParent btnCategory] setTitle:btnTxt forState: UIControlStateNormal];	
	[self dismissModalViewControllerAnimated:TRUE];		
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[categoryItems release];
	[categoryPicker release];
	[thisViewParent release];
    [super dealloc];
}


@end
