//
//  NTESCommonTableViewCell.h
//  NIM
//
//  Created by chris on 15/6/29.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NTESCommonTableRow;

@protocol NTESCommonTableViewCell <NSObject>

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@optional
- (void)refreshData:(NTESCommonTableRow *)rowData tableView:(UITableView *)tableView;

@end
