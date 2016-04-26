//
//  RootViewController.m
//  EstateLokaler
//
//  Created by apple on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  test.....

#import "RootViewController.h"
#import "PropertyListMode.h"
#import "MineSokVC.h"
#import "MineFunnVC.h"
#import "PropertyMapMode.h"
#import "GdataParser.h"
#import "EstateLokalerAppDelegate.h"
#import "PropertyMapMode.h"
#import "SokeFilterVC.h"
#import "Overlay.h"
#import "MineSokVC.h"
#import "WSPContinuous.h"
#import "webService.h"
#import "ContactUs.h"
#import "EstateMedia.h"

@implementation RootViewController




#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication]delegate];
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone; 
	locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
	

	txtSearch.delegate=self;

	appdel.currentElement=0;
	
	self.navigationController.navigationBar.hidden = YES;
		
	[viewSokAlert setFrame:CGRectMake(19, 470, 285, 185)];
	
	[matchNotFound setFrame:CGRectMake(19, 470, 285, 185)];
	
	pastUrls = [[NSMutableArray alloc] init];
	
	
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(60, 160, 209, 84) style:UITableViewStylePlain];
    autocompleteTableView.alpha =0.7;
	autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;  
    [self.view addSubview:autocompleteTableView];
	    
}

#pragma mark -
#pragma mark CLLocationManagerDelegate
#define MINIMUM_DISTANCE 200

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
	
	appdel.strAppLat= [[NSString alloc]initWithFormat:@"%g",newLocation.coordinate.latitude];
	appdel.strAppLong = [[NSString alloc]initWithFormat:@"%g",newLocation.coordinate.longitude];
    appdel.lat = newLocation.coordinate.latitude;
    appdel.lon = newLocation.coordinate.longitude;
	
	}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager FAIL");
}

- (void)viewWillAppear:(BOOL)animated{
	[locationManager startUpdatingLocation];
	appdel.signSok=0;
	appdel.flagFilter=0;
	appdel.flagFilter=0;
	appdel.flagsokSearch=0;	
	appdel.flagOfTwelve=0;
	appdel.flagOfPremises=0;
	[txtSearch resignFirstResponder];
	[locationManager startUpdatingHeading];
	autocompleteTableView.hidden=TRUE;
	
	txtSearch.text=@"";
    lblcnt.hidden =TRUE;
    lblCountText.hidden =TRUE;
    newPropertyofmnthBtn.hidden =TRUE;
    newPropertyofmnthIMG.hidden =TRUE;

	if(appdel.sokCnt==0)
	{
		[viewSokAlert setFrame:CGRectMake(19, 120, 285, 185)];
    }
    else if (appdel.sokCnt==10) {
        [viewSokAlert setFrame:CGRectMake(19, 120, 285, 185)];
    }
	else {
		[viewSokAlert setFrame:CGRectMake(19, 490, 285, 185)];
	}

	strSokSearch=@"";
	self.view.userInteractionEnabled =FALSE;
	[self GDATACount];
		
}

// following method will be called frequently.

-(void)showTime{
    lblTime.text=[[NSDate date] description];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    autocompleteTableView.hidden = NO;
    
    NSString *substring = [NSString stringWithString:txtSearch.text];
    substring = [substring  stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
	if( pastUrls.count==0){
	  autocompleteTableView.hidden =TRUE;
	autocompleteTableView.frame =CGRectMake(60, 160, 209, 84);
		return pastUrls.count;
	}
	
	if([pastUrls count]<3){
		autocompleteTableView.frame =CGRectMake(60, 160, 209, 27.6*[pastUrls count]);	
	}
	else {
		autocompleteTableView.frame =CGRectMake(60, 160, 209, 84);
	}

	return pastUrls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
  
	cell.textLabel.backgroundColor =[UIColor clearColor];
    cell.textLabel.text=[pastUrls objectAtIndex:indexPath.row];
	cell.textLabel.font=[UIFont systemFontOfSize:16.0];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 27.6;	
}


#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    txtSearch.text = selectedCell.textLabel.text;
    autocompleteTableView.hidden =YES;
	
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view

    [pastUrls removeAllObjects];
    for(NSString *curString in appdel.autosuggested_arr) {
        NSRange substringRange = [curString rangeOfString:substring options:NSCaseInsensitiveSearch];
		
        //NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [pastUrls addObject:curString];  
        }
    }
	if([substring isEqualToString:@""]){
		pastUrls= [appdel.autosuggested_arr mutableCopy];
	
	}
    [autocompleteTableView reloadData];
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	 
	autocompleteTableView.hidden =FALSE;
	[autocompleteTableView reloadData];
	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	autocompleteTableView.hidden =YES;
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark Custom methods

