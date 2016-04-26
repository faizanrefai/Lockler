//
//  PropertiesDetailVC.m
//  EstateLokaler
//
//  Created by apple on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PropertiesDetailVC.h"
#import "GTHeaderView.h"
#import "HeadlinesCellController.h"
#import "GdataParser.h"
#import "EstateLokalerAppDelegate.h"
#import "CurrentLocationMap.h"
//#import "SHKItem.h"
//#import "SHKFacebook.h"
//#import "SHKMail.h"
#import "ArticleVC.h"
#import	"EGOImageView.h"
#import "ZoomViewController.h"
#import "UITableViewCell+NIB.h"
#import "detailCell.h"
#import "Facility.h"
#import "ArticleVCCell.h"
#import "ArticleDetail.h"
#import "AlertHandler.h"

GTHeaderView *hView;

@implementation PropertiesDetailVC
@synthesize lblDepartmentName,lblAreaName,lblAreaIs,lblDistance,titleLable,
detail,faci,head,art,btnMail,btnCall,showpropertuId;

const CGFloat kScrollObjHeight	= 199.0;
const CGFloat kScrollObjWidth	= 304.0;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication] delegate];
	recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];		
	arrHeader = [[NSArray alloc]initWithObjects:@"Beskrivelse av lokalene",@"Fasiliteter",@"Kontakt utleier",nil];

	[self generateHeaderViews];	
	array=[[NSMutableArray alloc]init];
	
	strURL=[[NSMutableString alloc]init];
	arrSecondaryImg=[[NSMutableArray alloc]init];
	
	strDistance=[[NSString alloc]init];
	arrSplitFacility=[[NSMutableArray alloc]init];
	fbAgent = [[FacebookAgent alloc] initWithApiKey:@"405997071392" 
										  ApiSecret:@"b78179e4f1a5e30f5f32412937bc8b63" 
										   ApiProxy:nil];
	fbAgent.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
	
	sendMailView.hidden =TRUE;
	isAgent =TRUE;
	if(isPushed){
		isPushed =FALSE;
		appdel.addcnt = 0;
		return;
	}
	if(isMail)
		return;		
	flagForNoData=0;	
	flagSecDetail=0;
    
	viewAlert.hidden =TRUE;
	viewSokAlert.hidden=TRUE;//508
    MainScroll.contentSize=CGSizeMake(320, 468);
    [self GDATA];
}
-(void)GDATA{	
	[AlertHandler showAlertForProcess];
	GdataParser *parser = [[GdataParser alloc] init];
	
	[parser downloadAndParse:[NSURL  URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=propertydetails&prId=%@",showpropertuId]]
	 
				 withRootTag:@"post" 
					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"adress",@"adress",
							  @"houseno",@"houseno",@"area",@"area",@"town",@"town",@"deartmentname",@"deartmentname",
							  @"from_area",@"from_area",@"to_area",@"to_area",@"mainimage",@"mainimage",
							  @"title",@"title",@"shortDescription",@"shortDescription",
							  @"descriptionurl",@"descriptionurl",@"desclen",@"desclen",@"latitude",@"latitude",
							  @"longitude",@"longitude",@"companyname",@"companyname",@"companylogo",@"companylogo",
					 		  @"priAgentname",@"priAgentname",@"priphone",@"priphone",@"pricell",@"pricell",@"prifax",@"prifax",
							  @"priAgentEmail",@"priAgentEmail",@"secAgentname",@"secAgentname",@"secphone",@"secphone",@"seccell",@"seccell",
							  @"secfax",@"secfax",@"secAgentEmail",@"secAgentEmail",@"weblink",@"weblink",@"facilities",
							  @"facilities",@"secondary_images",@"secondary_images",@"zip_code",@"zip_code",nil]
						 sel:@selector(finishGetData:) 
				  andHandler:self];
}

