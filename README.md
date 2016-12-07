#<p align=center>CategoryDemo Readme

##一、问题：给分类（category）添加属性
1. 最近遇到一个问题：需要在一个类的Category中添加属性；
2. OC的分类允许给分类添加属性，但不会自动生成getter、setter方法；
3. 可以通过 Category 给一个现有的类添加属性，但是却不能添加实例变量
4. 解决方案：通过runtime建立关联引用；

##二、解决：runtime
###1.引入runtime头文件
```
#import <objc/runtime.h>
```

###2.添加属性
可以在分类（即.m文件）中添加，也可以在分类的头文件（即.h文件）中添加。

```
@interface UIView (EmptyView)

@property (nonatomic, strong) UIButton *hideButton;

@end

```

###3.实现getter、setter
####1).在implementation中添加属性的getter和setter方法。

```
//getter 
- (UIButton *)hideButton {
    UIButton *_hideButton = objc_getAssociatedObject(self, @selector(hideButton));
    if (!_hideButton) {
        _hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hideButton.frame = CGRectMake(self.bounds.size.width/2-110, 260, 220, 44);
        _hideButton.backgroundColor = [UIColor brownColor];
        [_hideButton setTitle:@"Hide" forState:UIControlStateNormal];
        objc_setAssociatedObject(self, @selector(hideButton), _hideButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _hideButton;
}

//setter
- (void)setHideButton:(UIButton *)hideButton {
    objc_setAssociatedObject(self, @selector(hideButton), hideButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

```
####2).在`hideButton`中使用的`objc_getAssociatedOject`方法，Object-C中描述如下:

```
/** 
 * Returns the value associated with a given object for a given key.
 * 
 * @param object The source object for the association.
 * @param key The key for the association.
 * 
 * @return The value associated with the key \e key for \e object.
 * 
 * @see objc_setAssociatedObject
 */
OBJC_EXPORT id objc_getAssociatedObject(id object, const void *key)
    OBJC_AVAILABLE(10.6, 3.1, 9.0, 1.0);

```
- <a href = http://blog.leichunfeng.com/blog/2015/06/26/objective-c-associated-objects-implementation-principle/>这个函数先根据对象地址在 AssociationsHashMap 中查找其对应的 ObjectAssociationMap 对象，如果能找到则进一步根据 key 在 ObjectAssociationMap 对象中查找这个 key 所对应的关联结构 ObjcAssociation ，如果能找到则返回 ObjcAssociation 对象的 value 值，否则返回 nil ；</a>
- 也就是在和self建立了关联引用的所有对象中通过key找到某一个特定的对象，如果有返回该对象的value，否则，返回 nil 。
- `objc_getAssociatedObject`有两个参数，第一个参数为从该`object`中获取关联对象，第二个参数为想要获取关联对象的key；

对于第二个参数`const void *key`,有以下四种推荐的`key`值：

- 声明 `static char kAssociatedObjectKey;` ，使用 `&kAssociatedObjectKey` 作为 `key` 值;
- 声明 `static void *kAssociatedObjectKey = &kAssociatedObjectKey;`，使用 `kAssociatedObjectKey` 作为` key `值；
- 用 `selector` ，使用 `getter` 方法的名称作为`key`值；
- 而使用`_cmd`可以直接使用该`@selector`的名称，即`hideButton`，并且能保证改名称不重复。_(与上一种方法相同)_

####3).在`setHideButton`中使用的`objc_setAssociatedObject`方法，Object-C中描述如下:

```
/** 
 * Sets an associated value for a given object using a given key and association policy.
 * 
 * @param object The source object for the association.
 * @param key The key for the association.
 * @param value The value to associate with the key key for object. Pass nil to clear an existing association.
 * @param policy The policy for the association. For possible values, see “Associative Object Behaviors.”
 * 
 * @see objc_setAssociatedObject
 * @see objc_removeAssociatedObjects
 */
OBJC_EXPORT void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
    OBJC_AVAILABLE(10.6, 3.1, 9.0, 1.0);

```
参数说明：

- `object`和`key`同于`objc_getAssociatedObject`;
- `value`：需要和`object`建立关联引用对象的value；
- `policy`：关联策略，等同于给`property`添加关键字，具体说明如下表关联策略

<center> **关联策略**

|关联策略 |等价属性|说明|
|------|------|------|------|
|OBJC\_ASSOCIATION\_ASSIGN|	@property (assign) or @property (unsafe\_unretained)|	弱引用关联对象|
|OBJC\_ASSOCIATION\_RETAIN_NONATOMIC|	@property (strong, nonatomic)|	强引用关联对象，且为非原子操作|
|OBJC\_ASSOCIATION\_COPY\_NONATOMIC|	@property (copy, nonatomic)|	复制关联对象，且为非原子操作|
|OBJC\_ASSOCIATION\_RETAIN|	@property (strong, atomic)|	强引用关联对象，且为原子操作
|OBJC\_ASSOCIATION\_COPY|	@property (copy, atomic)|	复制关联对象，且为原子操作|
</center>

###4.对添加的属性操作
例如将添加的hideButton属性添加到View中

```
- (void)showHideButton {
	if (!self.hideButton.superview) {
        [self addSubview:self.hideButton];
    }
}

```

## 参考资料
1. <a href = http://blog.leichunfeng.com/blog/2015/06/26/objective-c-associated-objects-implementation-principle/>Objective-C Associated Objects 的实现原理</a>;
2. <a href = http://www.jianshu.com/p/3cbab68fb856>给分类（Category）添加属性</a>;
3. <a href = http://www.jianshu.com/p/535d1574cb86>iOS Category中添加属性和成员变量的区别</a>。