//on new property//
-(IBAction)clickNewAddedProperty:(id)sender
{	
	appdel.isNew_add =TRUE;
	appdel.isNearBy =FALSE;
	if (objPropertyList) {
		objPropertyList = nil;
       [objPropertyList release];
	}          
	objPropertyList = [[PropertyListMode alloc] initWithNibName:@"PropertyListMode" bundle:nil];
	[self.navigationController pushViewController:objPropertyList animated:YES];

}
	
-(void)clickMineSok{
	[self GDATAMineSok];    
}

-(void)clickMineFunn{
	[self GDATAMinefunn];
}

-(void)clickSokBtn{	 
    [txtSearch resignFirstResponder];
    BOOL isPresent =FALSE;
    NSString *txtVal =txtSearch.text;
    for(NSString *str in pastUrls){
        if([txtVal isEqualToString:@""])
            break;        
        if([str isEqualToString:txtVal]){            
            isPresent =TRUE;
            break;
        }
    }    
    if(isPresent ||[txtVal isEqualToString:@""]){    
        strSokSearch=txtSearch.text;
		[self GDATASearch];    
    }
    else{       
        [matchNotFound setFrame:CGRectMake(19, 120, 285, 185)];
    }
    
}

-(IBAction)clickLokalerNaerheten {	   
	[self GDATAPremises];	
}


-(void)clickLukk {
	[matchNotFound setFrame:CGRectMake(19, 470, 285, 185)];
	[viewSokAlert setFrame:CGRectMake(19, 470, 285, 185)];
}

-(IBAction)clickContactUs{
	
	ContactUs *objContactUs=[[ContactUs	alloc]initWithNibName:@"ContactUs" bundle:nil];
	[self.navigationController pushViewController:objContactUs animated:YES];
	[objContactUs release];
}
-(IBAction)clickEstateMedia{
	EstateMedia *objEstateMedia = [[EstateMedia alloc]initWithNibName:@"EstateMedia" bundle:nil];
	[self.navigationController pushViewController:objEstateMedia animated:YES];
	[objEstateMedia release];
}

//web service 
//On sok pass searchbox text
-(void)GDATAMinefunn{
	[AlertHandler showAlertForProcess];
	GdataParser *parser = [[GdataParser alloc] init];
	[parser downloadAndParse:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=getads&udid=%@",appdel.udID]]
				 withRootTag:@"post" 
					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"title",@"title",@"adress",@"adress",@"houseno",@"houseno",@"latitude",@"latitude",@"longitude",@"longitude",@"shortDescription",@"shortDescription",@"mainimage",@"mainimage",@"areaname",@"areaname",@"townname",@"townname",@"fromarea",@"fromarea",@"toarea",@"toarea",@"departmentname",@"departmentname",@"zip_code",@"zip_code",nil]
						 sel:@selector(finishGetDataminefunn:) 
				  andHandler:self];



}
-(void)finishGetDataminefunn:(NSDictionary*)dictionary{	
	appdel.frmSok =FALSE;
    [AlertHandler hideAlert];
	NSMutableArray *t_arr =[dictionary valueForKey:@"array"];
	[appdel.myCurrentData_arr removeAllObjects];
	appdel.myCurrentData_arr =[t_arr mutableCopy];
	if([appdel.myCurrentData_arr count]==0){	
		myError_msgLbl.text =@"Vi finner ikke tilgjengelig lagre eiendom for deg.";
		[viewSokAlert setFrame:CGRectMake(19, 120, 285, 185)];
	}
	else {
		if(minefunnViewController){
			minefunnViewController =nil;
			[minefunnViewController release];
		}
		minefunnViewController = [[MineFunnVC alloc] initWithNibName:@"MineFunnVC" bundle:nil];
		[self.navigationController pushViewController:minefunnViewController animated:YES];
		
	}
	
}