-(void)finishGetData:(NSDictionary*)dictionary{
	
	noAgent=1;
	NSMutableArray *t_arr=[dictionary valueForKey:@"array"];
	array =[t_arr mutableCopy];	
	if ([array count]==0) {		
		flagForNoData=1;
		[AlertHandler hideAlert];
		viewSokAlert.hidden=FALSE;
			return;
	}	
	
	[arrSplitFacility removeAllObjects];
	NSString *str=[[array objectAtIndex:0] valueForKey:@"facilities"];		
	arrSplitFacility=[[str componentsSeparatedByString:@"^"]retain];
	
	NSString *strTmp=[NSString stringWithFormat:@"%@",[[array objectAtIndex:0]  valueForKey:@"secAgentname"]];
	if (![strTmp isEqualToString:@""]) {
		noAgent=2;
	}
	appdel.strTitleMap=[[array objectAtIndex:0] valueForKey:@"title"];	
	
	NSString *strArea1=[[array objectAtIndex:0] valueForKey:@"from_area"];
	NSString *strArea2=[[array objectAtIndex:0] valueForKey:@"to_area"];	
	NSString *strAreaIs=[NSString stringWithFormat:@"%@-%@ kvm", strArea1,strArea2];	
	NSString *strSecondaryImg=[NSString stringWithFormat:@"%@",[[array objectAtIndex:0]valueForKey:@"secondary_images"]];
	NSString *strAdd=[[array objectAtIndex:0] valueForKey:@"adress"];	
	NSString *strNo=[[array objectAtIndex:0] valueForKey:@"houseno"];
	
	lblDepartmentName.text=[[array objectAtIndex:0] valueForKey:@"deartmentname"];
	lblAreaName.text=[[array objectAtIndex:0] valueForKey:@"area"];
	lblAreaIs.text=strAreaIs;
	lblDistance.text=appdel.strDistance;	
	strHouseAddress =@"";	
	strHouseAddress=[NSString stringWithFormat:@"%@, %@",strAdd,strNo];	
	titleLable.text=strHouseAddress;	
	
	lblAlertTitle.text=[NSString stringWithFormat:@"%@, %@ lagret", strAdd,strNo];	
	//appdel.strAppLat=strLatitude;
//	appdel.strAppLong=strLongitude;	
	desclen =0;
	NSLog(@"%@",[[array objectAtIndex:0] valueForKey:@"descriptionurl"]);
	[self LoadURL:[[array objectAtIndex:0] valueForKey:@"descriptionurl"]];	
	//desclen =[[[array objectAtIndex:0] valueForKey:@"desclen"]intValue];
	
	[arrSecondaryImg removeAllObjects];
	arrSecondaryImg=[[strSecondaryImg componentsSeparatedByString:@"^"]retain];
	lblImgCnt.text=[NSString stringWithFormat:@"1/%d bilder",[arrSecondaryImg count]];
	CLLocation *locA = [[CLLocation alloc]initWithLatitude:[[[array objectAtIndex:0] valueForKey:@"latitude"] doubleValue] longitude:[[[array objectAtIndex:0] valueForKey:@"longitude"]doubleValue]];
	CLLocation *locB = [[CLLocation alloc] initWithLatitude:[appdel.strAppLat doubleValue] longitude:[appdel.strAppLong doubleValue]];
	CLLocationDistance distance = [locA distanceFromLocation:locB];	
	[locA release];	
	[locB release];
	if(distance>1000){
		lblDistance.text =[NSString stringWithFormat:@"%.2f KM",distance/1000.0];
	}
	else{
		lblDistance.text =[NSString stringWithFormat:@"%.2f meters",distance];
	}	

	
	
}


-(void)LoadURL:(NSString*)str{
	webView =[[UIWebView alloc] init];
	webView.delegate =self;
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
	CGFloat h = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
	desclen =(h +(h/2))-20;
	[AlertHandler hideAlert];
	[self scroll];
	[self GDATAArt];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[AlertHandler hideAlert];
	[self scroll];
	[self GDATAArt];
}


