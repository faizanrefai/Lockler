//
//  SokeFilterVC.m
//  EstateLokaler
//
//  Created by apple on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SokeFilterVC.h"
#import "GdataParser.h"
#import "EstateLokalerAppDelegate.h"
#import "PropertyListMode.h"
#import "ALPickerView.h"
#import "AlertHandler.h"

@implementation SokeFilterVC

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    [super viewDidLoad];
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication]delegate];	
	btnOmrade.userInteractionEnabled=FALSE;
	btnOmrade.alpha =0.3;
	lblArea.alpha =0.2;	
	lblArea.text=@"Alle Kommuner/Områder";
	lblSize.text=@"Alle Størrelser";
	lblTypeLokaleText.text=@"Alle Typer";
	lblFlyke.text=@"Alle Fylker";
	
	myselectedItemssize =[[NSMutableArray alloc] init];
	myselectedItemstype =[[NSMutableArray alloc] init];
	myselectedItemsflyker =[[NSMutableArray alloc] init];
	myselectedItemsarea =[[NSMutableArray alloc] init];
	entries =[[NSMutableArray alloc] init];	
	
	downPickerToolBar.hidden=TRUE;	
	btnFerdig.hidden=TRUE;
	lblTypeLokale.hidden=TRUE;
	[viewAlert setFrame:CGRectMake(19, 470, 285, 185)];
}

- (void)viewWillAppear:(BOOL)animated{
	if(appdel.isNearBy){
		
		btnFylke.userInteractionEnabled=FALSE;
		btnFylke.alpha =0.3;
		lblFlyke.alpha=0.2;
	}
	else {
		btnFylke.userInteractionEnabled=TRUE;
		btnFylke.alpha =1.0;
		lblFlyke.alpha=1.0;		
	}
	
}

-(void)GDATA{	
	[AlertHandler showAlertForProcess];	
	GdataParser *parser = [[GdataParser alloc] init];
	[parser downloadAndParse:[NSURL
							  URLWithString:@"http://www.estatelokaler.no/appservice.php?token=typelokale"]
				 withRootTag:@"post" 
					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"deptid",@"deptid",@"department",@"department",@"cnt",@"cnt",nil]
					sel:@selector(finishGetData:) 
				  andHandler:self];
}

-(void)finishGetData:(NSDictionary*)dictionary{
   [AlertHandler hideAlert];
	[entries removeAllObjects];
	[myselectedItemstype removeAllObjects];

    NSMutableArray *temp =[dictionary valueForKey:@"array"];
	entries =[temp mutableCopy]; ;
	tagValue =1;
	[self presentPickerView];
	
}

-(void)GDATAFylke{
	[AlertHandler showAlertForProcess];
	GdataParser *parser1 = [[GdataParser alloc] init];
	[parser1 downloadAndParse:[NSURL
							  URLWithString:@"http://www.estatelokaler.no/appservice.php?token=flyke"]
				 withRootTag:@"post" 
					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"townid",@"townid",@"town",@"town",@"cnt",@"cnt",nil]
						 sel:@selector(finishGetDataFylke:) 
				  andHandler:self];
}

-(void)finishGetDataFylke:(NSDictionary*)dictionary{
	[AlertHandler hideAlert];	
	[entries removeAllObjects];
	[myselectedItemsflyker removeAllObjects];
	NSMutableArray *temp =[dictionary valueForKey:@"array"];	
	entries =[temp mutableCopy]; ;
	tagValue =2;
	[self presentPickerView];	
}

-(void)GDATAArea{
	[AlertHandler showAlertForProcess];	
	NSString *prntStr =@"";
	for(int i= 0;i<[myselectedItemsflyker count];i++){
			if(i==0) prntStr =[NSString stringWithFormat:@"%@",[[myselectedItemsflyker objectAtIndex:i]valueForKey:@"townid"]];
			else prntStr =[NSString stringWithFormat:@"%@,%@",prntStr,[[myselectedItemsflyker objectAtIndex:i]valueForKey:@"townid"]];
	}
	NSLog(@"%@",prntStr);
	GdataParser *parser2 = [[GdataParser alloc] init];
			[parser2 downloadAndParse:[NSURL
								   URLWithString:[NSString stringWithFormat: @"http://www.estatelokaler.no/appservice.php?token=kommune&townIds=%@",prntStr]]
					  withRootTag:@"post" 
						 withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"areaid",@"areaid",@"area",@"area",@"cnt",@"cnt",nil]
							  sel:@selector(finishGetDataArea:) 
					   andHandler:self];
}

