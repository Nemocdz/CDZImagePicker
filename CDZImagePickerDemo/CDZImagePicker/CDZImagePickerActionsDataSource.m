//
//  CDZImagePickerActionsDataSource.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/24.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import "CDZImagePickerActionsDataSource.h"
#import "CDZImagePickerActionsCell.h"
#import "CDZImagePickerActionsItem.h"
#import "CDZImagePickerActionsSection.h"


@implementation CDZImagePickerActionsDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections ? self.sections.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.sections.count > section){
        CDZImagePickerActionsSection *sectionObject = self.sections[section];
        return sectionObject.items.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDZImagePickerActionsSection *sectionObject = self.sections[indexPath.section];
    CDZImagePickerActionsItem *item = sectionObject.items[indexPath.row];
    CDZImagePickerActionsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CDZImagePickerActionsCell class])];
    if (cell == nil) {
        cell = [[CDZImagePickerActionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CDZImagePickerActionsCell class])];
    }
    [cell setCellFromItem:item];
    return cell;
}



@end
