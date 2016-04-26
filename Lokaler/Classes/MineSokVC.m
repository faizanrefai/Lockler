//
//  MineSokVC1.m
//  EstateLokaler
//
//  Created by apple  on 9/29/11.
//  Copyright 2011 hjbvb. All rights reserved.
//

#import "MineSokVC.h"
#import "EstateLokalerAppDelegate.h"
#import "GdataParser.h"
#import "MineSokCell.h"
#import "MineFunnVC.h"
#import "SokeFilterVC.h"
#import "MineFunnCell.h"
#import "PropertiesDetailVC.h"
#import "PropertyListMode.h"
#import "UITableViewCell+NIB.h"
#import "AlertHandler.h"


@implementation MineSokVC

- (void)viewDidLoad {
	[super viewDidLoad];
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication]delegate];
	type_arr = [[NSMutableArray alloc]init];
	town_arr = [[NSMutableArray alloc]init];
	area_arr = [[NSMutableArray alloc]init];
	size_arr = [[NSMutableArray alloc]init];
	procnt_arr = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {	
	if(isPushed)return;
	[myTable reloadData];
	 myTable.hidden =TRUE;
	[AlertHandler showAlertForProcess];
	[procnt_arr removeAllObjects];
	[self GDATACntProp:[[appdel.mineSok_arr objectAtIndex:0]valueForKey:@"id"]];
}

-(void)GDATACntProp:(NSString*)str_id {	
	GdataParser *parser20 = [[GdataParser alloc] init];	
	[parser20 downloadAndParse:[NSURL  URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=getindsearchcount&udid=%@&searchid=%@",appdel.udID,str_id]]
				   withRootTag:@"post" 
					  withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"cnt",@"cnt",nil]
						   sel:@selector(finishGetDataCntProp:) 
					andHandler:self];
	
}

-(void)finishGetDataCntProp:(NSDictionary*)dictionary{
	[procnt_arr addObject:[[[dictionary valueForKey:@"array"] objectAtIndex:0] valueForKey:@"cnt"]];
	if([procnt_arr count]!=[appdel.mineSok_arr count]){
		[self GDATACntProp:[[appdel.mineSok_arr objectAtIndex:[procnt_arr count]]valueForKey:@"id"]];
	
	}
	else{
		[self GDATATown];
	}
}


-(void)GDATATown{		
	GdataParser *parser1 = [[GdataParser alloc] init];
	[parser1 downloadAndParse:[NSURL  URLWithString:@"http://www.estatelokaler.no/appservice.php?token=flyke"]
	 
				 withRootTag:@"post" 
					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"townid",@"townid",@"town",@"town",nil]
						 sel:@selector(finishGetDataTown:) 
				  andHandler:self];
}

-(void)finishGetDataTown:(NSDictionary*)dictionary{
	[town_arr removeAllObjects];
	NSMutableArray *t_arr =[dictionary valueForKey:@"array"];
	town_arr =[t_arr mutableCopy];
	[self GDATAArea];
	
}
-(void)GDATAArea{	
	
	GdataParser *parser2 = [[GdataParser alloc] init];
	[parser2 downloadAndParse:[NSURL  URLWithString:@"http://www.estatelokaler.no/appservice.php?token=kommune"]
	 
				 withRootTag:@"post" 
					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"areaid",@"areaid",@"area",@"area",nil]
						 sel:@selector(finishGetDataArea:) 
				  andHandler:self];
}

-(void)finishGetDataArea:(NSDictionary*)dictionary{
	[area_arr removeAllObjects];
	NSMutableArray *t_arr =[dictionary valueForKey:@"array"];
	area_arr =[t_arr mutableCopy];	
	[self GDATADept];
}
     
-(void)GDATADept{		
	GdataParser *parser3 = [[GdataParser alloc] init];
	[parser3 downloadAndParse:[NSURL  URLWithString:@"http://www.estatelokaler.no/appservice.php?token=typelokale"]
	 
				  withRootTag:@"post" 
					 withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"deptid",@"deptid",@"department",@"department",nil]
						  sel:@selector(finishGetDataDept:) 
				   andHandler:self];
}

