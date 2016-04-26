//
//  PropertyMapMode.m
//  EstateLokaler
//
//  Created by apple on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PropertyMapMode.h"
#import "PropertyListMode.h"
#import "SokeFilterVC.h"
#import "DisplayMap.h"
#import "PropertiesDetailVC.h"
#import "GdataParser.h"
#import "EstateLokalerAppDelegate.h"
#import "RootViewController.h"
#import "AlertHandler.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

#define BASE_RADIUS .5 // = 1 mile
#define MINIMUM_LATITUDE_DELTA 0.20
#define BLOCKS 4

#define MINIMUM_ZOOM_LEVEL 100000


@implementation PropertyMapMode
@synthesize strSearch;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication]delegate];
	MapView.delegate = self;
	arrLat=[[NSMutableArray alloc]init];
	arrLong=[[NSMutableArray alloc]init];
	arrTitle=[[NSMutableArray alloc]init];
	arrPOM=[[NSMutableArray alloc]init];
	
	_mapView = [[REVClusterMapView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
    _mapView.delegate = self;
	
    [MapView addSubview:_mapView];
	
	
	//[self GDATAPropertyOfMon];
	
}

- (void)viewWillAppear:(BOOL)animated{
//	if ([appdel.appdelStrSearch isEqualToString:@""]) 
		//[self GDATA];
	
//	else 
//		[self GDATASearch];
		
}

-(void)GDATA{	
	
	GdataParser *parser = [[GdataParser alloc] init];
	[parser downloadAndParse:[NSURL
	 						  URLWithString:@"http://www.estatelokaler.no/appservice.php?token=propertylist"]
				 withRootTag:@"post" 
					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"title",@"title",@"adress",@"adress",@"houseno",@"houseno",@"latitude",@"latitude",@"longitude",@"longitude",@"shortDescription",@"shortDescription",@"mainimage",@"mainimage",@"areaname",@"areaname",@"townname",@"townname",@"fromarea",@"fromarea",@"toarea",@"toarea",@"departmentname",@"departmentname",nil]
						 sel:@selector(finishGetData:) 
				  andHandler:self];
	
}

-(void)finishGetData:(NSDictionary*)dictionary{
	//NSLog(@"This is dictionary: %@",dictionary);
	
	[appdel.arrList removeAllObjects];
	[arrLat removeAllObjects];
	appdel.arrList =[[dictionary valueForKey:@"array"] retain];
	cnt=[appdel.arrList	count];
	for(int i=0;i<[appdel.arrList count];i++)
  {
	t_dic =[appdel.arrList objectAtIndex:i];
	[arrLat addObject:[t_dic valueForKey:@"latitude"]];
	[arrLong addObject:[t_dic valueForKey:@"longitude"]];
	[arrTitle addObject:[t_dic valueForKey:@"title"]];	
	
  }
	    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[[appdel.arrList objectAtIndex:0] valueForKey:@"latitude"] floatValue];
    coordinate.longitude = [[[appdel.arrList objectAtIndex:0] valueForKey:@"longitude"] floatValue];
    _mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000);
    
    NSMutableArray *pins = [NSMutableArray array];
    
    for(int i=0;i<[appdel.arrList	count];i++) {
		
		CGFloat lat = [[[appdel.arrList objectAtIndex:i] valueForKey:@"latitude"] floatValue];
		CGFloat lng = [[[appdel.arrList objectAtIndex:i] valueForKey:@"longitude"] floatValue];
		
        CLLocationCoordinate2D newCoord = {lat,lng};
        REVClusterPin *pin = [[REVClusterPin alloc] init];
		pin.title = [NSString stringWithFormat:@"%@",[[appdel.arrList objectAtIndex:i] valueForKey:@"title"]];
        //pin.title = [NSString stringWithFormat:@"Pin %i title:%@",i+1,[[appdel.arrList objectAtIndex:i] valueForKey:@"title"]];
		// pin.subtitle = [NSString stringWithFormat:@"Pin %i subtitle : %@",i+1,[[appdel.arrList objectAtIndex:i] valueForKey:@"adress"]];
        pin.coordinate = newCoord;
        [pins addObject:pin];
        [pin release]; 
    }
    
    [_mapView addAnnotations:pins];	
}

