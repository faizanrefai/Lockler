//
//  PropertyListMode.m
//  EstateLokaler
//
//  Created by apple on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PropertyListMode.h"
#import "PropertyListModeCell.h"
#import "UITableViewCell+NIB.h"
#import "SokeFilterVC.h"
#import "PropertyMapMode.h"
#import "GdataParser.h"
#import "EstateLokalerAppDelegate.h"
#import "PropertyListModeCell.h"
#import "PropertiesDetailVC.h"
#import "EGOImageView.h"
#import "AlertHandler.h"
#import "SokeFilterVC.h"
#import "Math.h"


@implementation PropertyListMode

@synthesize isSearchArea;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
	promonthView.hidden=YES;
	lblTitleSoq.hidden=YES;
	listView.hidden=YES;	
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication]delegate];	
	MapView.hidden =NO;		
}
  
- (void)viewWillAppear:(BOOL)animated{	
	if(isPushed){
		isPushed =FALSE;
		return;
	}
		
	Loadmorecnt=1;
	NSLog(@"flag:: %d",appdel.flagsokSearch);
	[self PickerStatus_hidden:YES];
	if(appdel.isNew_add){
		isSearchArea =TRUE;
		[self GDATATwelve];
	}
	else {
		[self GDATAPropertyOfMon];
		[self getMapannotation:appdel.myCurrentData_arr];
		[tblView reloadData];
	}
}

-(void)GDATATwelve{	
	//NSString *parserTwelve=[NSString stringWithFormat:@"http://www.estatelokaler.no/response.php?token=closureprop&lat=59.90965726713029&lon=10.72318448771361"];
    [AlertHandler showAlertForProcess];

	GdataParser *parserTwelve = [[GdataParser alloc] init];
	[parserTwelve downloadAndParse:[NSURL
							  URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=getnewpropertieslist&udid=%@",appdel.udID]]
				 withRootTag:@"post" 
					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"title",@"title",@"adress",@"adress",@"houseno",@"houseno",@"latitude",@"latitude",@"longitude",@"longitude",@"shortDescription",@"shortDescription",@"mainimage",@"mainimage",@"areaname",@"areaname",@"townname",@"townname",@"fromarea",@"fromarea",@"toarea",@"toarea",@"departmentname",@"departmentname",@"date_insert",@"date_insert",nil]
						 sel:@selector(finishGetDataTwelve:) 
				  andHandler:self];
} 

-(void)finishGetDataTwelve:(NSDictionary*)dictionary{
    
    [AlertHandler hideAlert];
	[appdel.myCurrentData_arr removeAllObjects];
	NSMutableArray *temp =[[dictionary valueForKey:@"array"]retain];
	appdel.myCurrentData_arr=[temp mutableCopy];
	[tblView reloadData];
	[self getMapannotation:appdel.myCurrentData_arr];
}


-(void)GDATASortListDisplay{
	appdel.Currentsorted =selrow+1;
	[self PickerStatus_hidden:YES];
	[AlertHandler showAlertForProcess];

	NSString *urlString =@"";
	if ( [appdel.urlPropertylist length] > 0)
		urlString = [appdel.urlPropertylist substringToIndex:[appdel.urlPropertylist length] - 1];

	if([[NSString stringWithFormat:@"%d",selrow] isEqualToString:@"4"]){		
		GdataParser *parser2 = [[GdataParser alloc] init];
		[parser2 downloadAndParse:[NSURL URLWithString:[NSString stringWithFormat:@"%@5&&lat=%f&lon=%f",urlString,appdel.lat,appdel.lon]]
					  withRootTag:@"post" 
						 withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"title",@"title",@"adress",@"adress",@"houseno",@"houseno",@"latitude",@"latitude",@"longitude",@"longitude",@"shortDescription",@"shortDescription",@"mainimage",@"mainimage",@"areaname",@"areaname",@"townname",@"townname",@"fromarea",@"fromarea",@"toarea",@"toarea",@"departmentname",@"departmentname",@"distance",@"distance",@"zip_code",@"zip_code",nil]
							  sel:@selector(finishGetDataSortListDisplay:) 
					   andHandler:self];
		
		
	}
	else{
	GdataParser *parser2 = [[GdataParser alloc] init];
	[parser2 downloadAndParse:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d",urlString,selrow+1]]
				  withRootTag:@"post" 
					 withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"title",@"title",@"adress",@"adress",@"houseno",@"houseno",@"latitude",@"latitude",@"longitude",@"longitude",@"shortDescription",@"shortDescription",@"mainimage",@"mainimage",@"areaname",@"areaname",@"townname",@"townname",@"fromarea",@"fromarea",@"toarea",@"toarea",@"departmentname",@"departmentname",@"zip_code",@"zip_code",nil]
						  sel:@selector(finishGetDataSortListDisplay:) 
				   andHandler:self];
	}
}