-(void)GDATAMineSok{
	
	[AlertHandler showAlertForProcess];
    GdataParser *parser = [[GdataParser alloc] init];    
	[parser downloadAndParse:[NSURL
							  URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=getsearch&udid=%@",appdel.udID]]
				 withRootTag:@"post" 
					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"town_id",@"town_id",@"area_id",@"area_id",@"department_id",@"department_id",
							  @"from_area",@"from_area",@"to_area",@"to_area",@"date_insert",@"date_insert",
							  @"category_id",@"category_id",@"date_insert",@"date_insert",nil]
	 
						 sel:@selector(finishGetDataminesok:)
				  andHandler:self]; 


}
-(void)finishGetDataminesok:(NSDictionary*)dictionary{	
    [AlertHandler hideAlert];
	NSMutableArray *t_arr =[dictionary valueForKey:@"array"];
	[appdel.mineSok_arr removeAllObjects];
	appdel.mineSok_arr =[t_arr mutableCopy];
	if([appdel.mineSok_arr count]==0){	
		myError_msgLbl.text =@"Vi finner ikke tilgjengelig Lagre søket for deg";
			[viewSokAlert setFrame:CGRectMake(19, 120, 285, 185)];
	}
	else {
		if (detailViewController!=nil) {
			[detailViewController release];
		}
		detailViewController = [[MineSokVC alloc] initWithNibName:@"MineSokVC" bundle:nil];
		[self.navigationController pushViewController:detailViewController animated:YES];
	}

}
	
	
-(void)GDATASearch{	
	appdel.isNew_add =FALSE;
	appdel.isNearBy =FALSE;
	[AlertHandler showAlertForProcess];	

	NSString *urlstring=[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=propertylist&txt_sted=%@&sortby=2",strSokSearch];
	appdel.urlPropertylist =urlstring;
	
	GdataParser *parserSearch= [[GdataParser alloc] init];
	[parserSearch downloadAndParse:[NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
					   withRootTag:@"post" 
						  withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"title",@"title",@"adress",@"adress",@"houseno",@"houseno",@"latitude",
									@"latitude",@"longitude",@"longitude",@"shortDescription",@"shortDescription",@"mainimage",@"mainimage",@"areaname",@"areaname",@"townname",@"townname"
									,@"fromarea",@"fromarea",@"toarea",@"toarea",@"departmentname",@"departmentname",@"zip_code",@"zip_code",nil]
							   sel:@selector(finishGetDataSokSearch:) 
						andHandler:self];
}

-(void)finishGetDataSokSearch:(NSDictionary*)dictionary{
	[AlertHandler hideAlert];
	NSMutableArray *t_arr =[dictionary valueForKey:@"array"];
	[appdel.myCurrentData_arr removeAllObjects];
	appdel.myCurrentData_arr  = [t_arr mutableCopy];
	
	if ([t_arr count]==0) {
		
		myError_msgLbl.text =@"Vi finner ikke tilgjengelig eiendom for dette søket";
		[viewSokAlert setFrame:CGRectMake(19, 120, 285, 185)];
	}
	else {
		if(objPropertyList){
			objPropertyList = nil;
			[objPropertyList release];
		
		}
		
		objPropertyList = [[PropertyListMode alloc] initWithNibName:@"PropertyListMode" bundle:nil];
		objPropertyList.isSearchArea =TRUE;
		if([txtSearch.text isEqualToString:@""]){
			objPropertyList.isSearchArea =FALSE;
		}
		[self.navigationController pushViewController:objPropertyList animated:YES];
	}

	
	
	NSLog(@"%d",[t_arr count]);

}

//on lokaler i nerheten
-(void)GDATAPremises{
	[AlertHandler showAlertForProcess];
	appdel.isNew_add =FALSE;
	appdel.isNearBy =TRUE;
	//appdel.strAppLat=@"59.90965726713029";
	//appdel.strAppLong=@"10.72318448771361";
	//NSString *urlstring=[NSString stringWithFormat:@"http://www.estatelokaler.no/response.php?token=closureprop&lat=59.90965726713029&lon=10.72318448771361"];
	//NSString *urlstring=[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=closureprop&lat=23.077242&lon=72.634650"];
	//NSLog(@"user current lat:%@, long:%@",appdel.lat,appdel.lon);
	NSString *urlstring=[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=closureprop&lat=%@&lon=%@",appdel.strAppLat,appdel.strAppLong];
	
	GdataParser *parserPremises= [[GdataParser alloc] init];
	[parserPremises downloadAndParse:[NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
						 withRootTag:@"post" 
							withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"title",@"title",@"adress",@"adress",@"houseno",@"houseno",@"latitude",
									  @"latitude",@"longitude",@"longitude",@"shortDescription",@"shortDescription",@"mainimage",@"mainimage",@"areaname",@"areaname",@"townname",@"townname"
									  ,@"fromarea",@"fromarea",@"toarea",@"toarea",@"departmentname",@"departmentname",@"zip_code",@"zip_code",nil]
								 sel:@selector(finishGetDataPremises:) 
						  andHandler:self];
}

-(void)finishGetDataPremises:(NSDictionary*)dictionary{
	[AlertHandler hideAlert];
	NSMutableArray *t_arr =[dictionary valueForKey:@"array"];
	[appdel.myCurrentData_arr removeAllObjects];
	appdel.myCurrentData_arr  = [t_arr mutableCopy];
	
	NSLog(@"%d",[t_arr count]);
	objPropertyList.isSearchArea =FALSE;	
	if ([t_arr count]==0) {
		myError_msgLbl.text =@"Vi finner ingen tilgjengelige lokaler i nærheten av deg.";
		[viewSokAlert setFrame:CGRectMake(19, 120, 285, 185)];
	}
	else {
		
		if(objPropertyList){
			objPropertyList = nil;
			[objPropertyList release];
			
		}
				
		objPropertyList = [[PropertyListMode alloc] initWithNibName:@"PropertyListMode" bundle:nil];
		[self.navigationController pushViewController:objPropertyList animated:YES];
		
	}
		
	
}


//Autosuggestedlist
-(void)GDATAAutoSugested{	
	[AlertHandler showAlertForProcess];
	
	GdataParser *parser = [[GdataParser alloc] init];
	[parser downloadAndParse:[NSURL
							  URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=autosuggsted"]]
				 withRootTag:@"post" 
					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"cnt",@"cnt",nil]
	 					 sel:@selector(finishGetData:) 
				  andHandler:self];
}

-(void)finishGetData:(NSDictionary*)dictionary{
	self.view.userInteractionEnabled =TRUE;
	[AlertHandler hideAlert];
	NSMutableArray *t_arr =[[dictionary valueForKey:@"array"]retain];
	
	appdel.autosuggested_arr =[[t_arr valueForKey:@"cnt"] mutableCopy];
	pastUrls= [[t_arr valueForKey:@"cnt"] mutableCopy];	//NSLog(@"This is dictionary: %@",dictionary);
}

-(void)GDATACount{
	self.view.userInteractionEnabled =FALSE;
    WSPContinuous *wspcontinuous;
    wspcontinuous = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_countXML:appdel.udID]]
                                                            rootTag:@"getnewpropertiescount"
                                                        startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] 
                                                          endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"getnewpropertiescount",@"getnewpropertiescount",nil]
                                                          otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] 
                                                                sel:@selector(finishedParsing:) 
                                                         andHandler:self];
}

