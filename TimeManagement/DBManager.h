//
//  DBManager.h
//  SQLite3DBSample
//
//  Created by kit305 on 9/5/17.
//  Copyright © 2017 UTAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject


@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

@end
