//
//  DatabaseManager.m
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/7/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager

+ (DatabaseManager*) sharedInstance{
    
    static DatabaseManager *sharedInstance;
    static dispatch_once_t oncePredicat;
    dispatch_once(&oncePredicat, ^{
        sharedInstance = [[DatabaseManager alloc] init];
        [sharedInstance createAll];
    });
    return sharedInstance;
}

- (void) createAll{
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"moviesDB.db"]];
    
    const char *dbPath = [_databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &_contacDB) == SQLITE_OK){
        char *errMsg;
        
        // create movies table
        const char *movies_sql_stmt = "CREATE TABLE IF NOT EXISTS Movies (movieID INTEGER PRIMARY KEY, vote_average DOUBLE, title TEXT, poster_path TEXT, overview TEXT, release_date TEXT) ";
        if(sqlite3_exec(_contacDB, movies_sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
            printf("%s", "Faild to create movies table");
        }
        
        
        // create reviews table
        const char *reviews_sql_stmt = "CREATE TABLE IF NOT EXISTS Reviews (movieID INTEGER PRIMARY KEY, reviewAuthor TEXT, reviewContent TEXT) ";
        if(sqlite3_exec(_contacDB, reviews_sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
            printf("%s", "Faild to create reviews table");
        }
        
        // create videos table
        const char *videos_sql_stmt = "CREATE TABLE IF NOT EXISTS Videos (movieID INTEGER PRIMARY KEY, videoName TEXT, videoKey TEXT) ";
        if(sqlite3_exec(_contacDB, videos_sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
            printf("%s", "Faild to create videos table");
        }
        sqlite3_close(_contacDB);
    }else{
        printf("%s", "Faild to open/create database");
    }
}
@end
