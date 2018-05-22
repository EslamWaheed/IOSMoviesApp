//
//  ReviewsDB.m
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/8/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import "ReviewsDB.h"

@implementation ReviewsDB

- (NSMutableArray<Reviews *> *) getAllReviews{
    DatabaseManager *databaseManager = [DatabaseManager sharedInstance];
    
    NSMutableArray<Reviews*> *reviewsList = [NSMutableArray new];
    
    const char *dbPath = [databaseManager.databasePath UTF8String];
    
    sqlite3 *contacDB = databaseManager.contacDB;
    
    sqlite3_stmt *stmt;
    
    if (sqlite3_open(dbPath, &contacDB) == SQLITE_OK) {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM Reviews"];
        const char *sql_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(contacDB, sql_stmt, -1, &stmt, NULL) == SQLITE_OK){
            while(sqlite3_step(stmt) == SQLITE_ROW){
                
                Reviews *review = [Reviews new];
                
                review.movieID = sqlite3_column_int(stmt, 0);
                review.reviewAuthor = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(stmt, 1)];
                review.reviewContent = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(stmt, 2)];
                
                [reviewsList addObject:review];
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(contacDB);
    }
    
    return reviewsList;
}

- (void) insertReview: (Reviews*) review{
    DatabaseManager *databaseManager = [DatabaseManager sharedInstance];
    
    const char *dbPath = [databaseManager.databasePath UTF8String];
    
    sqlite3 *contacDB = databaseManager.contacDB;
    
    sqlite3_stmt *stmt;
    
    if(sqlite3_open(dbPath, &contacDB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Reviews (movieID, reviewAuthor, reviewContent) VALUES (\"%i\", \"%@\", \"%@\") ", review.movieID, review.reviewAuthor, review.reviewContent];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(contacDB, insert_stmt, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt) == SQLITE_DONE){
            printf("%s", "Review Add\n");
            
        }else{
            printf("%s", "Failed to Add\n");
        }
        sqlite3_finalize(stmt);
        sqlite3_close(contacDB);
    }
}

- (void) deleteReview: (int) movieID{
    
    DatabaseManager *databaseManager = [DatabaseManager sharedInstance];
    
    const char *dbPath = [databaseManager.databasePath UTF8String];
    
    sqlite3 *contacDB = databaseManager.contacDB;
    
    sqlite3_stmt *stmt;
    
    if (sqlite3_open(dbPath, &contacDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Reviews WHERE movieID = \"%d\" ", movieID];
        
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
