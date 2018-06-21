//
//  ContactsViewController.m
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/10.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//

#import "MJRefresh.h"

#import "ContactsViewController.h"
#import "DetailInfoViewController.h"
#import "SqliteManager.h"
#import "ContactModel.h"

@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property(nonatomic,strong)SqliteManager * sqliteManager;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super loadView];
    self.tableView.dataSource = self;
    
    self.sqliteManager = [SqliteManager getSqliteManager];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewContact)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchContact)];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.sqliteManager loadContacts];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
}

-(void)addNewContact{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"EditInfoView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)searchContact{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Search" message:@"Type in the name to search" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * name = alert.textFields[0].text;
        [self.sqliteManager selectContactFromWithName:name];
        [self.tableView reloadData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.sqliteManager loadContacts];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier: @"1"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"1"];
    }
    ContactModel * contact = self.sqliteManager.mContacts[indexPath.row];
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.phoneNo;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sqliteManager.mContacts.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactModel * curruentContact = self.sqliteManager.mContacts[indexPath.row];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DetailInfoViewController * detailInfoView = [storyboard instantiateViewControllerWithIdentifier:@"DetailInfoView"];
    detailInfoView.contact = curruentContact;

    [self.navigationController pushViewController:detailInfoView animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.sqliteManager deleteContactFromSqlite:indexPath.row + 1];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}



@end
