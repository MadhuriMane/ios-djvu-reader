//
//  DRFilesBrowserViewController.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRBooksBrowserService;

@protocol DRBooksBrowserControllerDelegate;

@interface DRBooksBrowserViewController : UIViewController {
	
	@private
	NSMutableArray *files;
	DRBooksBrowserService *booksBrowser;

}

-(id)init;

@property(nonatomic, assign) id<DRBooksBrowserControllerDelegate> delegate;
@property(nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *editButton;
@property(nonatomic, retain) IBOutlet UINavigationBar *navigationBar;

-(IBAction)editFilesAction:(id)sender;

@end
