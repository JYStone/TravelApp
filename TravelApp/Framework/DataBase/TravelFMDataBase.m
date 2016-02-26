//
//  TravelFMDataBase.m
//  TravelApp
//
//  Created by lanou on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "TravelFMDataBase.h"
#import "MainScreenBound.h"
#import "TouristAttraction.h"

static TravelFMDataBase *db;
@implementation TravelFMDataBase

+ (TravelFMDataBase *)shareTravelDataBase {
    
    static dispatch_once_t onceToken;
    if (db == nil) {
        dispatch_once(&onceToken, ^{
            db = [[TravelFMDataBase alloc] init];
        });
    }
    return db;
}

- (NSString *)createPathForSqliteWithSqliteName:(NSString *)sqliteName {

    NSString *dataPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:sqliteName];
    return dataPath;
}

//打开数据库所在路径的数据库
- (void)openDataBaseWithSqliteName:(NSString *)sqliteName {

    NSString *dataPath = [self createPathForSqliteWithSqliteName:sqliteName];
    GCZLog(@"%@", dataPath);
    self.dataBase = [FMDatabase databaseWithPath:dataPath];
    
}

//关闭数据库
- (void)closeSqlite {
    
    [self.dataBase close];
    
}

//根据给定的表名创建Table 如果执行时没有数据库 则用给定的数据库名字 创建数据库
- (void)createTabeleForSqliteWithName:(NSString *)sqliteName tableName:(NSString *)tableName {
    
    if (!_dataBase) {
        [self openDataBaseWithSqliteName:[NSString stringWithFormat:@"%@.db", sqliteName]];
        
    }
    //创建语句
    NSString *createTableString = [NSString stringWithFormat:@"CREATE TABLE %@(TITLE TEXT PRIMARY KEY, Url TEXT , Type TEXT, ImageUrl TEXT, Name TEXT, Recommended TEXT)", tableName];
    
    if ([_dataBase open]) {
        BOOL dataName = [_dataBase executeUpdate:createTableString];
        if (dataName) {
            GCZLog(@"创建成功");
        } else {
            GCZLog(@"已创建 或 创建失败");
        }
    }
    
    
}

- (void)insertRowToTableWithModel:(id)travelModel tableName:(NSString *)tableName {
    
    if (!travelModel) {
        GCZLog(@"模型为空");
    } else if ([self.dataBase open]) {
        
        //创建插入语句
        NSString *insterString = [NSString stringWithFormat:@"insert into %@(TITLE, Url, Type, ImageUrl, Name, Recommended)values(?,?,?,?,?,?)", tableName];
        
        
        if ([travelModel isKindOfClass:[GCZTravelListModel class]]) {
            
            GCZTravelListModel *model = (GCZTravelListModel *)travelModel;
            BOOL insertSqliteResult   = [_dataBase executeUpdate:insterString, model.name, model.ID,  model.ID, model.cover_image, model.ID, model.ID];
            if (insertSqliteResult) {
                GCZLog(@"插入成功");
            }
            
            
        } else if ([travelModel isKindOfClass:[StoryModel class]]) {
            
            StoryModel *model       = (StoryModel *)travelModel;
            
            BOOL insertSqliteResult = [_dataBase executeUpdate:insterString, model.text, model.spot_id, model.spot_id, model.cover_image_1600, model.spot_id, model.spot_id];
            if (insertSqliteResult) {
                GCZLog(@"插入成功");
        }
        
        }
    }
    
}

- (void)insertRowToTableWithTouristAttractionModel:(TouristAttraction *)touristAttractionModel tableName:(NSString *)tableName {
    
    if (!touristAttractionModel) {
        GCZLog(@"模型为空");
    } else if ([self.dataBase open]) {
        
        //创建插入语句
        NSString *insterString = [NSString stringWithFormat:@"insert into %@(TITLE, Url, Type, ImageUrl, Name, Recommended)values(?,?,?,?,?,?)", tableName];
        
        BOOL insertSqliteResult   = [_dataBase executeUpdate:insterString, touristAttractionModel.name, touristAttractionModel.ID, touristAttractionModel.type, touristAttractionModel.cover, touristAttractionModel.name, touristAttractionModel.recommended_reason];
        
        if (insertSqliteResult) {
            GCZLog(@"插入成功");
        } else {
            GCZLog(@"插入失败");
        }
    }
}

- (void)deleteRowFromTableWithTravelName:(NSString *)travelName tableName:(NSString *)tableName {
    
    if ([_dataBase open]) {
        NSString *delegateRowString = [NSString stringWithFormat:@"delete from %@ where TITLE = '%@'",tableName, travelName];
        BOOL delegateResult = [_dataBase executeUpdate:delegateRowString];
        if (delegateResult) {
            GCZLog(@"删除成功");
        } else {
            GCZLog(@"删除失败");
        }
        
    }
    
}

//整个某个表中数据库的数据
- (NSArray *)selectAllDataWithTable:(NSString *)tableName {
    
    NSMutableArray *dataArray = [NSMutableArray array];
    if ([_dataBase open]) {
        
        NSString *selectAll = [NSString stringWithFormat:@"select *from %@", tableName];
        
        FMResultSet *selectSet = [self.dataBase executeQuery:selectAll];
        
        while ([selectSet next]) {
            
            NSString *name = [selectSet stringForColumn:@"TITLE"];
            NSString *type = [selectSet stringForColumn:@"Type"];
            NSString *url = [selectSet stringForColumn:@"Url"];
            NSString *imageUrl = [selectSet stringForColumn:@"ImageUrl"];
            
            NSString *titlNname = [selectSet stringForColumn:@"Name"];
            NSString *recommed = [selectSet stringForColumn:@"Recommended"];
            
            GCZTravelListModel *model = [[GCZTravelListModel alloc] init];
            model.name = name;
            model.url = url;
            model.type = type;
            model.cover = imageUrl;
            
            model.title = titlNname;
            model.recommended = recommed;
            
            [dataArray addObject:model];
        }
        
        
    }
    return [dataArray copy];
    
}

- (BOOL)selectRowWithTravelName:(NSString *)travelName tableName:(NSString *)tableName {
    
    NSString *resultString = NULL;
    if ([_dataBase open]) {
        NSString *selectString = [NSString stringWithFormat:@"select *from %@",tableName];
        
        FMResultSet *rs = [_dataBase executeQuery:selectString];
        
        while ([rs next]) {
            NSString *string = [rs stringForColumn:@"TITLE"];
            if ([string isEqualToString:travelName]) {
                resultString = travelName;
            }
        }
        
    }
    if (resultString) {
        return YES;
    } else {
        return NO;
    }
    
}








@end
