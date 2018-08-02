//
//  RRTSettingTableViewController.m
//  RSSTestReader
//
//  Created by Yuto on 2018/08/02.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTSettingTableViewController.h"
#import <WebKit/WebKit.h>
#import "RRTAlertViewControllerManager.h"
#import "RSSFeedEntity+CoreDataProperties.h"
#import "RRTNetworkRSSRequestEntity.h"
#import <AFNetworking/AFNetworking.h>

@interface RRTSettingPair : NSObject
typedef void(^eventBlock)(void);
@property NSString *paramter;
@property eventBlock event;
@end

@implementation RRTSettingPair
-(instancetype)initWithParameter:(NSString *)parameter event:(eventBlock)event {
    if (self = [super init]) {
        _paramter = parameter;
        _event = event;
    }
    return self;
}
-(void)perform {
    if (self.event) {
        self.event();
    }
}
@end

@interface RRTSettingViewModel : NSObject
@property NSString *header;
@property NSArray <RRTSettingPair *>*paramters;
@property NSString *footer;
-(instancetype)initWithHeader:(NSString *)header parameters:(NSArray *)parameters footer:(NSString *)footer;
@end

@implementation RRTSettingViewModel
-(instancetype)initWithHeader:(NSString *)header parameters:(NSArray *)parameters footer:(NSString *)footer {
    if (self = [super init]) {
        _header = header;
        _paramters = parameters;
        _footer = footer;
    }
    return self;
}
@end

@interface RRTSettingTableViewController ()

@property NSArray <RRTSettingViewModel *> *visibleArray;

@end

@implementation RRTSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.visibleArray = @[
                            [[RRTSettingViewModel alloc] initWithHeader:@"Settings"
                                                             parameters:@[
                                                                          [[RRTSettingPair alloc] initWithParameter:@"Delete"
                                                                                                              event:^{
                                                                                                                  [RSSFeedEntity MR_truncateAll];
                                                                                                                  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                                                                                                              }],
                                                                          [[RRTSettingPair alloc] initWithParameter:@"Reset"
                                                                                                              event:^{
                                                                                                                  [weakSelf resetPressed];
                                                                                                              }],
                                                                          ]
                                                                 footer:nil],
                            [[RRTSettingViewModel alloc] initWithHeader:@"Acknowledgement"
                                                             parameters:@[
                                                                          [[RRTSettingPair alloc] initWithParameter:@"Acknowledgement"
                                                                                                              event:^{
                                                                                                                  [weakSelf performSegueWithIdentifier:@"AcknowledgementSegue"
                                                                                                                                                sender:nil];
                                                                                                              }],
                                                                          ]
                                                                 footer:nil],
                          ];
}

