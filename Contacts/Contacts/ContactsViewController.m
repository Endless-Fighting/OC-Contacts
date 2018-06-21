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
#import "EditInfoViewController.h"
#import "SqliteManager.h"

#import "UseSqlite.h"
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
    
    [UseSqlite openAndCreate];
    
    //[UseSqlite clearContacts];
    
    
    self.contacts = [UseSqlite getAllContacts];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(ClickBtn)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self viewDidLoad];
    }];
}

-(void)ClickBtn{
    EditInfoViewController *infoView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditInfoViewController"];
    [self.navigationController pushViewController:infoView animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)sender
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier: @"1"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:@"1"];
    }
    ContactModel *contact = (ContactModel *)self.contacts[indexPath.row];
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.phoneNo;
    return cell;
}

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section
{
    return [self.contacts count];;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showInfo"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *curName = cell.textLabel.text;
        ((DetailInfoViewController *)segue.destinationViewController).name = curName;
    }
}

//- (void)reloadData; 下拉刷新


@end