-(void)GDATASearch{	
	//NSLog(@"aa:%@",appdel.appdelStrSearch);
	GdataParser *parser1 = [[GdataParser alloc] init];
	[parser1 downloadAndParse:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=propertylist&txt_sted=%@",appdel.appdelStrSearch]]
				 withRootTag:@"post" 
					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"title",@"title",@"adress",@"adress",@"houseno",@"houseno",@"latitude",
							  @"latitude",@"longitude",@"longitude",@"shortDescription",@"shortDescription",@"mainimage",@"mainimage",@"areaname",@"areaname",@"townname",@"townname"
							  ,@"fromarea",@"fromarea",@"toarea",@"toarea",@"departmentname",@"departmentname",nil]
						 sel:@selector(finishGetDataSokSearch:) 
				  andHandler:self];
}

-(void)finishGetDataSokSearch:(NSDictionary*)dictionary{
	//NSLog(@"This is dictionary: %@",dictionary);
	
	[searchArray removeAllObjects];
	[arrLat1 removeAllObjects];
	searchArray =[[dictionary valueForKey:@"array"] retain];
	cnt1=[searchArray count];
	for(int i=0;i<[searchArray count];i++)
	{
		_dict =[appdel.arrList objectAtIndex:i];
		[arrLat1 addObject:[_dict valueForKey:@"latitude"]];

		[arrLong1 addObject:[_dict valueForKey:@"longitude"]];
		[arrTitle1 addObject:[_dict valueForKey:@"title"]];	
		
			
	}
	
	//[tblView reloadData];
	
	
	//[self setMapViewPoint];
}
-(void)GDATAPropertyOfMon{	
	//NSLog(@"aa:%@",appdel.appdelStrSearch);
	GdataParser *parser2 = [[GdataParser alloc] init];
	[parser2 downloadAndParse:[NSURL URLWithString:@"http://www.estatelokaler.no/appservice.php?token=propmonth"]
				  withRootTag:@"post" 
					 withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"title",@"title",@"adress",@"adress",@"houseno",@"houseno",
							  @"shortDescription",@"shortDescription",@"thumbimage",@"thumbimage",@"area",@"area",@"town",@"town"
							   ,@"from_area",@"from_area",@"to_area",@"to_area",@"departmentname",@"departmentname",@"companyname",@"companyname",nil]
						  sel:@selector(finishGetDataPropertyOfMon:) 
				   andHandler:self];
}

-(void)finishGetDataPropertyOfMon:(NSDictionary*)dictionary
{
	//NSLog(@"This is dictionary: %@",dictionary);
	[arrPOM removeAllObjects];
	arrPOM =[[dictionary valueForKey:@"array"] retain];
	cnt1=[arrPOM count];
	for(int i=0;i<[arrPOM count];i++)
	{
		dictPOM=[arrPOM objectAtIndex:i];
	}
	lblAddress.text=[dictPOM valueForKey:@"adress"];
	NSString *temp;
	temp=[NSString stringWithFormat:@"%@ Kvm %@  %@", [dictPOM valueForKey:@"from_area"],[dictPOM valueForKey:@"area"],[dictPOM valueForKey:@"town"]];
	lblHouseNo.text=temp;
	lblCompName.text=[dictPOM valueForKey:@"companyname"];
}

