//
//  ArticleDetail.m
//  EstateLokaler
//
//  Created by apple1 on 10/10/11.
//  Copyright 2011 openxcek. All rights reserved.
//

#import "ArticleDetail.h"
#import "EstateLokalerAppDelegate.h"
#import "EGOImageView.h"
#import "GdataParser.h"
@implementation ArticleDetail

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication] delegate];
	arrArtList=[[NSMutableArray alloc]init];
	}
- (void)viewWillAppear:(BOOL)animated{
	[self GDATA];
}
-(void)setLoadImageg:(NSString*)loadimage:(EGOImageView*)img{
	
	img.imageURL = [NSURL URLWithString:loadimage];
	//NSLog(@"%@",[NSURL URLWithString:loadimage]);
}

-(IBAction)onBack{
	
	[self.navigationController popViewControllerAnimated:YES];


}
-(void)GDATA{	
	//NSLog(@"%@",appdel.strArtID);
	
	
	GdataParser *parser1 = [[GdataParser alloc] init];
	[parser1 downloadAndParse:[NSURL  URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=articledetails&artid=%@",appdel.strArtID]]
				  withRootTag:@"post" 
					 withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"title",@"title",@"introText",@"introText",@"mainimage",@"mainimage",@"authorname",@"authorname",@"authoremail",@"authoremail",@"created",@"created",@"descriptionurl",@"descriptionurl",nil]
						  sel:@selector(finishGetData:) 
				   andHandler:self];
	
} 

-(void)finishGetData:(NSDictionary*)dictionary{
	//NSLog(@"This is dictionary: %@",dictionary);
	[arrArtList removeAllObjects];
	
	arrArtList =[[dictionary valueForKey:@"array"]retain];
	
	//NSLog(@"%@",arrArtList);
	NSMutableArray *t =[dictionary valueForKey:@"array"];
	dict = [t objectAtIndex:0];
	
	strTitle=[dict valueForKey:@"title"];
	//NSLog(@"%@",strTitle);
	lblTitle.text=[NSString stringWithFormat:@"%@",strTitle];
	strName=[dict valueForKey:@"authorname"];
	lblName.text=[NSString stringWithFormat:@"%@",strName];
	strIntro=[dict valueForKey:@"introText"];
	lblIntro.text=[NSString stringWithFormat:@"%@",strIntro];
	strEmail=[dict valueForKey:@"authoremail"];
	lblEmail.text=[NSString stringWithFormat:@"%@",strEmail];
	strDate=[dict valueForKey:@"created"];
	lblDate.text=[NSString stringWithFormat:@"Created:%@-%@",strDate,strName];
	imgView.hidden =YES;
	
	NSString *urlAddress =[dict valueForKey:@"descriptionurl"];
	//NSLog(@"aaaa:::%@",urlAddress);
	webView.backgroundColor=[UIColor clearColor];
	
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	[webView setOpaque:NO]; 
	webView.backgroundColor=[UIColor grayColor]; 
	webView.alpha =0.5;
	
	//NSLog(@"%@",[_dict valueForKey:@"descriptionurl"]);
	//		cell0.lblUrl.text=[_dict valueForKey:@"descriptionurl"];
		
	
	
	
	
	NSString *urlStr =[NSString stringWithFormat:@"%@", [dict valueForKey:@"mainimage"]];
	EGOImageView *imageViewL = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""]];
	[self setLoadImageg:urlStr:imageViewL];

	imageViewL.frame = CGRectMake(0.0f, 94.0f, 320.0f, 138.0f);
	[self.view addSubview:imageViewL];
	//imgView.hidden = TRUE;
	//[contentView addSubview:imageViewL];
	
	//myImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];

	
	
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
	[arrArtList release];
	[lblEmail release];
	[lblDate release];
	[lblIntro release];
	[lblName release];
	[lblTitle release];
}


@end
