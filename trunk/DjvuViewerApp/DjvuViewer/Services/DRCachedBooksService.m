//
//  DRCachedBooksService.m
//  DjvuViewer
//
//  Created by Alex Martynov on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRCachedBooksService.h"

#import <CoreData/CoreData.h>

#import "DRBook.h"
#import "DRCachedBook.h"
#import "CUSpecialFolders.h"

@interface DRCachedBooksService()

-(void)managedStorage;

-(NSURL *)persistentStoreURL;

@end

@implementation DRCachedBooksService

-(id)init
{
	if (self = [super init])
	{
		[self managedStorage];
	}
	
	return self;
}

-(void)dealloc
{
	[persistentStoreURL release];
	[super dealloc];
}

#pragma mark -
#pragma mark public

-(NSArray*)cachedBooks
{
	//http://www.duckrowing.com/2010/03/11/using-core-data-on-multiple-threads/
	/**/
	NSManagedObjectModel* model = [NSManagedObjectModel mergedModelFromBundles:nil];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"DRCachedBook" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError *error = nil;  
	NSArray *result = [managedObjectContext executeFetchRequest:request error:&error];

	//TODO: handle error
	return result;
}

-(DRCachedBook*)cachedBookForChecksum:(NSString*)checksum
{
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"DRCachedBook" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	NSPredicate* selectPredicate = [NSPredicate predicateWithFormat:@"checksum == %@", checksum];
	[request setPredicate:selectPredicate];
	
	NSError *error = nil;  
	NSArray *result = [managedObjectContext executeFetchRequest:request error:&error];

	NSAssert([result count] <= 1, @"Checksum is not unique");
	
	if ([result count] == 0)
		return nil;
	
	return [result lastObject];
}

- (void)addItem:(NSString*)path
		  order:(NSUInteger)order
	   checksum:(NSString*)checksum
{
	DRCachedBook* book = (DRCachedBook *)[NSEntityDescription insertNewObjectForEntityForName:@"DRCachedBook"
		inManagedObjectContext:managedObjectContext];

	book.url = path;
	book.order = [NSNumber numberWithUnsignedInteger:order];
	book.checksum = checksum;

	NSError *error = nil;
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}
}

-(void)addBook:(DRBook*)book
{
	DRCachedBook* cachedBook = [self cachedBookForChecksum:book.checksum];
	
	if (cachedBook == nil)
	{
		//TODO: new book
	}
	
	cachedBook.order = [NSNumber numberWithInteger: book.order];

	NSError *error = nil;
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}
}
-(void)deleteCachedBook:(DRCachedBook*)book
{
	[managedObjectContext deleteObject:book];
	
	NSError *error = nil;
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}
}

#pragma mark -
#pragma mark private

-(void)managedStorage
{
	NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
	
	NSError *error = nil;
    NSPersistentStore *persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
configuration:nil
URL:[self persistentStoreURL]
 options:nil error:&error];
	
	managedObjectContext = [[NSManagedObjectContext alloc] init];
	[managedObjectContext setPersistentStoreCoordinator: persistentStoreCoordinator];
	
	/**/
//	Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
//	NSError *error = nil;
//	if (![managedObjectContext save:&error]) {
//		// Handle the error.
//	}
	
	/**/
//	NSFetchRequest *request = [[NSFetchRequest alloc] init];
//	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
//	[request setEntity:entity];
//	
//	
//	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
//	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//	[request setSortDescriptors:sortDescriptors];
//	[sortDescriptors release];
//	[sortDescriptor release];
//	
//	NSError *error = nil;
//	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
//	if (mutableFetchResults == nil) {
//		// Handle the error.
//	}
//	
//	[self setEventsArray:mutableFetchResults];
//	[mutableFetchResults release];
//	[request release];
}

-(NSURL *)persistentStoreURL
{
    if (persistentStoreURL == nil)
	{
        NSString *persistentStorePath = [[CSUserDocumentsDirectory()stringByAppendingPathComponent:@"TopSongs.sqlite"] retain];
		persistentStoreURL = [NSURL fileURLWithPath:persistentStorePath];
    }
    return persistentStoreURL;
}

@end