-(void)finishGetDataSortListDisplay:(NSDictionary*)dictionary{    
    [AlertHandler hideAlert];
	NSMutableArray *t_arr =[dictionary valueForKey:@"array"];
	[appdel.myCurrentData_arr removeAllObjects];
	appdel.myCurrentData_arr  = [t_arr mutableCopy];	
	[tblView reloadData];
	NSIndexPath *myIP = [NSIndexPath indexPathForRow:0 inSection:0];	
	[tblView scrollToRowAtIndexPath:myIP atScrollPosition:UITableViewScrollPositionTop animated:NO];
} 

-(void)GDATASortList{	
	if([arrayTypeLokale count]==0){	
    [AlertHandler showAlertForProcess];
	GdataParser *parser1 = [[GdataParser alloc] init];
	[parser1 downloadAndParse:[NSURL
							   URLWithString:@"http://www.estatelokaler.no/appservice.php?token=sortby"]
				  withRootTag:@"post" 
					 withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"sortby",@"sortby",nil]
						  sel:@selector(finishGetDataSortList:) 
				   andHandler:self];
	}
	else {
		[self PickerStatus_hidden:NO];
		//selrow=1;
		[typeLokalePicker reloadAllComponents];	
	}

}

-(void)finishGetDataSortList:(NSDictionary*)dictionary{
    [AlertHandler hideAlert];	
  	[arrayTypeLokale removeAllObjects];
	arrayTypeLokale =[[[dictionary valueForKey:@"array"] retain]mutableCopy];
	[self PickerStatus_hidden:NO];
	selrow=1;
	[typeLokalePicker reloadAllComponents];	
}

-(void)GDATAPropertyOfMon{	
    [AlertHandler showAlertForProcess];    
	GdataParser *parser2 = [[GdataParser alloc] init];
	[parser2 downloadAndParse:[NSURL URLWithString:@"http://www.estatelokaler.no/appservice.php?token=propmonth"]
				  withRootTag:@"post" 
					 withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"title",@"title",@"adress",@"adress",@"houseno",@"houseno",
							   @"shortDescription",@"shortDescription",@"thumbimage",@"thumbimage",@"area",@"area",@"town",@"town"
							   ,@"from_area",@"from_area",@"to_area",@"to_area",@"departmentname",@"departmentname",@"companyname",@"companyname",@"latitude",@"latitude",@"longitude",@"longitude",@"zip_code",@"zip_code",nil]
						  sel:@selector(finishGetDataPropertyOfMon:) 
				   andHandler:self];
}

-(void)finishGetDataPropertyOfMon:(NSDictionary*)dictionary {
    [AlertHandler hideAlert];
	mnthPropertyDic =[[[dictionary valueForKey:@"array"]objectAtIndex:0] retain];	
	lblAddHouseNo.text=[NSString stringWithFormat:@"%@, %@",[mnthPropertyDic valueForKey:@"adress"],[mnthPropertyDic valueForKey:@"title"]];
	
	lblDepartment.text=[NSString stringWithFormat:@"%@-%@Kvm", [mnthPropertyDic valueForKey:@"from_area"],[mnthPropertyDic valueForKey:@"to_area"]];
	lblDesc.text=[mnthPropertyDic valueForKey:@"shortDescription"];
	lblCompName.text=[mnthPropertyDic valueForKey:@"companyname"];
	if(!imageViewPRP){
	imageViewPRP = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""]];
	imageViewPRP.frame = CGRectMake(0.0f, 0.0f, 135.0f,92.0f);
	[propImg addSubview:imageViewPRP];
	}
	imageViewPRP.imageURL =[NSURL URLWithString:[mnthPropertyDic valueForKey:@"thumbimage"]];
	promonthView.hidden=NO;
	[promonthView bringSubviewToFront:self.view];	
}

