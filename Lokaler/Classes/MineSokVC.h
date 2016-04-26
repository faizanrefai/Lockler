//
//  MineSokVC1.h
//  EstateLokaler
//
//  Created by apple  on 9/29/11.
//  Copyright 2011 hjbvb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GdataParser;
@class EstateLokalerAppDelegate;
@class MineSokCell;
@class MineFunnVC;

@interface MineSokVC:UIViewController<UITableViewDelegate,UITableViewDataSource> {
	EstateLokalerAppDelegate *appdel;
	NSMutableArray *type_arr;
	NSMutableArray *town_arr;
	NSMutableArray *area_arr;
	NSMutableArray *size_arr;
	NSMutableArray *procnt_arr;	
	MineFunnVC *detailViewController;
	IBOutlet UITableView *myTable;
	BOOL isPushed;
}

-(void)GDATACntProp:(NSString*)str_id;
-(IBAction)clickBack;
-(IBAction)sokDelete;
-(void)GDATATown;
-(void)GDATAArea;
-(void)GDATADept;

-(void)GDATADelete:(NSString *)idVal;
-(void)GDATASokProperty:(NSString*)idStr;
-(NSString*)getTownName:(NSArray*)valArr;
-(NSString*)getAreaName:(NSArray*)valArr;
-(NSString*)getDeptName:(NSArray*)valArr;

@end

	