//
//  DRBook.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRBook : NSObject {

}

+ (id) bookWithPath:(NSString*)path checksum:(NSString*)checksum;

- (id) initWithPath:(NSString*)path checksum:(NSString*)checksum;

@property (nonatomic, retain, readonly) NSString *path;
@property (nonatomic, retain, readonly) NSString *title;
@property (nonatomic, retain, readonly) NSString *checksum;
@property (nonatomic, retain, readonly) UIImage *image;
@property (nonatomic, assign) NSInteger order;

@end
