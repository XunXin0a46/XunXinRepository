//
//  NHAlignmentFlowLayout.m
//  Hukkster
//
//  Created by Nils Hayat on 7/1/13.
//  Copyright (c) 2013 Hukkster. All rights reserved.
//

#import "NHAlignmentFlowLayout.h"

@implementation NHAlignmentFlowLayout

///返回指定矩形中所有单元格和视图的布局属性，子类必须重写此方法
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = nil;
    @try {
        array = [super layoutAttributesForElementsInRect:rect];
    } @catch (NSException *exception) {
        NSLog(@"[layoutAttributesForElementsInRect:] falied, exception:%@", exception);
        return array;
    }
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        //如果目标视图的特定于布局的标识符为nil
        if (attributes.representedElementKind == nil) {
            NSIndexPath *indexPath = attributes.indexPath;
            //返回项目在指定索引路径上的布局属性
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return array;
}

///返回项目在指定索引路径上的布局属性，子类必须重写此方法
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath {
    //管理集合视图中给定项的布局相关属性的布局对象
    UICollectionViewLayoutAttributes *attributes;
    //判断集合视图项的对齐方式
    switch (self.alignment) {
        // 顶部或左侧对齐
        case NHAlignmentTopLeftAligned:{
            //滚动方向为垂直滚动方向
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                //返回索引路径处项目左对齐的布局属性
                attributes = [self layoutAttributesForLeftAlignmentForItemAtIndexPath:indexPath];
            } else {
                //返回索引路径处项目顶部对齐的布局属性
                attributes = [self layoutAttributesForTopAlignmentForItemAtIndexPath:indexPath];
            }
            break;
        }
        case NHAlignmentBottomRightAligned:{
            //滚动方向为垂直滚动方向
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                //返回项在索引路径中右对齐的布局属性
                attributes = [self layoutAttributesForRightAlignmentForItemAtIndexPath:indexPath];
            } else {
                //项目索引路径的底部对齐的布局属性
                attributes = [self layoutAttributesForBottomAlignmentForItemAtIndexPath:indexPath];
            }
            break;
        }
            
        case NHAlignmentTopCaterGoryLeftAligned:{
            //滚动方向为垂直滚动方向
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                //索引路径项的固定范围的左对齐的布局属性
                attributes = [self layoutAttributesForCatGoryLeftAlignmentForItemAtIndexPath:indexPath];
            } else {
                //返回索引路径处项目顶部对齐的布局属性
                attributes = [self layoutAttributesForTopAlignmentForItemAtIndexPath:indexPath];
            }
            break;
        }
        default:
            attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
            break;
    }

    return attributes;
}