-(void)GdataUpdate{	
	NSString *urlstring=[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=updatesearch&udid=%@",appdel.udID];
    [AlertHandler showAlertForProcess];
	GdataParser *parserPremises= [[GdataParser alloc] init];
	[parserPremises downloadAndParse:[NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
						 withRootTag:@"updatesearch"
							withTags:[NSDictionary dictionaryWithObjectsAndKeys:nil]
								 sel:@selector(finishGdataUpdate:)
						  andHandler:self];
}

-(void)finishGdataUpdate:(NSDictionary*)dictionary{
    [AlertHandler hideAlert];
}

#pragma mark -
#pragma mark Table view data source

 //Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tblView numberOfRowsInSection:(NSInteger)section {	 
	lblCount.text=[NSString stringWithFormat:@"%d treff",[appdel.myCurrentData_arr count]];
	int c_cnt =25*Loadmorecnt;
	LoadMore.enabled =TRUE;
	LoadMore.alpha =1.0;
	if(c_cnt>[appdel.myCurrentData_arr count]){
		LoadMore.enabled =FALSE;
		
		LoadMore.alpha =0.3;
		c_cnt =[appdel.myCurrentData_arr count];
	}
	return c_cnt;	
}

- (CGFloat)tableView:(UITableView *)tblView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 92;	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		
	static NSString *CellIdentifier = @"PropertyListModeCell";    
    PropertyListModeCell *cell = (PropertyListModeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {            
        NSArray *nib = nil;        
		nib = [[NSBundle mainBundle] loadNibNamed:@"PropertyListModeCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];   
		      
        imageViewL = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""]];
        imageViewL.frame = CGRectMake(10.0f, 11.0f, 113, 85.0f);
        cell.imgView.hidden = TRUE;
        [cell.contentView addSubview:imageViewL];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;		
        
    }  
	if(appdel.isNew_add){
		imageViewL.imageURL = [NSURL URLWithString:[[appdel.myCurrentData_arr objectAtIndex:indexPath.row] valueForKey:@"mainimage"]];
		[cell setData:[appdel.myCurrentData_arr objectAtIndex:indexPath.row]];
	}
	else {		
		NSString *mystr =[[appdel.myCurrentData_arr objectAtIndex:indexPath.row] valueForKey:@"mainimage"];
		imageViewL.imageURL = [NSURL URLWithString:mystr];
		[cell setData:[appdel.myCurrentData_arr objectAtIndex:indexPath.row]];
	}

	return cell; 
}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {   
	if(detailViewController){
		detailViewController =nil;
		[detailViewController release];
	}
    detailViewController = [[PropertiesDetailVC alloc] initWithNibName:@"PropertiesDetailVC" bundle:nil];
	isPushed =TRUE;
	detailViewController.showpropertuId =[[appdel.myCurrentData_arr objectAtIndex:indexPath.row] valueForKey:@"id"];
	[self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark -
#pragma mark UIMkMapView delegate methods

- (void)addGestureRecognizersToPiece:(UIView *)piece {
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    [piece addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view {
    CLLocationCoordinate2D location;    
    location.latitude = point.x;
    location.longitude = point.y;	
    return location;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer{
	CGPoint a  = [gestureRecognizer locationInView:_mapView];	
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    region.center = [_mapView convertPoint:a toCoordinateFromView:_mapView];
    span.latitudeDelta=_mapView.region.span.latitudeDelta/10.8;
    span.longitudeDelta=_mapView.region.span.longitudeDelta/10.8;
    region.span=span;
    
    [_mapView setRegion:region animated:TRUE];
}

-(void)getMapannotation: (NSMutableArray *)arr{
	if([arr count]==0)return;	
	_mapView = [[REVClusterMapView alloc] initWithFrame:CGRectMake(0,0, 320, 411)];
    _mapView.delegate = self;
	[MapView addSubview:_mapView];
	
	
	double minLat = [[[arr objectAtIndex:0 ]valueForKey:@"latitude"] floatValue];
	double maxLat = [[[arr objectAtIndex:0 ]valueForKey:@"latitude"] floatValue];
	double minLon = [[[arr objectAtIndex:0 ]valueForKey:@"longitude"] floatValue];
	double maxLon = [[[arr objectAtIndex:0 ]valueForKey:@"longitude"] floatValue];
	
	
	NSMutableArray *lat_arr = [arr valueForKey:@"latitude"];
	NSMutableArray *lon_arr = [arr valueForKey:@"longitude"];
	
	for(int i = 0; i<[lat_arr count];i++){
		float  t_float = [[lat_arr objectAtIndex:i]floatValue];
		if( t_float < minLat){			
			minLat =t_float;
		}		
		if(t_float > maxLat){
			maxLat =t_float;	
		}	
	}
	
	for(int i = 0; i<[lon_arr count];i++){
		float t_float = [[lon_arr objectAtIndex:i] floatValue];
		if( t_float < minLon){			
			minLon =t_float;
		}
		
		if(t_float > maxLon){
			maxLon =t_float;
			
		}
		
	}
	

	MKCoordinateRegion region;
	region.center.latitude = (maxLat + minLat) / 2.0;
	region.center.longitude = (maxLon + minLon) / 2.0;
	region.span.latitudeDelta = (maxLat - minLat) * 0.84;
	region.span.longitudeDelta = (maxLon - minLon) * 0.84;
	_mapView.region = region;
	
	//MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake((maxLat + minLat) / 2.0, (maxLon + minLon) / 2.0), 1000.0, 1000.0);
//	region.span.latitudeDelta = MAX(region.span.latitudeDelta, (maxLat - minLat) * 0.95);
//	region.span.longitudeDelta = MAX(region.span.longitudeDelta, (maxLon - minLon) * 0.95);
	
	
//	CLLocationCoordinate2D coordinate;
//	
//   
//	_mapView.centerCoordinate = coordinate;
//	if(isSearchArea){
//		//int cnt = [arr count]/2;			
//		
//		MKCoordinateRegion region;
//        region.center.latitude = (maxLat + minLat) / 2.0;
//        region.center.longitude = (maxLon + minLon) / 2.0;
//        region.span.latitudeDelta = (maxLat - minLat) * 1.05;
//        region.span.longitudeDelta = (maxLon - minLon) * 1.05;
//        _mapView.region = region;
//		
//		
//		//coordinate.latitude = [[[arr objectAtIndex:0 ]valueForKey:@"latitude"] floatValue];
////		coordinate.longitude = [[[arr  objectAtIndex:0 ]valueForKey:@"longitude"] floatValue];
////		
////			
////		MKCoordinateRegion region;  
////		MKCoordinateSpan span;  
////		span.latitudeDelta=0.09;
////		span.longitudeDelta=0.09; 			
////		region.span=span;  
////		region.center=coordinate; 			
////		[_mapView setRegion:region animated:TRUE];  
//	//_mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 7000, 7000);
//	}
//	else {
//		
//		
//		if(appdel.isNearBy){
//			//appdel.strAppLat=@"59.90965726713029";
////			appdel.strAppLong=@"10.72318448771361";
//			coordinate.latitude = [appdel.strAppLat floatValue];
//			coordinate.longitude = [appdel.strAppLong floatValue];		
//			MKCoordinateRegion region;  
//			MKCoordinateSpan span;  
//			span.latitudeDelta=.50;  
//			span.longitudeDelta=.50; 			
//			region.span=span;  
//			region.center=coordinate; 			
//			[_mapView setRegion:region animated:TRUE];  
//			
//			
//		}
//		else {
//			coordinate.latitude = [[[arr objectAtIndex:0] valueForKey:@"latitude"] floatValue];
//			coordinate.longitude = [[[arr  objectAtIndex:0] valueForKey:@"longitude"] floatValue];
//			_mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 500000, 500000);
//
//		}
//
//	}

	
		
	NSMutableArray *pinsArray = [NSMutableArray array];  
	
    for(int i=0;i<[arr count];i++) {		
		CGFloat lat = [[[arr  objectAtIndex:i] valueForKey:@"latitude"] floatValue];
		CGFloat lng = [[[arr objectAtIndex:i] valueForKey:@"longitude"] floatValue];		
        CLLocationCoordinate2D newCoord = {lat,lng};
        REVClusterPin *pin = [[REVClusterPin alloc] init];
		if([[[arr objectAtIndex:i] valueForKey:@"houseno"] isEqualToString:@""]){
			pin.title = [NSString stringWithFormat:@"%@%@,",[[arr objectAtIndex:i] valueForKey:@"adress"],[[arr objectAtIndex:i] valueForKey:@"houseno"]];
		}
		else {
			pin.title = [NSString stringWithFormat:@"%@ %@,",[[arr objectAtIndex:i] valueForKey:@"adress"],[[arr objectAtIndex:i] valueForKey:@"houseno"]];

		}

		pin.subtitle =[NSString stringWithFormat:@"%@ %@",[[arr objectAtIndex:i] valueForKey:@"zip_code"],[[arr objectAtIndex:i] valueForKey:@"townname"]];;
		pin.pinid=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i]valueForKey:@"id"]];
		pin.coordinate = newCoord;
		[pinsArray addObject:pin];
        [pin release]; 
    }    
    [_mapView addAnnotations:pinsArray];
	
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{    
	REVClusterPin *sle=view.annotation;
	selected_pinId=sle.pinid;
    NSLog(@"did select%@",sle.pinid);
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
	if([annotation class] == MKUserLocation.class) 	return nil;
    
    REVClusterPin *pin = (REVClusterPin *)annotation;    
    MKAnnotationView *annView;    
    if( [pin nodeCount] > 1  ){
        annView = (REVClusterAnnotationView*)[mV dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        if( !annView )
			annView = (REVClusterAnnotationView*)[[[REVClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"] autorelease];
        annView.image = [UIImage imageNamed:@"marker_w_number.png"];   
		
		[(REVClusterAnnotationView*)annView setClusterText:[NSString stringWithFormat:@"%i",[pin nodeCount]]];
        [(REVClusterAnnotationView*)annView setEnabled:YES];    
        [(REVClusterAnnotationView*)annView setExclusiveTouch:YES];      
        [(REVClusterAnnotationView*)annView setIsAccessibilityElement:YES];
        [(REVClusterAnnotationView*)annView setMultipleTouchEnabled:YES];
        [(REVClusterAnnotationView*)annView setUserInteractionEnabled:YES];       
        //annView.canShowCallout = YES;
        [annView setEnabled:YES];  		
			[self addGestureRecognizersToPiece:annView];
    }
	
		else {
        annView = [mV dequeueReusableAnnotationViewWithIdentifier:@"pin"];      
        if( !annView )
            annView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"] autorelease];
        
        annView.image = [UIImage imageNamed:@"marker_property.png"];
        annView.canShowCallout = YES; 
		[annView setEnabled:YES];			
		NSString *pintitle=[NSString stringWithFormat:@"%@",((MKPinAnnotationView*) annView).annotation.title];
		for (int i = 0; i<[appdel.myCurrentData_arr count]; i++)
		{
			NSMutableDictionary *d_temp	= (NSMutableDictionary*)[appdel.myCurrentData_arr objectAtIndex:i];
			NSString *strAddress =@"";
			
			if([[[appdel.myCurrentData_arr objectAtIndex:i] valueForKey:@"houseno"] isEqualToString:@""]){
				strAddress = [NSString stringWithFormat:@"%@%@,",[d_temp valueForKey:@"adress"],[d_temp valueForKey:@"houseno"]];			
				
			}
			else {
				strAddress = [NSString stringWithFormat:@"%@ %@,",[d_temp valueForKey:@"adress"],[d_temp valueForKey:@"houseno"]];			
				
			}
	
			if([strAddress isEqualToString:pintitle]) 
			{
				
				UIButton *imageview =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 32)];
				//NSURL *imgURL= [[NSURL	alloc] initWithString:[d_temp objectForKey:@"mainimage"]]; 
				//[imageview setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imgURL]] forState:UIControlStateNormal]; 
				
				
				EGOImageView *imageViewc = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""]];
				imageViewc.frame = CGRectMake(-5.0f, -5.0f, 68.0f,41.0f);
				imageViewc.imageURL =[NSURL URLWithString:[d_temp objectForKey:@"mainimage"]];
				[imageview addSubview:imageViewc];
				annView.leftCalloutAccessoryView =imageview;
				//annView.leftCalloutAccessoryView =imageview;				
				UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
				[infoButton setFrame:CGRectMake(annView.bounds.size.width-35,10,30,30)];
				infoButton.tag=[[d_temp objectForKey:@"id"] intValue];
				//infoButton.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DDOrange.png"]];
				[infoButton setImage:[UIImage imageNamed:@"DDOrange.png"] forState:UIControlStateNormal];
				annView.userInteractionEnabled =TRUE;
				annView.rightCalloutAccessoryView = infoButton;
				[infoButton addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
				[imageview addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
				
				break;
			}
			
		}
    }
    return annView;
}





#pragma mark -
#pragma mark custom methods

-(void)clickSokeFilter {
	[_mapView removeFromSuperview];
	_mapView = nil;
	[_mapView release];
	if(filterViewController){
		filterViewController =nil;
		[filterViewController release];
	}
	filterViewController = [[SokeFilterVC alloc] initWithNibName:@"SokeFilterVC" bundle:nil];
	[self.navigationController pushViewController:filterViewController animated:YES];
}

-(void)ButtonPressed:(id)sender{	
	appdel.isDetail=TRUE;
	if (objPropertyDetailVC!=nil) {
		[objPropertyDetailVC release];
	}
	objPropertyDetailVC = [[PropertiesDetailVC alloc] initWithNibName:@"PropertiesDetailVC" bundle:nil];
	objPropertyDetailVC.showpropertuId = selected_pinId;
	isPushed =TRUE;
	[self.navigationController pushViewController:objPropertyDetailVC animated:YES];
}

-(void)PickerStatus_hidden:(BOOL)show{
	downPickerToolBar.hidden =show;
	lblTypeLokale.hidden =show;
	btnFerdig.hidden =show;
	typeLokalePicker.hidden =show;
}

-(IBAction)clickClose {
	promonthView.hidden =TRUE;	
}

-(IBAction)onLoadMore:(id)Sender{	
	Loadmorecnt=Loadmorecnt+1;
	[tblView reloadData];
	
}

-(IBAction)clickProperty{
	if(objPropertyDetailVC){
		objPropertyDetailVC = nil;
		[objPropertyDetailVC release];
	}
	objPropertyDetailVC = [[PropertiesDetailVC alloc] initWithNibName:@"PropertiesDetailVC" bundle:nil];
	isPushed =TRUE;
	objPropertyDetailVC.showpropertuId=[mnthPropertyDic valueForKey:@"id"];		
	[self.navigationController pushViewController:objPropertyDetailVC animated:YES];
}

-(IBAction)clickSortList {
	[self GDATASortList];	
}

-(void)clickFerdig {	
	[self GDATASortListDisplay];	
}
-(IBAction)clickList {	
	_mapView.hidden =YES;
	mapView.hidden =YES;
	MapView.hidden =YES;
	listView.hidden =NO;
	tblView.hidden=NO;	
	imgSegKart.image=[UIImage imageNamed:@"topBarlist.png"];
	listView.userInteractionEnabled =YES;
}

-(IBAction)clickKart {	
	[self getMapannotation:appdel.myCurrentData_arr];
	_mapView.hidden =NO;
	mapView.hidden =NO;
	MapView.hidden =NO;
	listView.hidden =YES;
	mapView.userInteractionEnabled =YES;
	imgSegKart.image=[UIImage imageNamed:@"topBarKart.png"];	
}

-(void)clickBack {
	if(appdel.isNew_add) [self GdataUpdate];		
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Picker View Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	return [arrayTypeLokale count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[arrayTypeLokale objectAtIndex:row] valueForKey:@"sortby"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	selrow =row;
	lblSort.text=[[arrayTypeLokale objectAtIndex:row] valueForKey:@"sortby"];
	[thePickerView reloadAllComponents];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 20)];
	UILabel *pickerLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(30, 0.0, 250, 20)];
	[pickerLabelLeft setTextAlignment:UITextAlignmentLeft];
	pickerLabelLeft.font=[UIFont boldSystemFontOfSize:18];
	pickerLabelLeft.backgroundColor = [UIColor clearColor];
	[pickerLabelLeft setText:[NSString stringWithFormat:@"%@",[[arrayTypeLokale valueForKey:@"sortby"]objectAtIndex:row]]];
	UIButton *btnCheck = [UIButton buttonWithType:UIButtonTypeCustom];
	btnCheck.frame = CGRectMake(5, 0, 15, 15);
	if(row==selrow){	
		[btnCheck setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
		pickerLabelLeft.textColor = [UIColor orangeColor];		
	}
	else {
		[btnCheck setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
	}	
	[customView addSubview:pickerLabelLeft];
	[customView addSubview:btnCheck];	
	return customView;	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	EGOCache *t =[[EGOCache alloc]init];
	[t clearCache];
	[t release];
}
- (void)viewDidUnload {
    [super viewDidUnload];    
}
- (void)dealloc {
	[super dealloc];
	[arrayTypeLokale release];
	[imageViewL release];
	[imageViewPRP release];
	[objPropertyDetailVC release];	
}
@end
