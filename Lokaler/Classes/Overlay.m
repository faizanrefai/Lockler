//
//  Overlay.m
//  EstateLokaler
//
//  Created by apple  on 10/10/11.
//  Copyright 2011 hjbvb. All rights reserved.
//

#import "Overlay.h"
#import "RootViewController.h"

@implementation Overlay
@synthesize rvController;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	
	[rvController doneSearching_Clicked:nil];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[rvController release];
	
}


@end
