package org.oswxf.skinui.manager
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import org.oswxf.skinui.SkinUIConst;
	import org.oswxf.skinui.comp.ISkinBootstrapObject;
	import org.oswxf.skinui.comp.ISkinUIComp;
	import org.oswxf.skinui.comp.SkinBootstrapObject;
	import org.oswxf.skinui.events.BundlerEvent;
	import org.oswxf.skinui.impl.BaseViewblock;
	import org.oswxf.skinui.model.SimpleResObjectDefineModel;
	import org.oswxf.skinui.model.SkinUIModelLocator;
	import org.oswxf.skinui.model.ViewBlockModel;
	import org.oswxf.skinui.token.ResourceToken;
	import org.oswxf.skinui.vo.ComponentViewObjectDefinetionVO;
	import org.oswxf.skinui.vo.SimpleResObject;
	import org.oswxf.skinui.vo.ViewBlockDefinitionVO;
	import org.oswxf.skinui.vo.ViewObjecDefinetionVO;

	public class ViewBlockInstantiationManager
	{
		public function ViewBlockInstantiationManager()
		{
			init()
		}
		
		static private var _instance:ViewBlockInstantiationManager = null;
		static public function getInstance():ViewBlockInstantiationManager
		{
			if(!_instance)
				_instance = new ViewBlockInstantiationManager();
			return _instance;
		}
		
		private function init():void
		{
			_asyncFactory.addEventListener(Event.CHANGE,onAsyncFactoryChanged);
		}
		

		/**
		 * 异步工厂 
		 */
		private var _asyncFactory:AsyncRecycleFactory = new AsyncRecycleFactory();
		
		
		private var _delayCheckVBVO:Dictionary = new Dictionary();
		
		public function getReadyForViewBlock($vbo:ViewBlockDefinitionVO, $bundlerDownloaderEd:EventDispatcher):ResourceToken
		{
			var token:ResourceToken = new ResourceToken();
			token.data = $vbo;
			_delayCheckVBVO[$vbo.namespace] = token;
			var needBundlerList:Array = getNeedBundlerList($vbo);
			if(needBundlerList.length>0)
			{
				var event:BundlerEvent = new BundlerEvent(BundlerEvent.MISS,needBundlerList);
				$bundlerDownloaderEd.dispatchEvent(event);
			}else{
				flash.utils.setTimeout(checkAllDelayVBVO,20)
			}
			
			return token;
		}
		
		internal function checkAllDelayVBVO():void
		{
			for (var key:String in _delayCheckVBVO)
			{
				var token:ResourceToken = _delayCheckVBVO[key];
				var vo:ViewBlockDefinitionVO =	token.data;
				if(getNeedBundlerList(vo).length==0)
				{
					token.dispatchEvent(new Event(Event.COMPLETE));
					_delayCheckVBVO[key] = null;
					delete _delayCheckVBVO[key] 
				}
			}
		}
		
		
		internal function sortResDefinelis(a:ViewObjecDefinetionVO,b:ViewObjecDefinetionVO):int
		{
			if(a.layer<b.layer)
				return -1;
			if(a.layer>b.layer)
				return 1;
			return 0;
		}
		
		/**
		 * viewblock 实例化下级属性内容 

		 * @param $vb
		 * @param $ns
		 * 
		 */
		public function viewBlockCration($vb:BaseViewblock,$ns:String):void
		{
			
			var vbdvo:ViewBlockDefinitionVO = getViewBlockDefine($ns);
			var boots:Dictionary = new Dictionary();
			for each(var citem:ViewObjecDefinetionVO in vbdvo.resDefinelis)
			{
				if(citem.isRefObject){
					var obj:ISkinBootstrapObject= getBootstrapObj(citem);
					boots[citem.name] = obj;
				}
			}
			
			vbdvo.resDefinelis.sort(sortResDefinelis);
			
			for each(var item:ViewObjecDefinetionVO in vbdvo.resDefinelis)
			{
				if(item.isRefObject)
					break;
				var resModel:SimpleResObjectDefineModel =SkinUIModelLocator.simpelResModel;
				var resObj:SimpleResObject = resModel.getRes(item.uid);
				var dspObj:DisplayObject  = null;
				switch(resObj.type)
				{
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_BMP:
						dspObj = generateBmpObj(item);
						break;
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_BTN:
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_MOVIECLIP:
						dspObj  = generateObj(item);
						break;
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_PLACEHOLDER:
						dspObj = generatePLACEHOLDER(item);
						break;
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_VIEWBLOCK:
						dspObj = generateVB(item,$vb);
						break;
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_COMPONENT:
						dspObj = generateCOMP(item as ComponentViewObjectDefinetionVO);
						for (var key:String in ComponentViewObjectDefinetionVO(item).refList)
						{
							var refid:String = ComponentViewObjectDefinetionVO(item).refList[key];
							var refobj:ISkinBootstrapObject = boots[refid];
							ISkinUIComp(dspObj).setBootstrapObj(key,refobj);
						}
						break;
				}
				
				$vb[item.name] = dspObj;
				$vb.addChild(dspObj);
			}
			
		}
		
		/**
		 * 根据显示对象定义VO获取 自举对象 
		 * @param $ctime
		 * @return 
		 * 
		 */		
		internal function getBootstrapObj($ctime:ViewObjecDefinetionVO):SkinBootstrapObject
		{
			var obj:SkinBootstrapObject = new SkinBootstrapObject();
			var resModel:SimpleResObjectDefineModel =SkinUIModelLocator.simpelResModel;
			var resObj:SimpleResObject = resModel.getRes($ctime.uid);
			var objClass:Class = null;
			var tk:ResourceToken =null;
			var skinClass:Dictionary = null;
			switch(resObj.type)
			{
				case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_BMP:
				case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_MOVIECLIP:
				case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_BTN:
					tk = _asyncFactory.getRefClass($ctime.uid);
					if(tk.data==null){
						throw new Error("Class not Exist!");
					}
					objClass= tk.data;
					break;
				case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_VIEWBLOCK:
					objClass = flash.utils.getDefinitionByName($ctime.dynamic_props['nameSpace']) as Class;
					break;
				case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_COMPONENT:
					objClass = flash.utils.getDefinitionByName(ComponentViewObjectDefinetionVO($ctime).component_classRef) as Class;
					skinClass =new Dictionary();
					for (var skinName:String in ComponentViewObjectDefinetionVO($ctime).skinList)
					{
						tk= _asyncFactory.getRefClass(ComponentViewObjectDefinetionVO($ctime).skinList[skinName]);
						if(tk.data==null)
						{
							throw new Error("Class not Exist!");
						}
						var tmpSkinClass:Class = tk.data;
						obj.setSkinClasses(skinName,tmpSkinClass); 
					}
					break;
				case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_PLACEHOLDER:
				default:
					throw new Error('不被支持的引用格式')
			}
			obj.setObjClass(objClass);
			return obj;
		}
		
		private var _sm:StyleManager = StyleManager.getInstance();
		private var _smObj:Object = null;
		
		internal function parseCompVOByStyle(citem:ComponentViewObjectDefinetionVO):ComponentViewObjectDefinetionVO
		{
			if(citem.useStyle==false || citem.styleName=="")
				return citem;
			var styleName:String = citem.styleName
			if(!_smObj)
				_smObj=_sm.getStyleDefine();	
			var citemName:String = getLastClassName(citem.component_classRef);
			var sytleObj:Object = _smObj[citemName];
			if(!sytleObj)
				throw new Error(citem.component_classRef+", is not exist in style sheet!");
			var styleNameObj:Object = sytleObj[styleName];
			if(!styleNameObj)
				throw new Error(citem.component_classRef+"'s define called "+ styleName+", is note exist in style sheet！");
			
			var propObj:Object = styleNameObj['prop'];
			var skinObj:Object = styleNameObj['skin'];
			
			for(var key:String in skinObj)
			{
				citem.skinList[key] = skinObj[key];
			}
			
			for (var pkey:String in propObj)
			{
				citem.compProps[pkey] = propObj[pkey];
			}
			return citem;
		}
		
		private function getLastClassName(className:String):String
		{
			var cls:Array = className.split(".");
			var lst:int = (cls.length == 0)? 0:(cls.length-1);
			var clName:String = cls[lst];
			return clName.toLowerCase();
		}
		
		/**
		 * 创建组件对象 
		 * @param item
		 * @return 
		 * 
		 */
		internal function generateCOMP(item:ComponentViewObjectDefinetionVO):DisplayObject
		{
			item = parseCompVOByStyle(item)		
			var result:ISkinUIComp = null;
			var cls:Class = flash.utils.getDefinitionByName(item.component_classRef) as Class;
			result = new cls();
			
			for (var skinName:String in item.skinList)
			{
				var tk:ResourceToken = _asyncFactory.getRefClass(item.skinList[skinName]);
				if(tk.data==null)
				{
					throw new Error("Class not Exist!");
				}
				var obj:Class = tk.data;
				result.setClass(skinName,obj); 
			}
			
			for (var propName:String in item.compProps)
			{
				result.setProps(propName,item.compProps[propName]); 
			}
			
			
			result.creation();
			
			for (var key:String in item.dynamic_props)
			{
				if(key in result)
					result[key] = item.dynamic_props[key];
			}
			
			return result as DisplayObject;
		}
		
		/**
		 * 创建viewBlock 显示对象 
		 * @param $item
		 * @param $parent
		 * @return 
		 * 
		 */
		internal function generateVB($item:ViewObjecDefinetionVO,$parent:BaseViewblock):BaseViewblock
		{
			var name:String = $item.name;
			var obj:XML = flash.utils.describeType($parent);
			var target:XMLList= obj.variable
			for each(var item:XML in target)
			{
				var propName:String = item.@name;
				if(propName == name)
				{
					var type:String = item.@type;
					var objCls:Class = flash.utils.getDefinitionByName(type) as Class;
					var objVB:BaseViewblock = new objCls();
					for (var key:String in $item.dynamic_props)
					{
						if(key in objVB)
							objVB[key] = $item.dynamic_props[key];
					}
					objVB.start();
					return objVB;
				}
			}
			return null;
		}
		
		/**
		 * 创建占位符 
		 * @param $item
		 * @return 
		 * 
		 */
		internal function generatePLACEHOLDER($item:ViewObjecDefinetionVO):Sprite
		{
			var dsp:Sprite = new Sprite();
			for (var key:String in $item.dynamic_props)
			{
				dsp[key] = $item.dynamic_props[key];
			}
			
			return dsp;
		}
		
		/**
		 * 创建普通的显示对象 
		 * @param $item
		 * @return 
		 * 
		 */
		internal function generateObj($item:ViewObjecDefinetionVO):DisplayObject
		{
			var tk:ResourceToken = _asyncFactory.getRefClass($item.uid);
			if(tk.data==null)
			{
				throw new Error("Class not Exist!");
			}
			var obj:Class = tk.data;
			var dspObj:DisplayObject = new obj();
			for (var key:String in $item.dynamic_props)
			{
				dspObj[key] = $item.dynamic_props[key];
			}
			return dspObj;
		}
		
		/**
		 * 创建Bitmap显示对象 
		 * @param $item
		 * @return 
		 * 
		 */
		internal function generateBmpObj($item:ViewObjecDefinetionVO):DisplayObject
		{
			var tk:ResourceToken = _asyncFactory.getRefClass($item.uid);
			if(tk.data==null)
			{
				throw new Error("Class not Exist!");
			}
			var obj:Class = tk.data;
			var bmd:BitmapData = new obj();
			var dspObj:Bitmap = new Bitmap(bmd);
			
			for (var key:String in $item.dynamic_props)
			{
				dspObj[key] = $item.dynamic_props[key];
			}
			return dspObj;
		}
		
		
		private static var _classRefCount:int = 0;
		/**
		 * 初始化VB，异步获取所有的CLASS
		 * 完成之后，会在VB上抛出INITED事件 
		 * @param $vb
		 * @param $ns
		 * @param $serz
		 * 
		 */
		public function initClassRef($vb:BaseViewblock ,$ns:String , $serz:String):void
		{
			_classRefCount++
			var vbdvo:ViewBlockDefinitionVO = getViewBlockDefine($ns,$serz);
			_vbClassQueue[_classRefCount] = [$ns,$vb];
			checkVBInitQueue();
		}
		
		public function getTheNeedBundlerList($vb:BaseViewblock ,$ns:String , $serz:String):Array
		{
			var vbdvo:ViewBlockDefinitionVO = getViewBlockDefine($ns,$serz);
			var needBundlerList:Array = getNeedBundlerList(vbdvo);
			return needBundlerList;
		}
		
		
		/**
		 * 获取类获取的异步变化 
		 * @param event
		 * 
		 */
		protected function onAsyncFactoryChanged(event:Event):void
		{
			checkVBInitQueue();
			checkAllDelayVBVO();
		}
		
		
		/**
		 * 检查viewblock初始化队列 
		 * 
		 */
		private function checkVBInitQueue():void
		{
			var _initQueue:Array = [];
			for (var time:String in _vbClassQueue)
			{
				var obj:Array = _vbClassQueue[time];
				var ns:String = obj[0];
				var vbdo:ViewBlockDefinitionVO = SkinUIModelLocator.viewBlockModel.getViewBlock(ns);
				var isVBOK:Boolean = true;
				
				for each(var item:ViewObjecDefinetionVO in vbdo.resDefinelis)
				{
					var resModel:SimpleResObjectDefineModel =SkinUIModelLocator.simpelResModel;
					var resObj:SimpleResObject = resModel.getRes(item.uid);
					switch(resObj.type)
					{
						case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_BMP:
						case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_BTN:
						case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_MOVIECLIP:
							if(_asyncFactory.getRefClass(item.uid).data==null)
							{
								isVBOK=false;
							}
							break;
						case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_PLACEHOLDER:
						case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_VIEWBLOCK:
							break;
						case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_COMPONENT:
							for each(var skinid:String in (item as ComponentViewObjectDefinetionVO).skinList)
							{
								if(_asyncFactory.getRefClass(skinid).data==null)
								{
									isVBOK=false;
								}
							}
							break;
					}
				}
				if(isVBOK)
				{
					var vb:BaseViewblock = obj[1];
					trace(vb,time);
					_vbClassQueue[time]=null;
					delete _vbClassQueue[time];
					vb.completeInitlialzed();
				}
			}
		}
		
		
		
		/**
		 *队列 
		 */
		private var _vbClassQueue:Dictionary = new Dictionary();
		
		
		/**
		 * 获取某个vb定义对象所需要的资源包URI列表 
		 * @param $vbdvo
		 * @return 
		 * 
		 */
		private function getNeedBundlerList($vbdvo:ViewBlockDefinitionVO):Array
		{
			var bundlerList:Array = [];
			var resModel:SimpleResObjectDefineModel = SkinUIModelLocator.simpelResModel;
			var tmp:Object = {};
			
			for each (var item:ViewObjecDefinetionVO in $vbdvo.resDefinelis)
			{
				switch(resModel.getRes(item.uid).type)
				{
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_BMP:
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_BTN:
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_MOVIECLIP:
						tmp [resModel.getRes(item.uid).uri.split('@')[1] ] = 1;
						break;
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_PLACEHOLDER:
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_VIEWBLOCK:
						break;
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_COMPONENT:
						var citem:ComponentViewObjectDefinetionVO = item as ComponentViewObjectDefinetionVO;
						citem = parseCompVOByStyle(citem);
						for each(var skinid:String in (citem as ComponentViewObjectDefinetionVO).skinList)
						{
							if(_asyncFactory.getRefClass(skinid).data==null)
							{
								tmp [resModel.getRes(skinid).uri.split('@')[1] ] = 1;
							}
						}
						break;
				}
			}
			var result:Array = []
			for (var key:String in tmp)
			{
				if(!SkinUIModelLocator.bundlerModel.isBundlerDataExist(key))
					result.push(key);
			}
			return result;
		}
		
		
		
		
		
		/**
		 * 根据 命名空间 或者 序列化文本 获取 显示块定义对象  
		 * @param $ns
		 * @param $serz
		 * @return 
		 * 
		 */
		private function getViewBlockDefine($ns:String,$serz:String = null):ViewBlockDefinitionVO
		{
			var vbm:ViewBlockModel = SkinUIModelLocator.viewBlockModel;
			var result:ViewBlockDefinitionVO = null;
			if(!vbm.isNSExist($ns))
			{
				vbm.setSerialize($serz);				
			}
			result= vbm.getViewBlock($ns);
			return result;
		}

		
		
				
	}
}