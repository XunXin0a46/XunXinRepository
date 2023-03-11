//
//  TTPersistentStoreManager.m
//  test
//
//  Created by 王刚 on 2022/12/14.
//

#import "TTPersistentStoreManager.h"

@interface TTPersistentStoreManager()

//操纵和跟踪托管对象更改的上下文对象
@property (nonatomic, strong) NSManagedObjectContext *context;
//持久化存储协调器
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
//被管理对象模型
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation TTPersistentStoreManager

/// 单例
+ (instancetype)sharedManager {
    static TTPersistentStoreManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

/// 保存上下文，对save:方法的封装，方便获取NSError
- (NSError *)saveContext {
    NSError *error = nil;
    //如果上下文有未提交的更改，提交更改
    if (self.context.hasChanges) {
        [self.context save:&error];
    }
    return error;
}

/// 根据用户ID插入用户
/// - Parameter userID: 用户ID
/// - Parameter userName: 用户名
- (UserEntity *)insertUserWithUserID:(int64_t)userID userName:(NSString *)userName;{
    //创建UserEntity实体的实例
    UserEntity *userEntity = (UserEntity *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(UserEntity.class) inManagedObjectContext:self.context];
    //为实体字段赋值
    userEntity.userID = userID;
    userEntity.userName = userName;
    //保存上下文
    if ([self saveContext]) {
        [NSException raise:@"创建UserEntity失败" format:@"userID = %lld", userID];
        return nil;
    } else {
        return userEntity;
    }
}

/// 根据用户ID查询用户
/// - Parameter userID: 用户ID
- (nullable UserEntity *)queryqueryWithUserID:(int64_t)userID {
    //获取搜索条件描述对象
    NSFetchRequest<UserEntity *> *fetchRequest = UserEntity.fetchRequest;
    //搜索条件谓词
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"userID = %lld", userID];
    //提取满足指定搜索请求条件的对象数组
    NSError *error = nil;
    NSArray<UserEntity *> *caches = [self.context executeFetchRequest:fetchRequest error:&error];
    //提取发生错误
    if (error) {
        NSException *exception = [[NSException alloc] initWithName:error.localizedDescription reason:error.localizedFailureReason userInfo:error.userInfo];
        [exception raise];
    }
    //提取的对象大于1(业务错误)
    if (caches.count > 1) {
        [NSException raise:@"通过userID获取到的用户数量不为1" format:@"customerId = %lld", userID];
    }
    return caches.firstObject;
}

/// 根据用户ID删除用户
/// - Parameter userID: 用户ID
- (void)deleteUserWithUserID:(int64_t)userID {
    //根据用户ID查询用户
    UserEntity *user = [self queryqueryWithUserID:userID];
    //如果查到用户，将改用户删除
    if (user) {
        [self.context deleteObject:user];
        [self saveContext];
    }
}

#pragma mark - 懒加载

/// 懒加载被管理对象上下文
- (NSManagedObjectContext *)context {
    if (_context == nil) {
        //创建主队列并发类型的上下文
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        //设置上下文的持久化存储协调器
        _context.persistentStoreCoordinator = self.coordinator;
    }
    return _context;
}

/// 懒加载持久化存储协调器
- (NSPersistentStoreCoordinator *)coordinator {
    if (_coordinator == nil) {
        //使用指定的被管理对象模型创建一个持久存储协调器
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        //获取Documents目录位置
        NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        //生成sqlite文件路径
        NSURL *sqliteURL = [[NSURL fileURLWithPath:documentDirectory] URLByAppendingPathComponent:@"TT.sqlite"];
        //设置自动尝试迁移版本化的存储
        //设置如果没有找到映射模型，协调器将尝试推断映射模型。
        NSDictionary *options = @{
            NSMigratePersistentStoresAutomaticallyOption: @(YES),
            NSInferMappingModelAutomaticallyOption: @(YES)
        };
        //在提供的位置添加特定类型的持久存储
        NSError *error = nil;
        [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqliteURL options:options error:&error];
        //在提供的位置添加特定类型的持久存储失败，记录失败原因，终止程序
        if (error) {
            NSException *exception = [[NSException alloc] initWithName:error.localizedDescription reason:error.localizedFailureReason userInfo:error.userInfo];
            [exception raise];
        }
    }
    return _coordinator;
}

/// 懒加载被管理对象模型
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        //指定类关联的NSBundle对象
        NSBundle *bundle = [NSBundle bundleForClass:UserEntity.class];
        //创建NSBundle对象中所有模型合并创建的被管理对象模型
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    }
    return _managedObjectModel;
}

@end