-(void)GDATAArt{	
	GdataParser *parser2 = [[GdataParser alloc] init];
	[parser2 downloadAndParse:[NSURL  URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=areaarticles&lat=%@&lon=%@",[[array objectAtIndex:0] valueForKey:@"latitude"],[[array objectAtIndex:0] valueForKey:@"longitude"]]]
				  withRootTag:@"post" withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"catid",@"catid",@"id",@"id",@"title",@"title",@"introText",@"introText",@"categoryname",@"categoryname",@"created",@"created",@"Author",@"Author",nil]
						  sel:@selector(finishGetDataArt:)  andHandler:self];
}
-(void)finishGetDataArt:(NSDictionary*)dictionary{	
	arrArtList =[dictionary valueForKey:@"array"];
}

-(void)generateHeaderViews{
	arrAddHeader = [[NSMutableArray alloc]init];
	for(int i=0;i<[arrHeader count];i++){
		hView = [GTHeaderView headerViewWithTitle:[arrHeader objectAtIndex:i] section:i Expanded:@"NO"];
		[hView.button addTarget:self action:@selector(toggleSectionForSection:) forControlEvents:UIControlEventTouchUpInside];
		[arrAddHeader addObject:[hView retain]];
	}
}
- (void)layoutScrollImages{	
	UIImageView *view = nil;
	NSArray *subviews = [scrollView1 subviews];	
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews){
		if ([view isKindOfClass:[UIImageView class]] && view.tag >0){ 
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			curXLoc += (kScrollObjWidth);
		}
	}	
	// set the content size so it can be scrollable
	[scrollView1 setContentSize:CGSizeMake(([arrSecondaryImg count] * kScrollObjWidth), [scrollView1 bounds].size.height)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if(scrollView !=MainScroll){
		imageCnt =scrollView1.contentOffset.x/304;		
		NSString *str=[NSString stringWithFormat:@"%d/%d bilder",imageCnt+1,[arrSecondaryImg count]];
		lblImgCnt.text=str;	
	}
}
-(void)scroll{
	[scrollView1 setCanCancelContentTouches:NO];
	scrollView1.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView1.clipsToBounds = YES;		
	scrollView1.scrollEnabled = YES;	
	scrollView1.pagingEnabled = YES;	
	NSUInteger i;
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 304.0f, 199.0f)];	
	for (i = 1; i <=[arrSecondaryImg count]; i++){		
			NSString *imageName = [NSString stringWithFormat:@"%@",[arrSecondaryImg objectAtIndex:(i-1)]];
			imageViewL = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""]];
			imageViewL.imageURL =[NSURL URLWithString:[imageName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];			
			imageViewL.frame = CGRectMake(0.0f, 0.0f, 304.0f, 199.0f);		
			CGRect rect = imageViewL.frame;					
			rect.size.height = kScrollObjHeight;
			rect.size.width = kScrollObjWidth;
			imageViewL.frame = rect;
			imageViewL.tag = i;	// tag our images for later use when we place them in serial fashion
			[view addSubview:imageViewL];			
			[scrollView1 addSubview:imageViewL];
	}	
	UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
	[view addGestureRecognizer:pinchGesture];
	[pinchGesture release];
	imageCnt=0;
    NSLog(@"setcount to %d",imageCnt);
	[self layoutScrollImages];		
}

-(void)handlePinch:(UIPinchGestureRecognizer*)sender {	
	if(appdel.tagMethere) return ;
	if(appdel.addcnt==0){	
		//UIImageView *view = nil;
		//NSArray *subviews = [scrollView1 subviews];
		//view =[subviews objectAtIndex:imageCnt];
		appdel.addcnt=1;
		isPushed =TRUE;
		ZoomViewController *obj =[[ZoomViewController alloc]initWithNibName:@"ZoomViewController" bundle:nil];
		//obj.myImage =view.image;
		obj.orirntation = UIInterfaceOrientationLandscapeLeft;
		obj.img_arr = arrSecondaryImg;
		obj.pageNo = imageCnt;
		[self.navigationController pushViewController:obj animated:YES];
		//[self.view addSubview:obj.view];
		//[obj release];
	}	
}

