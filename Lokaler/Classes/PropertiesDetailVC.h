//
//  PropertiesDetailVC.h
//  EstateLokaler
//
//  Created by apple on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "ArticleDetail.h"
#import "FacebookAgent.h"
#import "MainViewController.h"
#import "CurrentLocationMap.h"

@class GTHeaderView;
@class GdataParser;
@class EstateLokalerAppDelegate;
@class CurrentLocationMap;
@class SHKItem;
@class SHKFacebook;
@class SHKMail;
@class ArticleVC;
@class EGOImageView;
@class PropertiesDetailVC;
@class detailCell;
@class Facility;

@interface PropertiesDetailVC : UIViewController <UITextFieldDelegate,FacebookAgentDelegate,UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>{
	NSString *showpropertuId;
	FacebookAgent *fbAgent;
	NSArray *arrHeader;
	MainViewController *tagmeObj;
	UIImageView *image;
	NSMutableArray* arrAddHeader;
	EstateLokalerAppDelegate *appdel;
	UIActionSheet *asheet;
	NSMutableArray *arrSecondaryImg;
	NSMutableArray *arrSplitFacility;
	int desclen;
	UIWebView *webView;
	UIScrollView *scrollView;
	
	IBOutlet UIScrollView *MainScroll;
	
	IBOutlet UITableView *tblPropertyInfo;
	IBOutlet UIView *viewAlert;
	IBOutlet UIView *viewSokAlert;
	
	IBOutlet UILabel *lblDepartmentName;
	IBOutlet UILabel *titleLable;
	IBOutlet UILabel *lblAreaName;
	IBOutlet UILabel *lblAreaIs;
	IBOutlet UILabel *lblDistance;
	IBOutlet UILabel *lblImgCnt;
	IBOutlet UILabel *lblAlertTitle;

	NSString *strDistance;
	NSString *strFromArea;
	NSString *strToArea;
	NSString *strURL;
	NSString *strLatitude;
	NSString *strLongitude;
	NSString *strTitle1;
	
	NSString *strCurrentID;
	NSString *strHouseAddress;
	
	NSMutableDictionary *_dict1;
	NSMutableDictionary *tmp_dict;
	NSMutableDictionary *dictContact;

	IBOutlet UIView *subView;
	int flag0;
	int flag1;
	int flag2;
	int flag3;
	int flagForNoData;
	int flagSecDetail;
	
	int Pre_height;	
	NSMutableArray *arrArtList;
	
	int cntArt;	
	int noAgent;
	
	
	NSMutableArray *array;
	
	IBOutlet UIScrollView *scrollView1;
	
	UISwipeGestureRecognizer *swipeLeftRecognizer;
	UIViewController *myView;
	UIPinchGestureRecognizer *recognizer;

	EGOImageView *imageViewL;
	int imageCnt;
	
	IBOutlet UITableViewCell *detail;
	IBOutlet UITableViewCell *faci;
	IBOutlet UITableViewCell *head;
	IBOutlet UITableViewCell *art;
	
	IBOutlet UIButton *btnCall;
	IBOutlet UIButton *btnMail;
	NSString *strMailID;
	NSString *strCall;
	BOOL isMail;
	BOOL isPushed;
	BOOL isAgent;
	ArticleDetail *detailViewController;
	IBOutlet UIView *sendMailView;
	IBOutlet UITextField *senderTxt;
	IBOutlet UITextField *receiverTxt;
	IBOutlet UITextField *MsgTxt;
	CurrentLocationMap *objMap;
	
	
	
}

-(IBAction)onMailWS:(id)sender;
-(IBAction)oncancelWS:(id)sender;
-(IBAction)clickBack;
-(IBAction)clickLagre;
-(IBAction)clickSave;
-(IBAction)clickCancel;
-(IBAction)ShowMap;
-(IBAction)clickShare;
-(IBAction)clickLukk;
-(IBAction)clickOnMail:(id)sender;
-(IBAction)onTegMethere:(id)sender;

-(IBAction)clickOnCall:(id)sender;
-(void)scroll;
-(void)Share;
//-(void)article;
-(void)GDATA;
-(void)GDATAArt;
-(NSString*)textForPosting;-(NSString*)textForPosting;

- (NSArray*)indexPathsInSection:(NSInteger)section;
- (void)toggle:(NSString*)isExpanded section:(NSInteger)section;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
-(void)toggleSectionForSection:(id)sender;
-(void)GDATAArtDet;

@property(nonatomic,retain)UIButton *btnMail;
@property(nonatomic,retain)NSString *showpropertuId;
@property(nonatomic,retain)UIButton *btnCall;
@property(nonatomic,retain)UITableViewCell *detail;;
@property(nonatomic,retain)IBOutlet UITableViewCell *faci;
@property (nonatomic, retain) UITableViewCell *head;
@property(nonatomic,retain)	UITableViewCell *art;
@property(nonatomic,retain) NSString *strCurrentID;

@property(nonatomic,retain) UILabel *lblDepartmentName;
@property(nonatomic,retain) UILabel *lblAreaName;
@property(nonatomic,retain) UILabel *lblAreaIs;
@property(nonatomic,retain) UILabel *lblDistance;
@property(nonatomic,retain) UILabel *titleLable;
- (void) animateTextField:(BOOL) up;
-(void)generateHeaderViews;
-(void)LoadURL:(NSString*)str;

@end
