# EmoticonView
表情键盘&amp;图文混排，支持Emoji。使用CoreData进行最近表情缓存。

# 文件概览：
## Controller
### WBComposeViewController
支持图文混排的控制器：包括文本编辑视图、底部工具栏、表情输入视图的加载及切换表情键盘的控制。

## View
### WBComposeTextView
文本编辑视图，实现了将表情属性图片转换为纯文本字符串及向文本视图插入表情符号。

## Model
存放表情键盘的“最近表情” CoreData 模型。  
注意：CoreData添加模型文件时，有可能编译不通过，需要到Build Phases->Complile Sources 看里面有没有 .xcdatamodeld文件参与编译，如果有，删除。

## Tools 
### CoreDataManager
CoreData管理类，对CoreData进行封装，使兼容低版本，包括自动合并多个Model文件。

### Additions
NSString+CZEmoji：将Emoji编码转换为Unicode字符串的工具类。
UIView+CZAddition： UIView的一些便利方法封装。

### Emoticon
表情键盘的具体实现。主要是使用UICollectionView实现表情布局，同时使用长按手势实现Pop动画。详情看代码注释。

## 效果图
![image](https://github.com/HONG321/EmoticonView/blob/master/EmoticonView/EmoticonView/ScreenShot/表情键盘.gif)



