//
//  ContactUs.m
//  EstateLokaler
//
//  Created by apple  on 10/17/11.
//  Copyright 2011 hjbvb. All rights reserved.
//

#import "ContactUs.h"
#import "EstateLokalerAppDelegate.h"
//#import "SHKItem.h"
//#import "SHKMail.h"

@implementation ContactUs

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication] delegate];
}
-(IBAction)map{
	
//	NSString* urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=59.9186193, 10.7335249 ,59.90965726713029,10.72318448771361"];

	

	NSString* urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=%f,%f",59.9186193, 10.7335249,appdel.lat,appdel.lon];
	

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	
}

-(IBAction)sendPost{
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setToRecipients:[NSArray arrayWithObject:@"info@estatemedia.no"]];
	[controller setSubject:@"My Subject"];
	[controller setMessageBody:@"" isHTML:NO]; 
	if (controller) [self presentModalViewController:controller animated:YES];
	[controller release];
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
	if (result == MFMailComposeResultSent) {
		NSLog(@"It's away!");
	}
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)callUs{
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://21951000"]];
}

-(IBAction)back{
	appdel.sokCnt=1;
	[self.navigationController popViewControllerAnimated:YES];	
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
}


@end
