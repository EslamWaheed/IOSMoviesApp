//
//  DatabaseManager.h
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/7/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Movie.h"

@interface DatabaseManager : NSObject

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contacDB;

+ (DatabaseManager*) sharedInstance;

@end
