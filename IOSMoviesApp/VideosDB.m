//
//  VideosDB.m
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/8/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import "VideosDB.h"

@implementation VideosDB

- (NSMutableArray<Videos *> *) getAllVideos{
    DatabaseManager *databaseManager = [DatabaseManager sharedInstance];
    
    NSMutableArray<Videos*> *videosList = [NSMutableArray new];
    
    const char *dbPath = [databaseManager.databasePath UTF8String];
    
    sqlite3 *contacDB = databaseManager.contacDB;
    
    sqlite3_stmt *stmt;
    
    if (sqlite3_open(dbPath, &contacDB) == SQLITE_OK) {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM Reviews"];
        const char *sql_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(contacDB, sql_stmt, -1, &stmt, NULL) == SQLITE_OK){
            while(sqlite3_step(stmt) == SQLITE_ROW){
                
                Videos *video = [Videos new];
                
                video.movieID = sqlite3_column_int(stmt, 0);
                video.videoName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(stmt, 1)];
                video.videoKey = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(stmt, 2)];
                
                [videosList addObject:video];
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(contacDB);
    }
    
    return videosList;
}

- (void) insertVideos: (Videos*) video{
    DatabaseManager *databaseManager = [DatabaseManager sharedInstance];
    
    const char *dbPath = [databaseManager.databasePath UTF8String];
    
    sqlite3 *contacDB = databaseManager.contacDB;
    
    sqlite3_stmt *stmt;

    if(sqlite3_open(dbPath, &contacDB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Videos (movieID, videoName, videoKey) VALUES (\"%i\", \"%@\", \"%@\") ", video.movieID, video.videoName, video.videoKey];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(contacDB, insert_stmt, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt) == SQLITE_DONE){
            printf("%s", "Videos Add\n");
            
        }else{
            printf("%s", "Failed to Add\n");
        }
        sqlite3_finalize(stmt);
        sqlite3_close(contacDB);
    }

}

- (void) deleteVideos: (int) movieID{
    DatabaseManager *databaseManager = [DatabaseManager sharedInstance];
    
    const char *dbPath = [databaseManager.databasePath UTF8String];
    
    sqlite3 *contacDB = databaseManager.contacDB;
    
    sqlite3_stmt *stmt;
    
    if (sqlite3_open(dbPath, &contacDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Videos WHERE movieID = \"%d\" ", movieID];
        
        const char *sql_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(contacDB, sql_stmt, -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_DONE){
                sqlite3_reset(stmt);
            }else{
                NSLog(@"%s", sqlite3_errmsg(contacDB));
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(contacDB);
    }

}

@end