-(void)finishGetDataArea:(NSDictionary*)dictionary{
	[AlertHandler hideAlert];
	
	[entries removeAllObjects];
	[myselectedItemsarea removeAllObjects];
	NSMutableArray *temp =[dictionary valueForKey:@"array"];
	if([temp count]==0){
		btnOmrade.userInteractionEnabled=FALSE;
		btnOmrade.alpha =0.3;
		lblOmradeTitle.alpha=0.3;
		lblArea.alpha=0.3; 
	}
	else {
		entries =[temp mutableCopy]; ;	
		tagValue =3;
		[self presentPickerView];
	}

	
	
	
	
	
}

-(void)GDATASize{
	[AlertHandler showAlertForProcess];	
	GdataParser *parser3 = [[GdataParser alloc] init];
	[parser3 downloadAndParse:[NSURL
							   URLWithString:@"http://www.estatelokaler.no/appservice.php?token=size"]
				  withRootTag:@"post" 
					 withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"size_range",@"size_range",@"cnt",@"cnt",nil]
						  sel:@selector(finishGetDataSize:) 
				   andHandler:self];	
}
 
-(void)finishGetDataSize:(NSDictionary*)dictionary{
	[AlertHandler hideAlert];	
	[entries removeAllObjects];
	[myselectedItemssize removeAllObjects];
	NSMutableArray *temp =[dictionary valueForKey:@"array"];	
	entries =[temp mutableCopy];
		tagValue =4;
	[self presentPickerView];	
}


