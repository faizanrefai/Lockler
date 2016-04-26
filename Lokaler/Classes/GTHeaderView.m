//
//  WTHeaderView.m
//  WarfareTouch
//
//  Created by Brad Goss on 10-02-02.
//  Copyright 2010 GossTech Inc. All rights reserved.
//

#import "GTHeaderView.h"


@implementation GTHeaderView

@synthesize mainView, button, label,Rowstatus;

+ (id)headerViewWithTitle:(NSString*)title section:(NSInteger)Section Expanded:(NSString *)rowstatus{
	GTHeaderView *headerView = [[GTHeaderView alloc] init];
	[headerView.label setText:title];
	[headerView.button setTag:Section];
	headerView.Rowstatus=rowstatus;
	
	return [headerView autorelease];
}
- (id) init {
	self = [super initWithFrame:CGRectMake(0.0, 0.0, 320.0, 35.0)];
	if (self != nil) {
		[[NSBundle mainBundle] loadNibNamed:@"WTHeaderView" owner:self options:nil];
		
		[self addSubview:mainView];
	}
	return self;
}

@end