-(void)finishGetDataDept:(NSDictionary*)dictionary{
	[AlertHandler hideAlert];
	[type_arr removeAllObjects];
	NSMutableArray *t_arr =[dictionary valueForKey:@"array"];
	type_arr =[t_arr mutableCopy];
	NSLog(@" final cnt %@",procnt_arr);
	[myTable reloadData];
	myTable.hidden =FALSE;
		
}
-(void)GDATADelete:(NSString *)idVal{	
	GdataParser *parser23 = [[GdataParser alloc] init];
	[parser23 downloadAndParse:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=deletesearch&udid=%@&searchids=%@",appdel.udID,idVal]]	 
				  withRootTag:@"deletesearch" withTags:[NSDictionary dictionaryWithObjectsAndKeys:nil]					  
						  sel:@selector(finishGetDataDelete:)andHandler:self];	
	
}

-(void)finishGetDataDelete:(NSDictionary*)dictionary{	
	[myTable reloadData];

}

-(void)GDATASokProperty:(NSString*)idStr{
	[AlertHandler showAlertForProcess];
	GdataParser *parserSok = [[GdataParser alloc] init];
	[parserSok downloadAndParse:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=getindsearchlist&udid=%@&searchid=%@",appdel.udID,idStr]]
					withRootTag:@"post" withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"title",@"title",@"adress",@"adress",@"houseno",@"houseno",@"latitude",@"latitude",@"longitude",@"longitude",@"shortDescription",@"shortDescription",@"mainimage",@"mainimage",@"areaname",@"areaname",@"townname",@"townname",@"fromarea",@"fromarea",@"toarea",@"toarea",@"departmentname",@"departmentname",@"date_insert",@"date_insert",nil]
							sel:@selector(finishGetDataSokDetail:) andHandler:self];
}

-(void)finishGetDataSokDetail:(NSDictionary*)dictionary{
	[AlertHandler hideAlert];
	NSMutableArray *t_arr =[dictionary valueForKey:@"array"];
	[appdel.myCurrentData_arr removeAllObjects];
	appdel.myCurrentData_arr =[t_arr mutableCopy];
	if([appdel.myCurrentData_arr count]!=0){
		if(detailViewController){
			detailViewController =nil;
			[detailViewController release];
		}	
		isPushed =TRUE;
		detailViewController = [[MineFunnVC alloc] initWithNibName:@"MineFunnVC" bundle:nil];
		[self.navigationController pushViewController:detailViewController animated:YES];
	}

}

