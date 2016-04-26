//
//  EstateMedia.m
//  EstateLokaler
//
//  Created by apple  on 10/18/11.
//  Copyright 2011 hjbvb. All rights reserved.
//

#import "EstateMedia.h"
#import "EstateLokalerAppDelegate.h"

@implementation EstateMedia

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
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication]delegate];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction)btn1{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.estatelokaler.no"]];
}

-(IBAction)btn2{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.estatenyheter.no"]];
}

-(IBAction)btn3{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.estatekonferanse.no"]];
}

-(IBAction)btn4{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.estatemedia.no"]];
}

-(IBAction)btn5{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.eiendomsdagene.no"]];
}

-(IBAction)clickBack{
	appdel.sokCnt=1;
	[self.navigationController popViewControllerAnimated:YES];	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
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
