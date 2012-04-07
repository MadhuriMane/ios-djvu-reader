//
//  DRFilesBrowserViewController.m
//  DjvuViewer
//
//  Created by Alex Martynov on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRBooksBrowserViewController.h"

#import "DRBook.h"
#import "DRThemeInfo.h"
#import "DRMainViewController.h"
#import "DRBooksBrowserService.h"
#import "NSMutableArray+MoveObject.h"
#import "DRBooksBrowserControllerDelegate.h"

@interface DRBooksBrowserViewController()

-(void)toggleEditingMode;

-(void)reloadDataWithBooks:(NSArray*)books;

@end

@implementation DRBooksBrowserViewController

- (id) init
{
	return [self initWithNibName:@"DRBooksBrowserViewController"
						  bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
		booksBrowser = [[DRBooksBrowserService alloc]init];
		files = [[NSMutableArray arrayWithArray: [booksBrowser books]] retain];
		booksBrowser.delegate = self;
		[booksBrowser startUpdating];
    }
    return self;
}

- (void) dealloc
{
	self.tableView = nil;
	[files release];
	[booksBrowser release];
	[super dealloc];
}

#pragma mark -
#pragma mark properties

@synthesize tableView, editButton, navigationBar, delegate;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.backgroundView = nil;
	self.tableView.backgroundColor = [DRThemeInfo scrollViewBackground];
	
	self.navigationItem.title = @"Browse Files";
	self.navigationItem.rightBarButtonItem = 
	[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
												   target:self
												   action:@selector(editFilesAction:)] autorelease];
	
	[self.navigationBar pushNavigationItem:self.navigationItem
								  animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark actions

-(IBAction)editFilesAction:(id)sender
{
	[self toggleEditingMode];
}

-(IBAction)doneFilesAction:(id)sender
{
	[booksBrowser syncCache:files];
	[self toggleEditingMode];
}

#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = ((DRBook*)[files objectAtIndex:indexPath.row]).title;
	cell.imageView.image = ((DRBook*)[files objectAtIndex:indexPath.row]).image;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	[files moveObjectAtIndex:[fromIndexPath row]
					 toIndex:[toIndexPath row]];	
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//TODO: add support for removing
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.delegate booksBrowserController:self
							didSelectBook:[files objectAtIndex:indexPath.row]];
}

#pragma mark -
#pragma mark DRBooksBrowserServiceDelegate

-(void)booksBrowserService:(DRBooksBrowserService*)service didUpdateToList:(NSArray*)books
{
	NSLog(@"Books list updated to %@", books);
	
}

#pragma mark -
#pragma mark private

-(void)toggleEditingMode
{
	BOOL newEditing = !self.tableView.editing;
	
	if (newEditing)
	{
		self.navigationItem.rightBarButtonItem = 
		[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
													   target:self
													   action:@selector(doneFilesAction:)] autorelease];
	}
	else
	{
		self.navigationItem.rightBarButtonItem = 
		[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
													   target:self
													   action:@selector(editFilesAction:)] autorelease];
	}
	
	[self.tableView setEditing:newEditing animated:YES];
}

-(void)reloadDataWithBooks:(NSArray*)books
{
	[files release];
	files = [[NSMutableArray arrayWithArray: books] retain];
	[self.tableView reloadData];
}

@end
