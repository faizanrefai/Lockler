//
//  ArticleVCCell.h
//  EstateLokaler
//
//  Created by apple1 on 10/10/11.
//  Copyright 2011 openxcek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArticleVC;
@interface ArticleVCCell : UITableViewCell {

	IBOutlet UILabel *lblTitle;
	IBOutlet UILabel *lblIntro;
	IBOutlet UILabel *lblCategory;
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblAuthor;
	
	NSString *strTitle;
	NSString *strIntro;
	NSString *strCat;
}
-(void)setData:(NSMutableDictionary*)dt;

@end