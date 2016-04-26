//
//  detailCell.h
//  EstateLokaler
//
//  Created by apple1 on 10/15/11.
//  Copyright 2011 openxcek. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface detailCell : UITableViewCell<UIWebViewDelegate> {

	IBOutlet UIWebView *webView;
	IBOutlet UIActivityIndicatorView *actView;
}

@property (nonatomic, retain) UIWebView *webView;
-(void)LoadURL:(NSString*)str;


@end
