

版本
----------------------
* v0.24
	* 导入as3corelib，实现json解析，放弃使用flashplayer内部的json解析
* v0.23
	* 实现了一个StyleManager ，管理、使用，以及生成CSS文件，来处理所有的组件对象
* v0.22.1
	* 修正一个在不同版本的player 出现的bug
* v0.22
	* BaseViewMediator 增加了一个isStarted的监听
* v0.21
	* BaseViewMediator的mapView 函数修正一个重复 实例化的bug
	* 修正一个派发事件的bug
* v0.20.2
	* 修正一个小bug
* v0.20.1
	* 修正一个小bug
* v0.20
	* 增加了BaseMediator 里面的	
```
DEFAULT_DOWNLOADER_EVENTDISPATCHER 用来默认发送
	如果 bundlerDownloaderEd ==null 就会从默认走，反则从bundlerDownloaderEd走
```
	* BaseViewBlock 提供了isStarted 获取.
* v0.19

```
/**
 * 发起viewblock 预先下载资源流程 
 * @param $vbo
 * @param $ed
 * @return 
 * 
 */
public function getReadyViewBlockVO($vbo:ViewBlockDefinitionVO,$ed:EventDispatcher):ResourceToken
```

* v0.18.3
	* 实现了ISkinBootstrapObject ,以及修正一些bug
* v0.18.2
	* 修改一个bug，关于bmp创建实例
* v0.18.1
	* 加入对组件需要的skin 的资源判断是否需要下载
* v0.18
```
/**
 * 根据 uid 数组获取class
 * 完成之后返回complete
 * @param $uidArr
 * @return 
 * 
 */
function getResList($uidArr:Array ):ResourceToken
```

* v0.17.1
	* 修正一个存入viewblock的bug
* v0.17
	* 实现了完整的组件生成、反射支持
	* 实现了完整的代码生成支持
	* 实现了基础的viewblock <-> mediator 实现交互机制（这部分不包括在swc里面）

* v0.16.2
	* ComponentViewObjectDefinetionVO
* v0.16
	* 简单实现了ViewBlock代码生成
* v0.15.3
	* ViewBlockDefinitionVO -> lastChange 修改成Number
* v0.15.2
 	* 重构了部分代码
* v0.15.1
	* ViewObjecDefinetionVO
	* name属性
* v0.15

	* setViewBlock($vb:ViewBlockDefinitionVO):void
	* delViewBlock($ns:String):void
	* getViewBlock($ns:String):ViewBlockDefinitionVO
	* getViewBlockNSList():Vector.<String>
	有待实现
	* outputViewBlockGeneratedCodeFile($ns:String):String
* v0.14.2
* 提供若干功能函数的原型
* 会在0.15里面更新所有功能
```
/**
 * 存入viewblock 对象
 * @param $ns  namespcae
 * @param $vb  
 * 
 */
setViewBlock($vb:ViewBlockDefinitionVO):void

/**
 * 删除view block 对象 
 * @param $ns
 * 
 */
delViewBlock($ns:String):void

/**
 * 根据 viewblock 的ns获取对象 
 * @param $ns namespace
 * @return 
 * 
 */
getViewBlock($ns:String):ViewBlockDefinitionVO

/**
 * 获取当前管理的viewblock 对象的所有ns 
 * @return 
 * 
 */
getViewBlockNSList():Vector.<String>

/**
 * 输出生成代码 
 * @param $ns
 * @return 
 * 
 */
outputViewBlockGeneratedCodeFile($ns:String):String
```

* v0.14
	* 提供了SkinUIManager 函数
	*  根据UID获取类实例这是一个异步方法getResDefinitionByUID

* v0.13
	* 提供了SkinUIManager 函数
	*  根据Bundler的URI获取相关的RES列表getResListByBundlerURI
	*  导入资源配置JSON串initResConfig 

* v0.12 
 	提供了SkinUIManager 单例实现，以及两个函数
	* 获取资源包列表 
	getBundlerList():Vector.<ResBundlerObject>
	* 存入资源包数据 
	setBundler($uri:String,$bytes:ByteArray):Boolean