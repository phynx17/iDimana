//
//  ChooseCategoryViewController.h
//  ItuDimana
//
//  Created by Pandu  Pradhana on 8/30/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FirstViewController.h";


@interface ChooseCategoryViewController : UIViewController {
	IBOutlet UIPickerView *categoryPicker;
	NSArray *categoryItems;	
	FirstViewController *thisViewParent;
}

@property (nonatomic, retain) UIPickerView *categoryPicker;
@property (nonatomic, retain) FirstViewController *thisViewParent;

- (IBAction)dismiss:(id)sender;

@end
