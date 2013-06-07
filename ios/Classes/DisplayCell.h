//
//  DisplayCell.h
//  ItuDimana
//
//  A very convinient class for drawing cell
//
//  Created by Apple Corp 
//  Copyright 2009 Melati Group. All rights reserved.
//
#import <UIKit/UIKit.h>

// cell identifier for this custom cell
extern NSString *kDisplayCell_ID;

@interface DisplayCell : UITableViewCell {
	UILabel	*nameLabel;
	UIView	*view;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UIView *view;


- (void)setView:(UIView *)inView;

@end