-(void)finishedParsing:(NSDictionary*)dictionary{
	if(dictionary == NULL){
		self.view.userInteractionEnabled =TRUE;
		return;
		
	}
	[self GDATAAutoSugested];
	NSString *cnt_str=[[[[dictionary valueForKey:@"array"] objectAtIndex:0]valueForKey:@"getnewpropertiescount"]retain];
	//NSLog(cnt_str);
	[UIApplication sharedApplication].applicationIconBadgeNumber = [cnt_str integerValue];
	
	if (![cnt_str isEqualToString:@"0"]) {					
		lblCountText.text=[NSString stringWithFormat:@"Det er lagt til %@ nye lokaler som matcher dine lagrede søk",cnt_str];	
		lblcnt.text=[NSString stringWithFormat:@"%@",cnt_str];
		lblcnt.hidden =FALSE;
		lblCountText.hidden =FALSE;
		newPropertyofmnthBtn.hidden =FALSE;
		newPropertyofmnthIMG.hidden =FALSE;
	}
        
	else{
            lblcnt.hidden =TRUE;
            lblCountText.hidden =TRUE;
            newPropertyofmnthBtn.hidden =TRUE;
            newPropertyofmnthIMG.hidden =TRUE;            
        }		
}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}
- (void)dealloc {
    [super dealloc];
	[lblCountText release];		
	[txtSearch release];
	[lblTime release];  
	[pastUrls release];
}
@end