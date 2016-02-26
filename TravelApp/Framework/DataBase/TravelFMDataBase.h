//
//  TravelFMDataBase.h
//  TravelApp
//
//  Created by lanou on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@class GCZTravelListModel;
@class TouristAttraction;

@interface TravelFMDataBase : NSObject

@property (nonatomic,strong) FMDatabase *dataBase;

+ (TravelFMDataBase *)shareTravelDataBase;

//根据数据库名字 创建路径
- (NSString *)createPathForSqliteWithSqliteName:(NSString *)sqliteName;

//根据数据库名字打开数据库
- (void)openDataBaseWithSqliteName:(NSString *)sqliteName;

//关闭数据库
- (void)closeSqlite;

//根据给的表名 创建数据库表 如果没有就用给的 数据库名字创建一个数据库
- (void)createTabeleForSqliteWithName:(NSString *)sqliteName tableName:(NSString *)tableName;

//插入一条数据
- (void)insertRowToTableWithModel:(id)travelModel tableName:(NSString *)tableName;

//插入旅游数据(SZT) 到对应的Table
- (void)insertRowToTableWithTouristAttractionModel:(TouristAttraction *)touristAttractionModel tableName:(NSString *)tableName;

//删除一条数据 根据旅游名删除
- (void)deleteRowFromTableWithTravelName:(NSString *)travelName tableName:(NSString *)tableName;

//获取整个数据库
- (NSArray *)selectAllDataWithTable:(NSString *)tableName;

//判断是否已经被收藏
- (BOOL)selectRowWithTravelName:(NSString *)travelName tableName:(NSString *)tableName;
















@end
