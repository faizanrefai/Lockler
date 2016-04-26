//
//  ArticleVC.m
//  EstateLokaler
//
//  Created by apple1 on 10/10/11.
//  Copyright 2011 openxcek. All rights reserved.
//

#import "ArticleVC.h"
#import "GdataParser.h"
#import "PropertiesDetailVC.h"
#import	"EstateLokalerAppDelegate.h"
#import "ArticleVCCell.h"
//#import "ArticleCellDetail.h"
#import "ArticleDetail.h"
@implementation ArticleVC

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
- (void)viewDidLoad {
    [super viewDidLoad];
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication] delegate];
	arrArtList=[[NSMutableArray alloc]init];
	arrArtID=[[NSMutableArray alloc]init];
}
- (void)viewWillAppear:(BOOL)animated{
	[self GDATA];
}

-(void)GDATA{	

	//NSLog(@"%@   %@",appdel.strAppLat,appdel.strAppLong);
	GdataParser *parser1 = [[GdataParser alloc] init];
	[parser1 downloadAndParse:[NSURL  URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=areaarticles&lat=%@&lon=%@",appdel.strAppLat,appdel.strAppLong]]
				  withRootTag:@"post" 
					 withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"catid",@"catid",@"id",@"id",@"title",@"title",@"introText",@"introText",@"categoryname",@"categoryname",nil]
						  sel:@selector(finishGetData:) 
				   andHandler:self];
}

-(void)finishGetData:(NSDictionary*)dictionary{
	//NSLog(@"This is dictionary: %@",dictionary);
	[arrArtList removeAllObjects];
	
	arrArtList =[[dictionary valueForKey:@"array"]retain];
	arrArtID=[[dictionary valueForKey:@"id"]retain];
	cntArt=[arrArtList count];
	//NSLog(@"%d",cntArt);
	dict=[dictionary valueForKey:@"array"];
	if([arrArtList count]==0)
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Områdeinfo"
													 message:@"ingen artikkel" 
													delegate:self 
										   cancelButtonTitle:nil 
										   otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
	}
	[tblArticle reloadData];
	//NSLog(@"dict   %@",dict);
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		//PropertiesDetailVC *obj=[[PropertiesDetailVC alloc]initWithNibName@"PropertiesDetailVC" bundle:nil];
		[self.navigationController popViewControllerAnimated:YES];
		
	}
}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return cntArt;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   	
	
	
	ArticleVCCell *cell = [ArticleVCCell dequeOrCreateInTable:tblArticle];
	if([arrArtList count]!=0)
	{
	dict =[arrArtList objectAtIndex:indexPath.row];
	
	
	[cell setData: dict];
	cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_w.png"]];
    }
	return cell;
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ArticleDetail *detailViewController = [[ArticleDetail alloc] initWithNibName:@"ArticleDetail" bundle:nil];
	dict =[arrArtList objectAtIndex:indexPath.row];
	NSString *strIdArt=[dict valueForKey:@"id"];
	appdel.strArtID=strIdArt; 
	//NSLog(@"%@",appdel.strArtID);
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}
-(IBAction)onBack{
	
	[self.navigationController popViewControllerAnimated:YES];
	
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
	[arrArtList release];
}


@end
