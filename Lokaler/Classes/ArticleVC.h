//
//  ArticleVC.h
//  EstateLokaler
//
//  Created by apple1 on 10/10/11.
//  Copyright 2011 openxcek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GdataParser;
@class PropertiesDetailVC;
@class EstateLokalerAppDelegate;
@class ArticleVCCell;
@class ArticleCellDetail;
@class ArticleDetail;
@interface ArticleVC : UIViewController <UITableViewDelegate,UITableViewDataSource> {

	IBOutlet UITableView *tblArticle;
	IBOutlet UIButton *btnBack;
	EstateLokalerAppDelegate *appdel;
	PropertiesDetailVC *propertiesDetailVCObj;
	
	NSMutableArray *arrArtList;
	NSMutableArray *arrArtID;
	
	NSMutableDictionary *dict;
	
	int cntArt;
}
-(void)GDATA;
-(IBAction)onBack;
@end