-(IBAction)sokDelete{	
	if(self.editing){ 
		[super setEditing:NO animated:NO]; 
		[myTable setEditing:NO animated:NO];
		[myTable reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Delete"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
		self.navigationItem.rightBarButtonItem.enabled=TRUE;
	}
	else{
		[super setEditing:YES animated:YES]; 		
		[myTable setEditing:YES animated:YES];
		[myTable reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
		self.navigationItem.rightBarButtonItem.enabled=FALSE;
	}	
	
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {	
    if (editingStyle == UITableViewCellEditingStyleDelete) {			
				
		[self GDATADelete:[[appdel.mineSok_arr objectAtIndex:indexPath.row] valueForKey:@"id"]];
		[appdel.mineSok_arr removeObjectAtIndex:indexPath.row];
		[procnt_arr removeObjectAtIndex:indexPath.row];
	}
}	


#pragma mark -
#pragma mark Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if([[procnt_arr objectAtIndex:indexPath.row] isEqualToString:@""])
		return;
	appdel.frmSok =TRUE;
	[self GDATASokProperty:[[appdel.mineSok_arr objectAtIndex:indexPath.row]valueForKey:@"id"]];	
	
}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
	return [appdel.mineSok_arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MineSokCell *cell = [MineSokCell dequeOrCreateInTable:myTable];
	cell.selectionStyle =UITableViewCellSelectionStyleNone;
	if(tableView.hidden)return cell;
	NSMutableDictionary *t_dict =[appdel.mineSok_arr objectAtIndex:indexPath.row];
	NSString* strTempTown=[t_dict valueForKey:@"town_id"];
	NSString*strTempArea=[t_dict valueForKey:@"area_id"];
	NSString*strTempDept=[t_dict valueForKey:@"department_id"];

	NSArray *arrSplitTown=[[strTempTown componentsSeparatedByString:@","]retain];
	NSArray *arrSplitArea=[[strTempArea componentsSeparatedByString:@","]retain];
	NSArray *arrSplitDept=[[strTempDept componentsSeparatedByString:@","]retain];
	
	NSString *Mytownstr= [self getTownName:[arrSplitTown retain]];
	[t_dict setValue:Mytownstr forKey:@"town"];
	
	NSString *Myareastr= [self getAreaName:[arrSplitArea retain]];
	[t_dict setValue:Myareastr forKey:@"area"];
	
	NSString *Mydeptstr= [self getDeptName:[arrSplitDept retain]];
	[t_dict setValue:Mydeptstr forKey:@"dept"];
	
	[t_dict setValue:[procnt_arr objectAtIndex:indexPath.row] forKey:@"cnt"];
	[cell setData: t_dict];
	
	cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minesokcellbg.png"]];
	return cell;
}

#pragma mark -
#pragma mark custom methods
-(IBAction)clickBack{
	
	[self.navigationController popViewControllerAnimated:YES];
}
-(NSString*)getTownName:(NSArray*)valArr{	
	NSString *returnStr =@"";
	int cnt =0;	
	for(int j=0;j<[valArr count];j++){
	int indcnt =0;
	NSString *val_str = [valArr objectAtIndex:j];
		for (NSString *s in [town_arr valueForKey:@"townid"]) {			
			if([s isEqualToString:val_str]){				
				if(cnt ==0)	returnStr=[NSString stringWithFormat:@"%@",[[town_arr objectAtIndex:indcnt]valueForKey:@"town"]];
				else returnStr=[NSString stringWithFormat:@"%@,%@",returnStr,[[town_arr objectAtIndex:indcnt]valueForKey:@"town"]];
				cnt++;
			}
			indcnt++;
		}
	}	
	if([returnStr isEqualToString:@""])returnStr = @"Alle Fylker";
	return returnStr;
}

	
-(NSString*)getAreaName:(NSArray*)valArr{
	NSString *returnStr =@"";
	int cnt =0;	
	for(int j=0;j<[valArr count];j++){
		int indcnt =0;
		NSString *val_str = [valArr objectAtIndex:j];
		for (NSString *s in [area_arr valueForKey:@"areaid"]) {			
			if([s isEqualToString:val_str]){				
				if(cnt ==0)	returnStr=[NSString stringWithFormat:@"%@",[[area_arr objectAtIndex:indcnt]valueForKey:@"area"]];
				else returnStr=[NSString stringWithFormat:@"%@,%@",returnStr,[[area_arr objectAtIndex:indcnt]valueForKey:@"area"]];
				cnt++;
				
			}
			indcnt++;
		}
	}	
	if([returnStr isEqualToString:@""])returnStr = @"Alle Kommuner/Områder";
	return returnStr;
	
	
}

-(NSString*)getDeptName:(NSArray*)valArr{
	NSString *returnStr =@"";
	int cnt =0;
	for(int j=0;j<[valArr count];j++){
		int indcnt = 0;
		NSString *val_str = [valArr objectAtIndex:j];
		for (NSString *s in [type_arr valueForKey:@"deptid"]) {	
			
			if([s isEqualToString:val_str]){				
				if(cnt ==0)	returnStr=[NSString stringWithFormat:@"%@",[[type_arr objectAtIndex:indcnt]valueForKey:@"department"]];
				else returnStr=[NSString stringWithFormat:@"%@,%@",returnStr,[[type_arr objectAtIndex:indcnt]valueForKey:@"department"]];
				cnt++;
				
			}
			indcnt++;
		}
	}	
		
	if([returnStr isEqualToString:@""])returnStr = @"Alle Typer";
	return returnStr;

}

#pragma mark -
#pragma mark Table view delegate

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewDidDisappear:(BOOL)animated{
		
}

- (void)dealloc {
	[super dealloc];
	[type_arr release]; 
	[town_arr release];  
	[area_arr release]; 
	[size_arr release]; 
	[procnt_arr release];
}
@end
