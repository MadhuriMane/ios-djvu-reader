//
//  DRDjvuThumbnailerTask.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DRDjvuThumbnailerTaskDelegate;

@interface DRDjvuThumbnailerTask : NSOperation

+ (id) djvuThumbnailerTaskWithFileAtPath:(NSString*)path thumbnailSize:(CGSize)size;

- (id) initWithFileAtPath:(NSString*)path thumbnailSize:(CGSize)size;

@property(nonatomic, assign) id<DRDjvuThumbnailerTaskDelegate> delegate;

@end
