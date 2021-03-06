//
//  ServerSettingsDropboxViewController
//  NAStify
//
//  Created by Sylver Bruneau.
//  Copyright (c) 2013 CodeIsALie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextCell.h"
#import "SwitchCell.h"
#import "UserAccount.h"

@interface ServerSettingsDropboxViewController : UITableViewController<UITextFieldDelegate, UIAlertViewDelegate>
{
    @private
    UserAccount * userAccount;
    NSInteger    accountIndex;
    
    TextCell * textCellProfile;
}

@property(nonatomic, copy) UserAccount * userAccount;
@property(nonatomic, strong) TextCell * textCellProfile;
@property(nonatomic) NSInteger    accountIndex;

@property(nonatomic, strong) id currentFirstResponder;

- (id)initWithStyle:(UITableViewStyle)style andAccount:(UserAccount *)account andIndex:(NSInteger)index;

@end
