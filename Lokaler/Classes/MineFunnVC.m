//
//  MineFunnVC.m
//  EstateLokaler
//
//  Created by apple on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MineFunnVC.h"
#import "MineFunnCell.h"
#import "UITableViewCell+NIB.h"
#import "EstateLokalerAppDelegate.h"
#import "GdataParser.h"
#import "MineSokCell.h"
#import "UITableViewCell+NIB.h"
#import "EGOImageView.h"
#import "PropertiesDetailVC.h"
#import "REVClusterMapView.h"
#import "REVClusterPin.h"
#import "REVClusterAnnotationView.h"

@implementation MineFunnVC

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication]delegate];		
	mapView.hidden=YES;
	listView.hidden=NO;
}

- (void)viewWillAppear:(BOOL)animated{
	Loadmorecnt=1;
	if(appdel.frmSok){
		[btnBack setImage:[UIImage imageNamed:@"bckarr.png"] forState:UIControlStateNormal];
		btnDelete.hidden=TRUE;		
	}
	else{
		[btnBack setImage:[UIImage imageNamed:@"homebtn.png"] forState:UIControlStateNormal];
	}
}


-(void)GDATADelete:(NSString *)idVal{	
	GdataParser *parser1 = [[GdataParser alloc] init];
	[parser1 downloadAndParse:[NSURL  URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=deletemyads&udid=%@&propids=%@",appdel.udID,idVal]]
					 withRootTag:@"deletemyads" withTags:[NSDictionary dictionaryWithObjectsAndKeys:nil]
						 sel:@selector(finishGetDataDelete:) andHandler:self];	
}

-(void)finishGetDataDelete:(NSDictionary*)dictionary{
	[tableView reloadData];
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {		
	
	int c_cnt =25*Loadmorecnt;
	LoadMore.enabled =TRUE;
	LoadMore.alpha =1.0;
	if(c_cnt>[appdel.myCurrentData_arr count]){
		LoadMore.enabled =FALSE;
		
		LoadMore.alpha =0.3;
		c_cnt =[appdel.myCurrentData_arr count];
	}
	return c_cnt;
    return [appdel.myCurrentData_arr count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EGOImageView *imageViewL;	
	static NSString *CellIdentifier = @"MineFunnCell";    
    MineFunnCell *cell = (MineFunnCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {            
        NSArray *nib = nil;        
		nib = [[NSBundle mainBundle] loadNibNamed:@"MineFunnCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];  		
        imageViewL = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""]];
        imageViewL.frame = CGRectMake(9.0f, 6.0f, 113, 88.0f);
        cell.imgView.hidden = TRUE;
        [cell.contentView addSubview:imageViewL];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;        
    }  	
    NSMutableDictionary *temp_dic=[appdel.myCurrentData_arr objectAtIndex:indexPath.row];
	//cell.lblAvstand.text=[NSString stringWithFormat:@"Avstand:%@",[dist objectAtIndex:indexPath.row]];
	imageViewL.imageURL =[NSURL URLWithString:[temp_dic valueForKey:@"mainimage"]];
	[cell setData:temp_dic];		
	cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minesokcellbg.png"]];
    return cell;
}
-(IBAction)funnDelete{	
	if(self.editing)
	{ 
		[super setEditing:NO animated:NO]; 
		[tableView setEditing:NO animated:NO];
		[tableView reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Delete"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
		self.navigationItem.rightBarButtonItem.enabled=TRUE;
	}
	else
	{
		[super setEditing:YES animated:YES]; 
		
		[tableView setEditing:YES animated:YES];
		[tableView reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
		self.navigationItem.rightBarButtonItem.enabled=FALSE;
	}
	
	
}
- (void)tableView:(UITableView *)atableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self GDATADelete:[[appdel.myCurrentData_arr objectAtIndex:indexPath.row]valueForKey:@"id"]];
		[appdel.myCurrentData_arr removeObjectAtIndex:indexPath.row];
		[tableView reloadData];
	}
}	

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(detailViewController){
		detailViewController =nil;
		[detailViewController release];
	
	}
	detailViewController = [[PropertiesDetailVC alloc] initWithNibName:@"PropertiesDetailVC" bundle:nil];
	detailViewController.showpropertuId =[[appdel.myCurrentData_arr objectAtIndex:indexPath.row]valueForKey:@"id"];
	[self.navigationController pushViewController:detailViewController animated:YES];
	
}

-(IBAction)clickKart{
	img.image=[UIImage imageNamed:@"topBarKart.png"];
	listView.hidden=YES;
	mapView.hidden=NO;
	mapObj.hidden=NO;
	[self getMapannotation:appdel.myCurrentData_arr];
}

-(IBAction)clickList{
	[_mapView removeFromSuperview];
	_mapView = nil;
	[_mapView  release];
	img.image=[UIImage imageNamed:@"topBarlist.png"];	
	listView.hidden=NO;
	mapObj.hidden=YES;
	mapView.hidden=YES;	
	listView.userInteractionEnabled =YES;
}

-(void)getMapannotation: (NSMutableArray *)arr{
	if([arr count]==0)
		return;
	_mapView = [[REVClusterMapView alloc] initWithFrame:CGRectMake(0,0, 320, 420)];
    _mapView.delegate = self;
	[mapObj addSubview:_mapView];
	CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[[arr objectAtIndex:0] valueForKey:@"latitude"] floatValue];
    coordinate.longitude = [[[arr  objectAtIndex:0] valueForKey:@"longitude"] floatValue];
	_mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 500000, 500000);    
    
	NSMutableArray *pinsArray = [NSMutableArray array];
    
    for(int i=0;i<[arr count];i++) {
		
		CGFloat lat = [[[arr objectAtIndex:i] valueForKey:@"latitude"] floatValue];
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
		pin.imgURL= [[[arr objectAtIndex:i] valueForKey:@"mainimage"]retain];
		pin.coordinate = newCoord;
		[pinsArray addObject:pin];
        [pin release]; 
    }
    
    [_mapView addAnnotations:pinsArray];
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
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
        
        annView.image = [UIImage imageNamed:@"marker_w_number.png"];
        [(REVClusterAnnotationView*)annView setClusterText:[NSString stringWithFormat:@"%i",[pin nodeCount]]];
        annView.canShowCallout = YES;
		[self addGestureRecognizersToPiece:annView];
    } else {
        annView = [mV dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        
        if( !annView )
            annView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"] autorelease];
	
        annView.image = [UIImage imageNamed:@"marker_property.png"];
        annView.canShowCallout = YES; 
		[annView setEnabled:YES];
		NSString *pintitle=[NSString stringWithFormat:@"%@",((MKPinAnnotationView*) annView).annotation.title];
		
		for (int i = 0; i<[appdel.myCurrentData_arr count]; i++){	
			
			NSString *strAddress =@"";
			if([[[appdel.myCurrentData_arr objectAtIndex:i] valueForKey:@"houseno"] isEqualToString:@""]){
				strAddress = [NSString stringWithFormat:@"%@%@,",[[appdel.myCurrentData_arr objectAtIndex:i] valueForKey:@"adress"],[[appdel.myCurrentData_arr objectAtIndex:i] valueForKey:@"houseno"]];
			}
			else {
				strAddress = [NSString stringWithFormat:@"%@ %@,",[[appdel.myCurrentData_arr objectAtIndex:i] valueForKey:@"adress"],[[appdel.myCurrentData_arr objectAtIndex:i] valueForKey:@"houseno"]];
			}

			if([strAddress isEqualToString:pintitle]){	
				UIButton *imageview =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 32)];
				//NSURL *imgURL= [[NSURL	alloc] initWithString:[[appdel.myCurrentData_arr objectAtIndex:i] objectForKey:@"mainimage"]]; 
				//[imageview setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imgURL]] forState:UIControlStateNormal]; 
				//if(!imageViewc){
				EGOImageView *imageViewc = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""]];
				//imageViewc.frame = CGRectMake(0.0f, 0.0f, 60.0f,32.0f);
				imageViewc.frame = CGRectMake(-5.0f, -5.0f, 68.0f,41.0f);
				//}
				pin.eimgV = imageViewc;
				//pin.eimgV.imageURL =[NSURL URLWithString:[[appdel.myCurrentData_arr objectAtIndex:i] valueForKey:@"mainimage"]];
				[imageview addSubview:imageViewc];			
				[imageViewc release];
				annView.leftCalloutAccessoryView =imageview;	
				[imageview addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
				
				break;
			}			
		}
		

		UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];		
		[infoButton setFrame:CGRectMake(annView.bounds.size.width-35,10,25, 27)];
		[infoButton setImage:[UIImage imageNamed:@"DDOrange.png"] forState:UIControlStateNormal];
		annView.rightCalloutAccessoryView = infoButton;
		[infoButton addTarget:self action:@selector(ButtonPressed:)forControlEvents:UIControlEventTouchUpInside];
		
    }
    return annView;
	
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{    
	REVClusterPin *sle=view.annotation;
	sle.eimgV.image  =nil;
	sle.eimgV.imageURL =nil;
	selected_pinId=sle.pinid;
	sle.eimgV.imageURL = [NSURL URLWithString:sle.imgURL]; 

    NSLog(@"did select%@",sle.pinid);
	 NSLog(@" url %@",sle.imgURL);
}

- (void)addGestureRecognizersToPiece:(UIView *)piece{    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    [piece addGestureRecognizer:tapGesture];
    [tapGesture release];   
}


- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view{
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
    span.latitudeDelta=_mapView.region.span.latitudeDelta/6;
    span.longitudeDelta=_mapView.region.span.longitudeDelta/6;
    region.span=span;
    
    [_mapView setRegion:region animated:TRUE];
}



#pragma mark -
#pragma mark custom methods

-(IBAction)onLoadMore:(id)Sender{	
	Loadmorecnt=Loadmorecnt+1;
	[tableView reloadData];	
}
-(void)ButtonPressed:(id)sender{	
	if(detailViewController){
		detailViewController =nil;
		[detailViewController release];	
	}	
	detailViewController = [[PropertiesDetailVC alloc] initWithNibName:@"PropertiesDetailVC" bundle:nil];
	detailViewController.showpropertuId =selected_pinId;
	[self.navigationController pushViewController:detailViewController animated:YES];
}
-(void)clickBack{
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
	
}


@end
