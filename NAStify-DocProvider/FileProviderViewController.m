//
//  FileProviderViewController.m
//  NAStify
//
//  Created by Sylver Bruneau.
//  Copyright (c) 2014 CodeIsALie. All rights reserved.
//

#import "FileProviderViewController.h"
#import "UserAccount.h"
#import "FileItem.h"
#import "FileProviderBrowserViewController.h"
#import "ServerCell.h"
#import "SSKeychain.h"

@interface FileProviderViewController ()
@end

@implementation FileProviderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.sylver.NAStify"];
    NSData * accountsData = [defaults objectForKey:@"accounts"];
    if (!accountsData)
    {
        self.accounts = [[NSMutableArray alloc] init];
    }
    else
    {
        self.accounts = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:accountsData]];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Hide toolbar & Navigation bar
    [self.navigationController setToolbarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section)
    {
        case 0: // Local
        {
            rows = 1;
            break;
        }
        case 1: // Servers
        {
            rows = [self.accounts count];
            break;
        }
        default:
        {
            break;
        }
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)atableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = nil;
    switch (section)
    {
        case 0:
        {
            sectionName = NSLocalizedString(@"Local",nil);
            break;
        }
        case 1:
        {
            sectionName = NSLocalizedString(@"Servers",nil);
            break;
        }
        default:
            break;
    }
    return sectionName;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ServerCellIdentifier = @"ServerCell";
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            ServerCell *serverCell = (ServerCell *)[tableView dequeueReusableCellWithIdentifier:ServerCellIdentifier];
            if (serverCell == nil)
            {
                serverCell = [[ServerCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:ServerCellIdentifier];
            }
            
            // Configure the cell...
            serverCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
            serverCell.showsReorderControl = YES;
            UserAccount *localAccount = [[UserAccount alloc] init];
            localAccount.serverType = SERVER_TYPE_LOCAL;
            [serverCell setAccount:localAccount];
            
            serverCell.serverLabel.text = NSLocalizedString(@"Local Files",nil);
            cell = serverCell;
            break;
        }
        case 1:
        {
            ServerCell *serverCell = (ServerCell *)[tableView dequeueReusableCellWithIdentifier:ServerCellIdentifier];
            if (serverCell == nil)
            {
                serverCell = [[ServerCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:ServerCellIdentifier];
            }
            
            // Configure the cell...
            serverCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
            serverCell.showsReorderControl = YES;
            [serverCell setAccount:[self.accounts objectAtIndex:indexPath.row]];
            cell = serverCell;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    {
        switch (indexPath.section)
        {
            case 0: // Local
            {
                UserAccount *localAccount = [[UserAccount alloc] init];
                localAccount.serverType = SERVER_TYPE_LOCAL;
                
                FileItem *rootFolder = [[FileItem alloc] init];
                rootFolder.isDir = YES;
                rootFolder.path = @"/";
                NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sylver.NAStify"];
                rootFolder.fullPath = [containerURL.path stringByAppendingString:@"/Documents/"];
                
                FileProviderBrowserViewController *fileBrowserViewController = [[FileProviderBrowserViewController alloc] init];
                fileBrowserViewController.delegate = self.delegate;
                fileBrowserViewController.validTypes = self.validTypes;
                fileBrowserViewController.userAccount = localAccount;
                fileBrowserViewController.currentFolder = rootFolder;
                fileBrowserViewController.mode = self.mode;
                fileBrowserViewController.fileURL = self.fileURL;
                
                [self.navigationController pushViewController:fileBrowserViewController animated:YES];
                break;
            }
            case 1: // Servers
            {
                FileItem *rootFolder = [[FileItem alloc] init];
                rootFolder.isDir = YES;
                rootFolder.path = @"/";
                rootFolder.objectIds = [NSArray arrayWithObject:kRootID];
                
                FileProviderBrowserViewController *fileBrowserViewController = [[FileProviderBrowserViewController alloc] init];
                fileBrowserViewController.delegate = self.delegate;
                fileBrowserViewController.validTypes = self.validTypes;
                fileBrowserViewController.userAccount = [self.accounts objectAtIndex:indexPath.row];
                fileBrowserViewController.currentFolder = rootFolder;
                fileBrowserViewController.mode = self.mode;
                fileBrowserViewController.fileURL = self.fileURL;
                
                [self.navigationController pushViewController:fileBrowserViewController animated:YES];
                break;
            }
            default:
                break;
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Orientation management

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inOrientation
{
    return YES;
}

#pragma mark - Memory management

- (void)dealloc
{
}

@end