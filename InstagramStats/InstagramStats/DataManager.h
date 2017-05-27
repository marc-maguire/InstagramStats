//
//  DataManager.h
//  InstagramStats
//
//  Created by Alex Mitchell on 2017-05-27.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <InstagramKit.h>

@import CoreData;

@interface DataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic) User *currentUser;

@property (nonatomic) InstagramEngine *engine;

+(id)sharedManager;

-(void)saveContext;

@end