///返回索引路径处项目左对齐的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForLeftAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath {
    //返回项在指定索引路径上的布局属性
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    //项的边框矩形
    CGRect frame = attributes.frame;
    //如果项的边框矩形的原点X轴坐标小于节中布局内容的左边距
    if (attributes.frame.origin.x < self.sectionInset.left) {
        //返回布局属性对象实例
        return attributes;
    }
    //如果节中布局内容是第一个项
    if (indexPath.item == 0) {
        //设置项的边框矩形的原点X轴坐标为节中布局内容的左边距
        frame.origin.x = self.sectionInset.left;
        
    } else {
        //获得每节中项的上一索引路径对象
        NSIndexPath *previousIndexPath =
        [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
        //获得每节中项的上一索引路径处的布局属性对象
        UICollectionViewLayoutAttributes *previousAttributes =
        [self layoutAttributesForItemAtIndexPath:previousIndexPath];
        //如果当前的索引路径处的布局属性对象的边框矩形的原点Y轴坐标大于上一索引路径处的布局属性对象的原点Y轴坐标
        if (attributes.frame.origin.y > previousAttributes.frame.origin.y) {
            //设置项的边框矩形的原点X轴坐标为节中布局内容的左边距（说明一行展示不下，换行了）
            frame.origin.x = self.sectionInset.left;
        } else {
            //设置项的边框矩形的原点X轴坐标为上一索引路径处的布局属性对象的原点X轴最大坐标加同一行中的项之间使用的最小间距
            frame.origin.x = CGRectGetMaxX (previousAttributes.frame) + self.minimumInteritemSpacing;
        }
    }
    //设置当前项布局属性的边框矩形
    attributes.frame = frame;
    //返回项目在指定索引路径上的布局属性
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForCatGoryLeftAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath {
    //返回项在指定索引路径上的布局属性
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    //项的边框矩形
    CGRect frame = attributes.frame;
    //如果项的布局属性的边框矩形的原点X轴坐标小于节中布局内容的左边距
    if (attributes.frame.origin.x < self.sectionInset.left) {
        //返回布局属性对象实例
        return attributes;
    }
    //如果节中布局内容是第一个项
    if (indexPath.item == 0) {
        //设置项的边框矩形的原点X轴坐标为节中布局内容的左边距加10
        frame.origin.x = self.sectionInset.left + 10;
        
    } else {
        //获得每节中项的上一索引路径对象
        NSIndexPath *previousIndexPath =
            [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
        //获得每节中项的上一索引路径处的布局属性对象
        UICollectionViewLayoutAttributes *previousAttributes =
            [self layoutAttributesForItemAtIndexPath:previousIndexPath];
        //如果当前的索引路径处的布局属性对象的边框矩形的原点Y轴坐标大于上一索引路径处的布局属性对象的原点Y轴坐标
        if (attributes.frame.origin.y > previousAttributes.frame.origin.y) {
            //设置项的边框矩形的原点X轴坐标为节中布局内容的左边距加10
            frame.origin.x = self.sectionInset.left + 10;
        } else {
            //设置项的边框矩形的原点X轴坐标为上一索引路径处的布局属性对象的原点X轴最大坐标加12.5
            frame.origin.x = CGRectGetMaxX (previousAttributes.frame) + 12.5;
        }
    }
    //设置当前项布局属性的边框矩形
    attributes.frame = frame;
    //返回项目在指定索引路径上的布局属性
    return attributes;
}

///返回索引路径处项目顶部对齐的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForTopAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath {
    //返回项目在指定索引路径上的布局属性
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    //项的边框矩形
    CGRect frame = attributes.frame;
    //如果项的边框矩形的原点Y轴坐标小于节中布局内容的上边距
    if (attributes.frame.origin.y <= self.sectionInset.top) {
        //返回布局属性对象实例
        return attributes;
    }
    //如果节中布局内容是第一个项
    if (indexPath.item == 0) {
        //设置项的边框矩形的原点Y轴坐标为节中布局内容的顶部边距
        frame.origin.y = self.sectionInset.top;
        
    } else {
        //获得每节中项的上一索引路径对象
        NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
        //获得每节中项的上一索引路径处的布局属性对象
        UICollectionViewLayoutAttributes *previousAttributes = [self layoutAttributesForItemAtIndexPath:previousIndexPath];
        //如果当前的索引路径处的布局属性对象的边框矩形的原点X轴坐标大于上一索引路径处的布局属性对象的原点X轴坐标
        if (attributes.frame.origin.x > previousAttributes.frame.origin.x) {
            //设置项的边框矩形的原点Y轴坐标为节中布局内容的顶部边距（说明一行展示下了，没换行）
            frame.origin.y = self.sectionInset.top;
        } else {
            //设置项的边框矩形的原点Y轴坐标为上一索引路径处的布局属性对象的原点Y轴最大坐标加同一行中的项之间使用的最小间距
            frame.origin.y = CGRectGetMaxY (previousAttributes.frame) + self.minimumInteritemSpacing;
        }
    }
    //设置当前项布局属性的边框矩形
    attributes.frame = frame;
    //返回项目在指定索引路径上的布局属性
    return attributes;
}

///项在索引路径中右对齐的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForRightAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath {
    //返回项目在指定索引路径上的布局属性
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    //项的边框矩形
    CGRect frame = attributes.frame;
    //项的边框矩形的最大X轴坐标大于等于集合视图内容的宽度减去节中布局内容的右边距
    if (CGRectGetMaxX (attributes.frame) >= self.collectionViewContentSize.width - self.sectionInset.right) {
        //返回布局属性对象实例
        return attributes;
    }
    //如果节中布局内容是最后一个项
    if (indexPath.item == [self.collectionView numberOfItemsInSection:indexPath.section] - 1) {
        //设置项的边框矩形的原点X轴坐标为集合视图内容的宽度减去节中布局内容的右边距减去项的的宽度
        frame.origin.x = self.collectionViewContentSize.width - self.sectionInset.right - frame.size.width;
    } else {
        //获得每节中项的下一索引路径对象
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
        //获得每节中项的下一索引路径处的布局属性对象
        UICollectionViewLayoutAttributes *nextAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
        //如果当前的索引路径处的布局属性对象的边框矩形的原点Y轴坐标小于下一索引路径处的布局属性对象的原点Y轴坐标
        if (attributes.frame.origin.y < nextAttributes.frame.origin.y) {
            //设置项的边框矩形的原点X轴坐标为集合视图内容的宽度减去节中布局内容的右边距减去项的的宽度
            frame.origin.x = self.collectionViewContentSize.width - self.sectionInset.right - frame.size.width;
        } else {
            //设置项的边框矩形的原点X轴坐标为下一索引路径处的布局属性对象的原点X轴坐标减去同一行中的项之间使用的最小间距
            //减去当前项的宽度
            frame.origin.x = nextAttributes.frame.origin.x - self.minimumInteritemSpacing - attributes.frame.size.width;
        }
    }
    //设置当前项布局属性的边框矩形
    attributes.frame = frame;
    //回布局属性对象实例
    return attributes;
}