-(void)GDATAMailsend{	
	NSString *post =[NSString stringWithFormat:@"token=tipafriend&receiver=%@&sender=%@&comment=%@&propid=%@",receiverTxt.text,senderTxt.text,MsgTxt.text,showpropertuId];	
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://www.estatelokaler.no/appservice.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
	
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
}
   	
-(void)GDATASave{	
	GdataParser *parser1 = [[GdataParser alloc] init];
	[parser1 downloadAndParse:[NSURL  URLWithString:[NSString stringWithFormat:@"http://www.estatelokaler.no/appservice.php?token=savemyad&udid=%@&propid=%@",appdel.udID,showpropertuId]]
				 withRootTag:@"savemyad" withTags:[NSDictionary dictionaryWithObjectsAndKeys:nil]
				sel:@selector(finishGetDataSave:) andHandler:self];
}
-(void)finishGetDataSave:(NSDictionary*)dictionary{	}

#pragma mark -
#pragma mark Toggles
- (NSArray*)indexPathsInSection:(NSInteger)section{
	NSMutableArray *paths = [NSMutableArray array];
	NSInteger row;	
	for ( row = 0; row < [self numberOfRowsInSection:section]; row++ ) {
		[paths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
	}
	return [NSArray arrayWithArray:paths];
}
- (void)toggle:(NSString*)isExpanded:(NSInteger)section 
{
	int height = 0;
	if(section == 0)height =desclen;
	if(section ==1)height =30*[arrSplitFacility count];
	if(section ==2)height = 122;
	if(section ==3)height =93*[arrArtList count];
	GTHeaderView *tmp;
	tmp=[arrAddHeader objectAtIndex:section];
	if([tmp.Rowstatus isEqualToString:@"NO"])
		tmp.Rowstatus=@"YES";
	else
		tmp.Rowstatus=@"NO";
	NSArray *paths = [self indexPathsInSection:section];
	BOOL isExpand=[tmp.Rowstatus isEqualToString:@"YES"];
	if (!isExpand){
		tblPropertyInfo.scrollEnabled =FALSE;		
		[MainScroll setContentSize:CGSizeMake(320,MainScroll.contentSize.height-height)];
		CGRect frm =tblPropertyInfo.frame;
		frm.size.height = frm.size.height-height;
		tblPropertyInfo.frame =frm;
		[tblPropertyInfo deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
	}
	else{		
		tblPropertyInfo.scrollEnabled = FALSE;			
		CGRect frm =tblPropertyInfo.frame;
		frm.size.height = frm.size.height+height;
		tblPropertyInfo.frame =frm;
		[MainScroll setContentSize:CGSizeMake(320,MainScroll.contentSize.height +height)];
		[tblPropertyInfo insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
	if (section == 0) {
		return  1;
	}else if (section == 1) {
		return [arrSplitFacility count];
	}else if (section == 2) {
		return 1;
	}
	else  {
		return  [arrArtList count];
	}
	
    
}
-(void)toggleSectionForSection:(id)sender
{
	GTHeaderView *tmp=[arrAddHeader objectAtIndex:[sender tag]];
	[self toggle:tmp.Rowstatus:[sender tag]];
}
#pragma mark -
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [arrAddHeader count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{	
	//Put the amount of Websites in the Account here
	int countOfSitesInAccount;
	//countOfSitesInAccount =[arrHeader count];
    if (section == 0) {
		countOfSitesInAccount = 1;
	}else if (section == 1) {
		countOfSitesInAccount = [arrSplitFacility count];
	}else if (section == 2) {
		countOfSitesInAccount = 1;
	}
	else if (section == 3) {
		countOfSitesInAccount = [arrArtList count];
	}
	
	GTHeaderView *tmp=[arrAddHeader objectAtIndex:section];
	return [[tmp Rowstatus]isEqualToString:@"YES"]? countOfSitesInAccount : 0;
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    if(indexPath.section ==0){
		static NSString *CellIdentifier = @"detailCell";;
		detailCell *cell = (detailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {            
				NSArray *nib = nil;        
				nib = [[NSBundle mainBundle] loadNibNamed:@"detailCell" owner:self options:nil];
				cell = [nib objectAtIndex:0]; 
			cell.selectionStyle =UITableViewCellSelectionStyleNone;
		}
		cell.backgroundColor =[UIColor clearColor];
		cell.backgroundView = nil;
		cell.webView.frame =CGRectMake(0, 0, 320, desclen);
		cell.webView.userInteractionEnabled = NO;
		[cell LoadURL:[[array objectAtIndex:0] valueForKey:@"descriptionurl"]] ;
		return cell;
	}
	if(indexPath.section ==1){
		static NSString *CellIdentifier = @"Facility";;
		Facility *cell = (Facility *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			NSArray *nib = nil;        
			nib = [[NSBundle mainBundle] loadNibNamed:@"Facility" owner:self options:nil];
			cell = [nib objectAtIndex:0]; 
			cell.selectionStyle =UITableViewCellSelectionStyleNone;
		
		}
		
		if([arrSplitFacility count]!=0){
			cell.lblFaci.text =[arrSplitFacility objectAtIndex:indexPath.row];
		}
						
		return cell;
	}

	if(indexPath.section == 2){
		
		static NSString *CellIdentifier = @"head";;
		HeadlinesCellController *cell = (HeadlinesCellController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			NSArray *nib = nil;        
			nib = [[NSBundle mainBundle] loadNibNamed:@"HeadlinesCellController" owner:self options:nil];
			cell = [nib objectAtIndex:0]; 	
			cell.selectionStyle =UITableViewCellSelectionStyleNone;
		}
		cell.lblCompName.text =[[array objectAtIndex:0] valueForKey:@"companyname"];
		cell.PriAgent.text =[[array objectAtIndex:0] valueForKey:@"priAgentname"];
		//cell.secAgent.text =[[array objectAtIndex:0] valueForKey:@"secAgentname"];
		NSString *caltitle = [NSString stringWithFormat:@"Ring %@",[[array objectAtIndex:0] valueForKey:@"priphone"]];
		//cell.myLogoImg.imageURL =[NSURL URLWithString:[[array objectAtIndex:0] valueForKey:@"companylogo"]];
		[cell.btnCall setTitle:caltitle forState:UIControlStateNormal];
		[cell.btnCall addTarget:self action:@selector(clickOnCall:) forControlEvents:UIControlEventTouchUpInside];
		[cell.btnEmail addTarget:self action:@selector(clickOnMail:) forControlEvents:UIControlEventTouchUpInside];
		return cell;
	}
	else {
		static NSString *CellIdentifier = @"art";		
		ArticleVCCell *cell= (ArticleVCCell *)[tblPropertyInfo dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {        
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ArticleVCCell" owner:self options:nil];
			cell = (ArticleVCCell *)[nib objectAtIndex:0];
			[cell retain];
			tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
			cell.selectionStyle =UITableViewCellSelectionStyleNone;
		}
		
		if([arrArtList count]!=0)
		{
			NSMutableDictionary *dict =[arrArtList objectAtIndex:indexPath.row];
			[cell setData: dict];
			cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
		//	cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minesokcellbg.png"]];
		}   
		return cell;
	}
    
    
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
	return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
	return [arrAddHeader objectAtIndex:section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (indexPath.section == 0) {
		return desclen;
	}
	if (indexPath.section == 1) {
		return 30;
	}
	if (indexPath.section == 2) {		
		return 122;

	}
	else {
		return 93;
	}
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==3){
		NSMutableDictionary *dict =[arrArtList objectAtIndex:indexPath.row];
		appdel.strArtID=[dict valueForKey:@"id"]; 
		
			if (detailViewController) {
				detailViewController =nil;
				[detailViewController release];			
			}
		detailViewController = [[ArticleDetail alloc] initWithNibName:@"ArticleDetail" bundle:nil];
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
}

#pragma mark call
-(IBAction)clickOnCall:(id)sender{
	
	NSString *str = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[sender currentTitle], NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
	NSString *strMain = [[NSString alloc] initWithFormat:@"tel://%@",str];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:strMain]];	
}



#pragma mark mail
-(IBAction)clickOnMail:(id)sender{
	isMail =TRUE;
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
	NSLog(@"%@",strMailID);	
	mailController.mailComposeDelegate = self;
	if ([MFMailComposeViewController canSendMail]) {  
					
			if(!isAgent){			
				[mailController setSubject:[NSString stringWithFormat:@"Tips fra Estate Lokaler:%@",[array valueForKey:@"title"]]];
				[mailController setMessageBody:[NSString stringWithFormat: @"har tipset deg om denne annonsen!\n http://www.estatelokaler.no/component/jea/%@.html\n\nMed vennlig hilsen,\nEstate Media AS\ninfo@estatemedia.no",appdel.appdelStrID] isHTML:NO];
			}
			else {
				NSArray *arr = [[NSArray alloc] initWithObjects:[[array objectAtIndex:0] valueForKey:@"priAgentEmail"],nil];
				[mailController setToRecipients:arr];
			}

		
		[self presentModalViewController:mailController animated:YES];		
	}	
    [mailController release];
}

- (void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self becomeFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
	isMail =TRUE;
	isAgent=TRUE;
}



#pragma mark -
#pragma mark custom methods
-(IBAction)onTegMethere:(id)sender{
   if(tagmeObj!=nil){
		 tagmeObj =nil;
			[tagmeObj release];
	  }
	tagmeObj =[[MainViewController alloc]initWithNibName:@"MainView" bundle:nil ];
	tagmeObj.strLat=[[array objectAtIndex:0] valueForKey:@"latitude"];
	tagmeObj.strLong=[[array objectAtIndex:0] valueForKey:@"longitude"];
	//isPushed =TRUE;
	tagmeObj.PrpId =[showpropertuId intValue];
	appdel.tagMethere=TRUE;
	[self.view addSubview:tagmeObj.view];
	//[self.navigationController pushViewController:tagmeObj animated:YES];    
}

-(IBAction)ShowMap{	
	if(objMap!=nil){
		objMap =nil;
		[objMap release];
	}
	isPushed =TRUE;
	objMap=[[CurrentLocationMap alloc]initWithNibName:@"CurrentLocationMap" bundle:nil];
	objMap.strLat=[[array objectAtIndex:0] valueForKey:@"latitude"];
	objMap.strLong=[[array objectAtIndex:0] valueForKey:@"longitude"];
	objMap.strTitle=[[array objectAtIndex:0] valueForKey:@"title"];
	objMap.strAddress=[[array objectAtIndex:0] valueForKey:@"adress"];
	[self.navigationController pushViewController:objMap animated:YES];
		
}

-(IBAction)onMailWS:(id)sender{
	sendMailView.hidden =TRUE;
	[self GDATAMailsend];
	[MsgTxt resignFirstResponder];
	[receiverTxt resignFirstResponder];
	[senderTxt resignFirstResponder];

}
-(IBAction)oncancelWS:(id)sender{
	[MsgTxt resignFirstResponder];
	[receiverTxt resignFirstResponder];
	[senderTxt resignFirstResponder];	
	sendMailView.hidden =TRUE;
}
-(IBAction)clickShare{		
	 [self Share];
}

-(void)Share{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Mail", nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	appdel.fbTitle = [NSString stringWithFormat:@"%@",[[[array valueForKey:@"title"]objectAtIndex:0] retain]];
	NSString *strUrl = [[NSString stringWithFormat:@"http://estatelokaler.no/component/jea/%@.html",showpropertuId]retain];
	
	NSString *str_lbl =[NSString stringWithFormat:@"%@ %@, %@ %@, %@-%@ %@",[[array objectAtIndex:0]valueForKey:@"adress"],[[array objectAtIndex:0]valueForKey:@"houseno"],[[array objectAtIndex:0]valueForKey:@"zip_code"],[[array objectAtIndex:0]valueForKey:@"town"],[[array objectAtIndex:0]valueForKey:@"from_area"],[[array objectAtIndex:0]valueForKey:@"to_area"],[[array objectAtIndex:0]valueForKey:@"deartmentname"]];
	if (buttonIndex == 0) {			
		fbAgent.shouldResumeSession =YES;
		
		[fbAgent publishFeedWithName:str_lbl 
						 captionText:[[array objectAtIndex:0]valueForKey:@"title"]  
							imageurl:[arrSecondaryImg objectAtIndex:0]
							 linkurl:strUrl
				   userMessagePrompt:@"Legg inn dine kommentarer" 
						 actionLabel:@"Check Out this Property"
						  actionText:strUrl
						  actionLink:strUrl];
	
	}
	else if(buttonIndex == 1){
		//isAgent = FALSE;
		
		senderTxt.text =@"";
		receiverTxt.text=@"";
		MsgTxt.text =@"";
		[receiverTxt becomeFirstResponder];
		sendMailView.hidden =FALSE;    
	}
}

- (void) facebookAgent:(FacebookAgent*)agent requestFaild:(NSString*) message{
	fbAgent.shouldResumeSession =NO;
	[fbAgent setStatus:@"status from iPhone demo 1 2"];
}
- (void) facebookAgent:(FacebookAgent*)agent statusChanged:(BOOL) success{
}
- (void) facebookAgent:(FacebookAgent*)agent loginStatus:(BOOL) loggedIn{
}
-(IBAction)clickLukk{
	viewSokAlert.hidden=TRUE;
	if(flagForNoData==1)[self.navigationController popViewControllerAnimated:YES];	
}

-(void)clickBack{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickLagre{	
	viewAlert.hidden= NO;
}

-(IBAction)clickSave{
	viewAlert.hidden= YES;
	[self GDATASave];		
}

-(IBAction)clickCancel{
	viewAlert.hidden= YES;	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if(interfaceOrientation ==UIInterfaceOrientationLandscapeLeft||interfaceOrientation ==UIInterfaceOrientationLandscapeRight){
		if(appdel.tagMethere) return NO;
		if(isMail)	return NO;		
		
		if(appdel.addcnt==0){            
            //UIImageView *view = nil;
            //NSArray *subviews = [scrollView1 subviews];
            //view =[subviews objectAtIndex:imageCnt];
            appdel.addcnt=1;
			isPushed =TRUE;
            ZoomViewController *obj =[[ZoomViewController alloc]initWithNibName:@"ZoomViewController" bundle:nil];
			obj.orirntation =interfaceOrientation;
			
			
			
			obj.img_arr = arrSecondaryImg;
		
			
			//obj.myImage =view.image;
		
			obj.pageNo = imageCnt;
			
			
           // [self.view addSubview:obj.view];
			[self.navigationController pushViewController:obj animated:NO];
			//[obj release];
        }
    }
    return NO;
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
	
	[lblDepartmentName release];
	[titleLable release];
	[lblAreaName release];
	[lblAreaIs release];
	[lblDistance release];
	[lblImgCnt release];
	
	if(arrSplitFacility!=nil){
		arrSplitFacility=nil;
		[arrSplitFacility release];
	}
	
	
	if(array!=nil){
		array=nil;
		[array release];
	}
	if(strURL!=nil){
		strURL=nil;
		[strURL release];
	}
	
		[arrSecondaryImg release];

	if(lblDepartmentName!=nil){
		lblDepartmentName=nil;
		[lblDepartmentName release];
	}
	if(lblAreaName!=nil){
		lblAreaName=nil;
		[lblAreaName release];
	}
	if(lblAreaIs!=nil){
		lblAreaIs=nil;
		[lblAreaIs release];
	}
	if(lblDistance!=nil){
		lblDistance=nil;
		[lblDistance release];
	}
	if(titleLable!=nil){
		titleLable=nil;
		[titleLable release];
	}		
	if(tblPropertyInfo!=nil){
		tblPropertyInfo=nil;
		[tblPropertyInfo release];
	}
	
	
	
	if(strDistance!=nil){
		strDistance=nil;
		[strDistance release];
	}
}
@end
