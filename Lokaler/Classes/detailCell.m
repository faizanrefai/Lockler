//
//  detailCell.m
//  EstateLokaler
//
//  Created by apple1 on 10/15/11.
//  Copyright 2011 openxcek. All rights reserved.
//

#import "detailCell.h"


@implementation detailCell
@synthesize webView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(void)LoadURL:(NSString*)str{	
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[actView startAnimating];
	actView.hidden =FALSE;
   
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[actView stopAnimating];
	actView.hidden =TRUE;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//	NSString *myText = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[actView stopAnimating];
	actView.hidden =TRUE;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
	[webView release];
}


@end
