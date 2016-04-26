//
//  GdataParser.m
//  TestWebService
//
//  Created by apple on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GdataParser.h"
#import "AlertHandler.h"

@implementation GdataParser
@synthesize tagDic,rootTag,isLoading;
- (void)downloadAndParse:(NSURL *)url withRootTag:(NSString*)root withTags:(NSDictionary*)tags sel:(SEL)seletor andHandler:(NSObject*)handler{
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication]delegate];
//	if(!isLoading)
//	[AlertHandler showAlertForProcess];
	NSLog(@"url is::: %@",url);
	self.tagDic =tags;
	self.rootTag=root;
	targetSelector=seletor;
	MainHandler=handler;
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url];
	 xmlData = [[NSMutableData alloc] init]; 
	NSURLConnection  *rssConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

	//NSURLConnection  *rssConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
} 
-(void)setLoading:(BOOL)isLoadindval{
    isLoading=isLoadindval;
}
 
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	
	[xmlData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
    [xmlData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication]delegate];
//	if(appdel.isAlert)
	[AlertHandler hideAlert];
	UIAlertView *alertConn=[[UIAlertView alloc]initWithTitle:@"Ingen Internett" 
													 message:@"Internett-tilkobling ikke funnet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertConn show];
	[alertConn release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication]delegate];
//	if(appdel.isAlert)	
//	[AlertHandler hideAlert];
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    NSMutableArray *finalResult = [[NSMutableArray alloc] init];
	NSArray *items = [doc nodesForXPath:[NSString stringWithFormat:@"//%@",rootTag] error:nil];
    for (GDataXMLElement *item in items) {
		
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

		NSArray *ar= [tagDic allKeys];
		for (int i=0; i < [ar count]; i++) {
			 NSArray *tmpArray = [item elementsForName:[NSString stringWithFormat:@"%@",[tagDic objectForKey:[ar objectAtIndex:i]]]];
			for(GDataXMLElement *aID in tmpArray) {
				
				[dic setValue:aID.stringValue forKey:[NSString stringWithFormat:@"%@",[tagDic objectForKey:[ar objectAtIndex:i]]]];
				break;
			}
		}
		[finalResult addObject:dic];
    }
	
	[MainHandler performSelector:targetSelector withObject:[NSDictionary dictionaryWithObjectsAndKeys:finalResult,@"array",nil]];
	xmlData = nil;
    // Set the condition which ends the run loop.
 
}



- (void)dealloc {

    [super dealloc];
}

@end