#pragma mark -
#pragma mark ALPickerView delegate methods

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView {
	return [entries count];
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row {
	if(tagValue==1)
		return [NSString stringWithFormat:@"%@" ,[[entries objectAtIndex:row]valueForKey:@"department"]] ;//],[[entries objectAtIndex:row]valueForKey:@"cnt"]];
	
	if(tagValue==2)
												  return [NSString stringWithFormat:@"%@" ,[[entries objectAtIndex:row]valueForKey:@"town"]];//,[[entries objectAtIndex:row]valueForKey:@"cnt"]];

	if(tagValue==3)
												  return [NSString stringWithFormat:@"%@" ,[[entries objectAtIndex:row]valueForKey:@"area"]];//,[[entries objectAtIndex:row]valueForKey:@"cnt"]];

	if(tagValue==4)
												  return [NSString stringWithFormat:@"%@" ,[[entries objectAtIndex:row]valueForKey:@"size_range"]];//,[[entries objectAtIndex:row]valueForKey:@"cnt"]];
return @"";
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row {
	return [[selectionStates objectForKey:[entries objectAtIndex:row]] boolValue];
}

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row {
	// Check whether all rows are checked or only one
	if (row == -1){
		for (id key in [selectionStates allKeys])
			[selectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
				
		if(tagValue==3){
			for(int i =0;i<[entries count];i++){	
				[myselectedItemsarea addObject:[entries objectAtIndex:i]];
			}
			lblArea.text=@"Alle Kommuner/Områder";
		}
		if(tagValue==4){	
			for(int i =0;i<[entries count];i++){	
				[myselectedItemssize addObject:[entries objectAtIndex:i]];
			}
			lblSize.text=@"Alle Størrelser";
		}
		if(tagValue==1) {
			for(int i =0;i<[entries count];i++){	
				[myselectedItemstype addObject:[entries objectAtIndex:i]];
			}
			lblTypeLokaleText.text=@"Alle Typer";
		}
		if(tagValue==2){
			for(int i =0;i<[entries count];i++){	
				[myselectedItemsflyker addObject:[entries objectAtIndex:i]];
			}
			lblFlyke.text=@"Alle Fylker";
		}
		}
	else{
		[selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[entries objectAtIndex:row]];
		NSString *prntStr =@"";
		
		if(tagValue==1){
		[myselectedItemstype addObject:[entries objectAtIndex:row]];
			for(int i= 0;i<[myselectedItemstype count];i++){
				if(i==0) prntStr =[NSString stringWithFormat:@"%@",[[myselectedItemstype objectAtIndex:i]valueForKey:@"department"]];
				
				else prntStr =[NSString stringWithFormat:@"%@,%@",prntStr,[[myselectedItemstype objectAtIndex:i]valueForKey:@"department"]];
			}
		}
		if(tagValue==2){
			[myselectedItemsflyker addObject:[entries objectAtIndex:row]];
			for(int i= 0;i<[myselectedItemsflyker count];i++){
				if(i==0)prntStr =[NSString stringWithFormat:@"%@",[[myselectedItemsflyker objectAtIndex:i]valueForKey:@"town"]];
					
				else prntStr =[NSString stringWithFormat:@"%@,%@",prntStr,[[myselectedItemsflyker objectAtIndex:i]valueForKey:@"town"]];
								
			}
		}
		if(tagValue==3){
			[myselectedItemsarea addObject:[entries objectAtIndex:row]];
			for(int i= 0;i<[myselectedItemsarea count];i++){
				if(i==0) prntStr =[NSString stringWithFormat:@"%@",[[myselectedItemsarea objectAtIndex:i]valueForKey:@"area"]];
				else prntStr =[NSString stringWithFormat:@"%@,%@",prntStr,[[myselectedItemsarea objectAtIndex:i]valueForKey:@"area"]];
							
			}
		}
		if(tagValue==4){
			[myselectedItemssize addObject:[entries objectAtIndex:row]];
			for(int i= 0;i<[myselectedItemssize count];i++){
				if(i==0)prntStr =[NSString stringWithFormat:@"%@",[[myselectedItemssize objectAtIndex:i]valueForKey:@"size_range"]];
				else prntStr =[NSString stringWithFormat:@"%@,%@",prntStr,[[myselectedItemssize objectAtIndex:i]valueForKey:@"size_range"]];
			}
		}		
		if([prntStr isEqualToString:@""]){
			
			if(tagValue==3)	lblArea.text=@"Alle Kommuner/Områder";
			if(tagValue==4)	lblSize.text=@"Alle Størrelser";
			if(tagValue==1) lblTypeLokaleText.text=@"Alle Typer";
			if(tagValue==2)lblFlyke.text=@"Alle Fylker";
			}
			else {
				if(tagValue==3)	lblArea.text=prntStr;
				if(tagValue==4)	lblSize.text=prntStr;
				if(tagValue==1) lblTypeLokaleText.text=prntStr;
				if(tagValue==2)lblFlyke.text=prntStr;
			}
	}
}

- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row {
	// Check whether all rows are unchecked or only one
	if (row == -1){
		for (id key in [selectionStates allKeys])
			[selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	if(tagValue==3)	lblArea.text=@"Alle Kommuner/Områder";
	if(tagValue==4)	lblSize.text=@"Alle Størrelser";
	if(tagValue==1) lblTypeLokaleText.text=@"Alle Typer";
	if(tagValue==2)lblFlyke.text=@"Alle Fylker";
	}
	else{
		NSString *prntStr =@"";
		[selectionStates setObject:[NSNumber numberWithBool:NO] forKey:[entries objectAtIndex:row]];
		if(tagValue==1){
		[myselectedItemstype removeObject:[entries objectAtIndex:row]];		
			for(int i= 0;i<[myselectedItemstype count];i++){
				if(i==0) prntStr =[NSString stringWithFormat:@"%@",[[myselectedItemstype objectAtIndex:i]valueForKey:@"department"]];
				else prntStr =[NSString stringWithFormat:@"%@,%@",prntStr,[[myselectedItemstype objectAtIndex:i]valueForKey:@"department"]];
			}
		}
		if(tagValue==2){
			[myselectedItemsflyker removeObject:[entries objectAtIndex:row]];		
			for(int i= 0;i<[myselectedItemsflyker count];i++){
				if(i==0) prntStr =[NSString stringWithFormat:@"%@",[[myselectedItemsflyker objectAtIndex:i]valueForKey:@"town"]];
				else prntStr =[NSString stringWithFormat:@"%@,%@",prntStr,[[myselectedItemsflyker objectAtIndex:i]valueForKey:@"town"]];
			}
		}
		if(tagValue==1){
			[myselectedItemsarea removeObject:[entries objectAtIndex:row]];		
			for(int i= 0;i<[myselectedItemsarea count];i++){
				if(i==0) prntStr =[NSString stringWithFormat:@"%@",[[myselectedItemsarea objectAtIndex:i]valueForKey:@"area"]];
				else prntStr =[NSString stringWithFormat:@"%@,%@",prntStr,[[myselectedItemsarea objectAtIndex:i]valueForKey:@"area"]];
			}
		}
		if(tagValue==1){
			[myselectedItemssize removeObject:[entries objectAtIndex:row]];		
			for(int i= 0;i<[myselectedItemssize count];i++){
				if(i==0) prntStr =[NSString stringWithFormat:@"%@",[[myselectedItemssize objectAtIndex:i]valueForKey:@"size_range"]];
				else prntStr =[NSString stringWithFormat:@"%@,%@",prntStr,[[myselectedItemssize objectAtIndex:i]valueForKey:@"size_range"]];
			}
		}
		if([prntStr isEqualToString:@""]){				
			if(tagValue==3)	lblArea.text=@"Alle Kommuner/Områder";
			if(tagValue==4)	lblSize.text=@"Alle Størrelser";
			if(tagValue==1) lblTypeLokaleText.text=@"Alle Typer";
			if(tagValue==2)lblFlyke.text=@"Alle Fylker";
		}
		else {
			if(tagValue==3)	lblArea.text=prntStr;
			if(tagValue==4)	lblSize.text=prntStr;
			if(tagValue==1) lblTypeLokaleText.text=prntStr;
			if(tagValue==2)lblFlyke.text=prntStr;
		}
	}	
}

#pragma mark -
#pragma mark custom methods

-(void)setToolBarFrames{	
	pickerView.hidden =TRUE;
	downPickerToolBar.hidden =TRUE;
	lblTypeLokale.hidden =TRUE;
	btnFerdig.hidden =TRUE;
}

-(void)presentPickerView{
	pickerView.hidden =TRUE;
	downPickerToolBar.hidden=FALSE;
	btnFerdig.hidden=FALSE;
	lblTypeLokale.hidden=FALSE;	
	btnOmrade.alpha =0.3;
	btnOmrade.userInteractionEnabled =FALSE;
	selectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in entries)
		[selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	NSString *str_all= @"";
	if(tagValue==3)	str_all=@"Alle Kommuner/Områder";
	if(tagValue==4)	str_all=@"Alle Størrelser";
	if(tagValue==1) str_all=@"Alle Typer";
	if(tagValue==2)str_all=@"Alle Fylker";
	pickerView = [[ALPickerView alloc] initWithFrame:CGRectMake(0.f, 280, 0.f, 0.f):str_all];
	pickerView.delegate = self;	
	[self.view addSubview:pickerView];
	[pickerView release];
	
}

-(void)clickBack{	
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)clickTypeLokale{	
	[self GDATA];
	lblTypeLokale.text=@"Type Lokale";	
	lblTypeLokaleText.text=@"Alle Typer";
}

-(void)clickFylke{
	[self GDATAFylke];
	lblFlyke.text=@"Alle Fylker";
	lblTypeLokale.text=@"Fylke";
	
}

-(void)clickKommuneOmrade{
	[self GDATAArea];
	lblTypeLokale.text=@"Kommuner/Områder";
	lblArea.text=@"Alle Kommuner/Områder";
}

-(void)clickStorrelse{
	[self GDATASize];
	lblTypeLokale.text=@"Størrelser";
	lblSize.text=@"Alle Størrelser";
}

-(void)clickNullStillAlleFilter{	
	lblArea.text=@"Alle Kommuner/Områder";
	lblSize.text=@"Alle Størrelser";
	lblTypeLokaleText.text=@"Alle Typer";
	lblFlyke.text=@"Alle Fylker";
 
	btnOmrade.userInteractionEnabled=FALSE;
	btnOmrade.alpha =0.3;
	lblArea.alpha=0.2;

} 

-(void)clickBruk{
	 lblArea.alpha=0.3;
	[self setToolBarFrames];		
	[viewAlert setFrame:CGRectMake(10, 140, 285, 185)];	
}

-(IBAction)clickFerdig{
    if (![lblFlyke.text isEqualToString:@"Alle Fylker"]) {        
        btnOmrade.userInteractionEnabled=TRUE;
        btnOmrade.alpha =1.0;
        lblOmradeTitle.alpha=1.0;
        lblArea.alpha=1.0;        
    }	
	else {
		btnOmrade.userInteractionEnabled=FALSE;
        btnOmrade.alpha =0.3;
        lblOmradeTitle.alpha=0.3;
        lblArea.alpha=0.3;  
	}

	[self setToolBarFrames];
}

-(void)GDATASaveNo{		
	
	NSString *lokalrIdString=@"";
	NSString *flykeIdString=@"";
	NSString *areaIdString=@"";
	NSString *sizeIdString=@"";
	
	for(int i= 0;i<[myselectedItemstype count];i++){
		if(i==0) lokalrIdString =[NSString stringWithFormat:@"%@",[[myselectedItemstype objectAtIndex:i]valueForKey:@"deptid"]];
		else lokalrIdString =[NSString stringWithFormat:@"%@,%@",lokalrIdString,[[myselectedItemstype objectAtIndex:i]valueForKey:@"deptid"]];
	}
	for(int i= 0;i<[myselectedItemsflyker count];i++){
		if(i==0) flykeIdString =[NSString stringWithFormat:@"%@",[[myselectedItemsflyker objectAtIndex:i]valueForKey:@"townid"]];
		else flykeIdString =[NSString stringWithFormat:@"%@,%@",flykeIdString,[[myselectedItemsflyker objectAtIndex:i]valueForKey:@"townid"]];
	}
	for(int i= 0;i<[myselectedItemsarea count];i++){
		if(i==0) areaIdString =[NSString stringWithFormat:@"%@",[[myselectedItemsarea objectAtIndex:i]valueForKey:@"areaid"]];
		else areaIdString =[NSString stringWithFormat:@"%@,%@",areaIdString,[[myselectedItemsarea objectAtIndex:i]valueForKey:@"areaid"]];
	}
	for(int i= 0;i<[myselectedItemssize count];i++){
		if(i==0) sizeIdString =[NSString stringWithFormat:@"%@",[[myselectedItemssize objectAtIndex:i]valueForKey:@"id"]];
		else sizeIdString =[NSString stringWithFormat:@"%@,%@",sizeIdString,[[myselectedItemssize objectAtIndex:i]valueForKey:@"id"]];
	}
	[AlertHandler showAlertForProcess];
	GdataParser *parserBack = [[GdataParser alloc] init];
	NSString *urlstring =[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=propertylist&deptid=%@&townid=%@&areaid=%@&sizerange=%@&sortby=%d",lokalrIdString,flykeIdString,areaIdString,sizeIdString,appdel.Currentsorted];
	appdel.urlPropertylist =urlstring;
	[parserBack downloadAndParse:[NSURL URLWithString:urlstring]
					 withRootTag:@"post" 
						withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"title",@"title",@"adress",@"adress",@"houseno",@"houseno",@"latitude",@"latitude",@"longitude",@"longitude",@"shortDescription",@"shortDescription",@"mainimage",@"mainimage",@"areaname",@"areaname",@"townname",@"townname",@"fromarea",@"fromarea",@"toarea",@"toarea",@"departmentname",@"departmentname",@"zip_code",@"zip_code",nil]
							 sel:@selector(finishGetDataSaveNo:) 
					  andHandler:self];
}

-(void)finishGetDataSaveNo:(NSDictionary*)dictionary{
	[AlertHandler hideAlert];
	NSMutableArray *t_arr =[dictionary valueForKey:@"array"];
	[appdel.myCurrentData_arr removeAllObjects];
	appdel.myCurrentData_arr  = [t_arr mutableCopy];		
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)GDATAYes{
	
	NSString *lokalrIdString=@"";
	NSString *flykeIdString=@"";
	NSString *areaIdString=@"";
	NSString *sizeIdto=@"";
	NSString *sizeIdfrm=@"";
	for(int i= 0;i<[myselectedItemstype count];i++){
		if(i==0) lokalrIdString =[NSString stringWithFormat:@"%@",[[myselectedItemstype objectAtIndex:i]valueForKey:@"deptid"]];
		else lokalrIdString =[NSString stringWithFormat:@"%@,%@",lokalrIdString,[[myselectedItemstype objectAtIndex:i]valueForKey:@"deptid"]];
	}
	for(int i= 0;i<[myselectedItemsflyker count];i++){
		if(i==0) flykeIdString =[NSString stringWithFormat:@"%@",[[myselectedItemsflyker objectAtIndex:i]valueForKey:@"townid"]];
		else flykeIdString =[NSString stringWithFormat:@"%@,%@",flykeIdString,[[myselectedItemsflyker objectAtIndex:i]valueForKey:@"townid"]];
	}
	for(int i= 0;i<[myselectedItemsarea count];i++){
		if(i==0) areaIdString =[NSString stringWithFormat:@"%@",[[myselectedItemsarea objectAtIndex:i]valueForKey:@"areaid"]];
		else areaIdString =[NSString stringWithFormat:@"%@,%@",areaIdString,[[myselectedItemsarea objectAtIndex:i]valueForKey:@"areaid"]];
	}
	for(int i= 0;i<[myselectedItemssize count];i++){
		NSArray *myWords = [[[myselectedItemssize objectAtIndex:i]valueForKey:@"size_range"] componentsSeparatedByString:@"-"];
		NSString *strf =[myWords objectAtIndex:0];
		
		NSLog(@"%@",strf);
		if([strf isEqualToString:@"> 850"])
			strf =[strf substringFromIndex:2];
		NSLog(@"%@",strf);
			
		if([sizeIdfrm isEqualToString:@""])
		sizeIdfrm =[NSString stringWithFormat:@"%@",strf];
		else {
			sizeIdfrm =[NSString stringWithFormat:@"%@,%@",sizeIdfrm,strf];
		}

		
		if([sizeIdto isEqualToString:@""] && [myWords count]>1){
			
			sizeIdto =[NSString stringWithFormat:@"%@",[myWords objectAtIndex:1]];
		}
		else{	
			if([myWords count]>1)
			sizeIdto =[NSString stringWithFormat:@"%@,%@",sizeIdto,[myWords objectAtIndex:1]];
		}
	}
	
	
	[AlertHandler showAlertForProcess];
	GdataParser *parserSave = [[GdataParser alloc] init];	
	NSString *urlstr123 =[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=savesearch&town_id=%@&area_id=%@&department_id=%@&from_area=%@&to_area=%@&udid=%@",flykeIdString,areaIdString,lokalrIdString,sizeIdfrm,sizeIdto,appdel.udID];
	NSURL *url = [NSURL URLWithString:[urlstr123 stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
	[parserSave downloadAndParse:url
				 withRootTag:@"savesearch" 
					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"savesearch",@"savesearch",nil]
						 sel:@selector(finishGetDataYes:) 
				  andHandler:self];
}

-(void)finishGetDataYes:(NSDictionary*)dictionary{	
	[AlertHandler hideAlert];
	appdel.appdel_ArrayFilterSave =[dictionary valueForKey:@"array"];
	appdel.appdel_dicFilterSave=[dictionary valueForKey:@"array"];
	appdel.currentArray=appdel.appdel_ArrayFilterSave;   
	[self GDATASaveNo];
}

-(void)clickYes{
	[viewAlert setFrame:CGRectMake(19, 470, 285, 185)];	    
	[self GDATAYes];	
}

-(void)clickNo{	
	[viewAlert setFrame:CGRectMake(19, 470, 285, 185)];	
	[self GDATASaveNo];	
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
	[entries release];
	[myselectedItemstype release];
	[myselectedItemsflyker release];
	[myselectedItemsarea release];
	[myselectedItemssize release];
	[selectionStates release];	
}

@end