- (void)resetPressed {
    __block UIAlertController *alert = [[RRTAlertViewControllerManager sharedManager] rssFeedResetAlertController:^(UIAlertAction *action) {
        UITextField *field = [[alert textFields] firstObject];
        NSString *url = [field text];
#ifdef DEBUG
        url = @"https://gist.githubusercontent.com/kairi3108/3d158062219dbf7f98acb7743b4a23c6/raw/40e6a23113e8d3c1b7cfd5d1e44a54bfa9f9538c/Sample.json";
#endif
        if (url == nil || url.length == 0) {
            // ローカル
            NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"Preset" ofType:@"json"];
            NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableLeaves
                                                           error:nil];
            [self performPreset:jsonObj];
        } else {
            // サーバ
            RRTNetworkRequestEntity *jsonRequest = [RRTNetworkRequestEntity request:[NSURL URLWithString:url]];
            NSMutableSet *set = [[(AFJSONResponseSerializer *)jsonRequest.responseSerializer acceptableContentTypes] mutableCopy];
            [set addObject:@"text/plain"];
            [(AFJSONResponseSerializer *)jsonRequest.responseSerializer setAcceptableContentTypes:set];
            [jsonRequest GET:^(RRTNetworkResponseEntity *entity) {
                DDLogDebug(@"JSON Get");
                [self performPreset:entity.object];
            } failed:^(RRTNetworkErrorEntity *entity) {
                UIAlertController *alert = [[RRTAlertViewControllerManager sharedManager] networkErrorAlertController:nil];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }];
        }
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)performPreset:(NSDictionary *)jsonObject {
    RRTAlertViewControllerManager *alertManager = [RRTAlertViewControllerManager sharedManager];
    
    // nilは弾く
    if (jsonObject == nil || ![jsonObject isKindOfClass:[NSDictionary class]]) {
        UIAlertController *alert = [alertManager commonErrorAlertController:@"Cannot Load JSON Object"
                                                                     action:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSArray *rssFeeds = [jsonObject objectForKey:@"RSSPreset"];
    if (rssFeeds == nil || ![rssFeeds isKindOfClass:[NSArray class]]) {
        UIAlertController *alert = [alertManager commonErrorAlertController:@"Invalid Pattern JSON Object"
                                                                     action:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    __block NSMutableArray <NSString *> *availableTitle = [NSMutableArray array];
    __block NSMutableArray <RRTNetworkRSSRequestEntity*>*requestArray = [NSMutableArray array];
    for (NSDictionary *dict in rssFeeds) {
        NSString *url = [dict objectForKey:@"url"];
        NSString *title = [dict objectForKey:@"title"];
        if (url) {
            [requestArray addObject:[RRTNetworkRSSRequestEntity request:[NSURL URLWithString:url]]];
            if (title) {
                [availableTitle addObject:title];
            }
        }
    }
    
    // パース後情報プリント
    NSString *version = [jsonObject objectForKey:@"version"];
    DDLogDebug(@"Preset Version : %@, Presets : %@", version, rssFeeds);
    
    // データリムーブ
    [RSSFeedEntity MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
//    __weak typeof(self) weakSelf = self;
    RRTLoadingViewController *loading = [alertManager loadingViewController:self.storyboard];
    
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    [self presentViewController:loading animated:YES completion:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for (;;) {
                DDLogDebug(@"A");
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                if (requestArray.count <= 0) {
                    DDLogDebug(@"RESET EXIT");
                    dispatch_semaphore_signal(semaphore);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [loading dismissViewControllerAnimated:YES completion:nil];
                    });
                    break;
                }
                RRTNetworkRSSRequestEntity *request = [requestArray firstObject];
                [request GET:^(RRTNetworkResponseEntity *entity) {
                    DDLogDebug(@"B");
                    // Perse → save → Next
                    NSDictionary *dict = entity.object;
                    
                    DDLogDebug(@"request : %@", dict);
                    // saveObj
                    // タイトル
                    NSString *title = [availableTitle firstObject];
                    if (title == nil || title.length == 0) {
                        title = [dict objectForKey:kRSSRequestEntityKeyTitle];
                        if (title == nil || title.length == 0) {
                            title = @"未設定";
                        }
                    }
                    NSString *rssVersion = [dict objectForKey:kRSSRequestEntityKeyRSSVersion];
                    
                    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                        // save
                        RSSFeedEntity *feed = [RSSFeedEntity MR_createEntityInContext:localContext];
                        [feed setupNextPrimaryKey];
                        feed.title = title;
                        feed.rssVersion = rssVersion;
                        feed.url = [dict objectForKey:kRSSRequestEntityKeyURL];
                        feed.favicon = [dict objectForKey:kRSSRequestEntityKeyFavicon];
                        
                    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                        DDLogDebug(@"Coredata result %@, Error : %@", (contextDidSave ? @"SAVE" : @"DON'T SAVE"), [error description]);
                        // dissmiss & back
                        [requestArray removeObject:request];
                        if (availableTitle.count > 0) {
                            [availableTitle removeObjectAtIndex:0];
                        }
                        dispatch_semaphore_signal(semaphore);
                    }];
                } failed:^(RRTNetworkErrorEntity *entity) {
                    DDLogDebug(@"C");
                    // Next
                    [requestArray removeObject:request];
                    if (availableTitle.count > 0) {
                        [availableTitle removeObjectAtIndex:0];
                    }
                    dispatch_semaphore_signal(semaphore);
                }];
            }
            DDLogDebug(@"D");
        });
    }];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.visibleArray objectAtIndex:section] header];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [[self.visibleArray objectAtIndex:section] footer];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.visibleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.visibleArray objectAtIndex:section] paramters] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    RRTSettingPair *pair = [[[self.visibleArray objectAtIndex:indexPath.section] paramters] objectAtIndex:indexPath.row];
    [cell.textLabel setText:pair.paramter];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RRTSettingPair *pair = [[[self.visibleArray objectAtIndex:indexPath.section] paramters] objectAtIndex:indexPath.row];
    [pair perform];
}

@end