///项目索引路径的底部对齐的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForBottomAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath {
    //返回项目在指定索引路径上的布局属性
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    //项的边框矩形
    CGRect frame = attributes.frame;
    //项的边框矩形的最大Y轴坐标大于等于集合视图内容的高度减去节中布局内容的左边距
    if (CGRectGetMaxY (attributes.frame) >= self.collectionViewContentSize.height - self.sectionInset.left) {
        //返回布局属性对象实例
        return attributes;
    }
    //如果节中布局内容的项索引等于指定节中的项数
    if (indexPath.item == [self.collectionView numberOfItemsInSection:indexPath.section]) {
        //设置项的边框矩形的原点Y轴坐标为集合视图内容的高度减去节中布局内容的底部边距减去项的的高度
        frame.origin.y = self.collectionViewContentSize.height - self.sectionInset.bottom - frame.size.height;
        
    } else {
        //获得每节中项的下一索引路径对象
        NSIndexPath* nextIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
        //获得每节中项的下一索引路径处的布局属性对象
        UICollectionViewLayoutAttributes* nextAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
        //如果当前的索引路径处的布局属性对象的边框矩形的原点X轴坐标小于下一索引路径处的布局属性对象的原点X轴坐标
        if (attributes.frame.origin.x < nextAttributes.frame.origin.x) {
            //设置项的边框矩形的原点Y轴坐标为集合视图内容的高度减去节中布局内容的底部边距减去项的的高度
            frame.origin.y = self.collectionViewContentSize.height - self.sectionInset.bottom - frame.size.height;
        } else {
            //设置项的边框矩形的原点Y轴坐标为下一索引路径处的布局属性对象的原点Y轴坐标减去同一行中的项之间使用的最小间距
            //减去当前项的高度
            frame.origin.y = nextAttributes.frame.origin.y - self.minimumInteritemSpacing - attributes.frame.size.height;
        }
    }
    //设置当前项布局属性的边框矩形
    attributes.frame = frame;
    //回布局属性对象实例
    return attributes;
}

@end
