//
//  DisplayCell.m
//  ItuDimana
//
//  Created by Pandu  Pradhana on 8/30/09.
//  Copyright 2009 Melati Group. All rights reserved.
//

#import "DisplayCell.h"
#import "Constants.h"

// cell identifier for this custom cell
NSString *kDisplayCell_ID = @"DisplayCell_ID";

@implementation DisplayCell

@synthesize nameLabel;
@synthesize view;


- (id)initWithFrame:(CGRect)aRect 
		reuseIdentifier:(NSString *)identifier {
	
	if (self = [super initWithFrame:aRect reuseIdentifier:identifier]) {
		// turn off selection use
		//Biar pas di touch gak ke *highlight*
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		//self.selectionStyle = UITableViewCellStyleSubtitle;
		
		nameLabel = [[UILabel alloc] initWithFrame:aRect];
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.opaque = NO;
		nameLabel.textColor = [UIColor blackColor];
		//nameLabel.highlightedTextColor = [UIColor blackColor];
		//nameLabel.font = [UIFont boldSystemFontOfSize:18];
		nameLabel.font = [UIFont systemFontOfSize:18];
		[self.contentView addSubview:nameLabel];
	}
	return self;
}

- (void)setView:(UIView *)inView {
	if (view) {
		[view removeFromSuperview];
	}
	view = inView;
	[self.view retain];
	[self.contentView addSubview:inView];	
	[self layoutSubviews];
}


- (void)layoutSubviews {	
	[super layoutSubviews];
    CGRect contentRect = [self.contentView bounds];
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
	// For the LABEL
	CGRect frame = 
		CGRectMake(contentRect.origin.x + kCellLeftOffset, kCellTopOffset, contentRect.size.width, kCellHeight);
	nameLabel.frame = frame;
	
	if ([view isKindOfClass:[UIPageControl class]]) {
		// special case UIPageControl since its width changes after its creation
		CGRect frame = self.view.frame;
		frame.size.width = kPageControlWidth;
		self.view.frame = frame;
	}
	
	//Set frame here
	CGRect uiFrame = CGRectMake(contentRect.size.width - self.view.bounds.size.width - kCellLeftOffset,
								round((contentRect.size.height - self.view.bounds.size.height) / 2.0),
								self.view.bounds.size.width,
								self.view.bounds.size.height);
	view.frame = uiFrame;
}

- (void)dealloc {
	[nameLabel release];
	[view release];	
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];	
	// when the selected state changes, set the highlighted state of the lables accordingly
	nameLabel.highlighted = selected;
}

@end
