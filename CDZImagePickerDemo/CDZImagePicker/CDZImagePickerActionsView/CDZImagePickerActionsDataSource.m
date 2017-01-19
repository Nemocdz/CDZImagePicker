//
//  CDZImagePickerActionsDataSource.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/24.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import "CDZImagePickerActionsDataSource.h"
#import "CDZImagePickerActionsCell.h"

@implementation CDZImagePickerActionsDataSource

#pragma mark - tableViewDataSourceRequried

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDZImagePickerActionsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CDZImagePickerActionsCell class])];
    if (!cell) {
        cell = [[CDZImagePickerActionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CDZImagePickerActionsCell class])];
    }
    cell.item = self.itemArray[indexPath.row];
    return cell;
}


@end