#pragma mark -
#pragma mark UIMkMapView delegate methods
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation {
	//MKPinAnnotationView *annView = nil; 
	
	if([annotation class] == MKUserLocation.class) {
		//userLocation = annotation;
		return nil;
	}
    
    REVClusterPin *pin = (REVClusterPin *)annotation;
    
    MKAnnotationView *annView;
    
    if( [pin nodeCount] > 0 ){
        annView = (REVClusterAnnotationView*)[mV dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        
        if( !annView )
            annView = (REVClusterAnnotationView*)[[[REVClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"] autorelease];
        
        annView.image = [UIImage imageNamed:@"cluster.png"];
        [(REVClusterAnnotationView*)annView setClusterText:[NSString stringWithFormat:@"%i",[pin nodeCount]]];
        annView.canShowCallout = YES;
    } else {
        annView = [mV dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        
        if( !annView )
            annView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"] autorelease];
        
        annView.image = [UIImage imageNamed:@"MapPin.png"];
        annView.canShowCallout = YES; 
		[annView setEnabled:YES];
		
		//UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeCustom];
		//		[disclosureButton setFrame:CGRectMake(0, 0, 50, 30)];
		//		[disclosureButton setImage:[UIImage imageNamed:@"HomeCell.jpg"] forState:UIControlStateNormal];
		//		annView.leftCalloutAccessoryView = disclosureButton;
		
		NSString *pintitle=[NSString stringWithFormat:@"%@",((MKPinAnnotationView*) annView).annotation.title];
		for (int i = 0; i<[appdel.arrList count]; i++)
		{
			d = (NSMutableDictionary*)[appdel.arrList objectAtIndex:i];
			strAddress = [NSString stringWithFormat:@"%@",[d valueForKey:@"title"]];
			//strSecImg=[NSString stringWithFormat:@"%@",[d valueForKey:@"title"]];
			if([strAddress isEqualToString:pintitle]) 
			{
				//annot = object;
				d = [appdel.arrList objectAtIndex:i];
				UIImageView *imageview =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
				imgURL= [[NSURL	alloc] initWithString:[d objectForKey:@"mainimage"]]; 
				imageview.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgURL]];
				annView.leftCalloutAccessoryView =imageview;
				
				appdel.appdelStrID = [d objectForKey:@"id"];
				
				[imageview release];
				break;
			}
		}
		
		UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[infoButton setFrame:CGRectMake(annView.bounds.size.width-35,10,25, 27)];
		[infoButton setImage:[UIImage imageNamed:@"DDOrange.png"] forState:UIControlStateNormal];
		annView.rightCalloutAccessoryView = infoButton;
		[infoButton addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
    }
    return annView;
	
}
#pragma mark -
#pragma mark Custom methods
-(void)clickBack
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)clickListe
{	
	NSString *strTagMapOrList = [[NSUserDefaults standardUserDefaults] stringForKey:@"MapOrListTag"];
	if ([strTagMapOrList isEqualToString:@"1"]) {
		[self.navigationController popViewControllerAnimated:NO];
	}
	else if ([strTagMapOrList isEqualToString:@"2"])
	{
		PropertyListMode *detailViewController = [[PropertyListMode alloc] initWithNibName:@"PropertyListMode" bundle:nil];
		[self.navigationController pushViewController:detailViewController animated:NO];
		//[detailViewController release];
	}
}
-(void)clickSokeFilter
{
	SokeFilterVC *detailViewController = [[SokeFilterVC alloc] initWithNibName:@"SokeFilterVC" bundle:nil];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}
-(IBAction)clickClose
{
	[viewMonthProperties setFrame:CGRectMake(0, 470, 320, 100)];
}
//-(void)setMapViewPoint
//{
//	for(int j=0;j<cnt;j++)
//	{
//	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
//	NSString *tempLat,*tempLong;
//	tempLat=[arrLat objectAtIndex:j];
//	tempLong=[arrLong objectAtIndex:j];
//	
//	region.center.latitude=[tempLat floatValue];
//	region.center.longitude =[tempLong floatValue];
//		
//	region.span.longitudeDelta = 0.01f;
//	region.span.latitudeDelta = 0.01f;
//	
//	[MapView setRegion:region animated:YES]; 
//	
//	[MapView setDelegate:self];
//	DisplayMap *ann = [[DisplayMap alloc] init]; 
//	ann.title =[arrTitle objectAtIndex:j];
//	ann.coordinate = region.center; 
//	[MapView addAnnotation:ann];
//		
//	}
//} 

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [MapView removeAnnotations:MapView.annotations];
    MapView.frame = self.view.bounds;
}

-(void)ButtonPressed:(id)sender{
	PropertiesDetailVC *detailViewController = [[PropertiesDetailVC alloc] initWithNibName:@"PropertiesDetailVC" bundle:nil];
	NSLog(@"Map id%@",appdel.appdelStrID);
	[self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];	

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
	
	[MapView release];
    [viewMonthProperties release];
	[t_dic release];
	[_dict release];
	[arrLat release];
	[arrLong release];
	[arrTitle release];
    [arrLat1 release];
	[arrLong1 release];
	[arrTitle1 release];
	[strSearch release];
	[searchArray release];
	[arrPOM release];
	[lblAddress release];
	[lblHouseNo release];
	[lblCompName release];
	[appdel release];
	
	[lblkms release];
	
	[lblArea release];
	[lbltown release];
	[lblDept release];
		
}	
	
@end
