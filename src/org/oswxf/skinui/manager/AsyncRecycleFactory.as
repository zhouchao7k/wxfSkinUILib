package org.oswxf.skinui.manager
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import org.oswxf.skinui.events.BundlerEvent;
	import org.oswxf.skinui.model.BundlerModel;
	import org.oswxf.skinui.model.SimpleResObjectDefineModel;
	import org.oswxf.skinui.model.SkinUIModelLocator;
	import org.oswxf.skinui.token.ResourceToken;
	import org.oswxf.skinui.vo.SimpleResObject;

	/**
	 * 异步获取工厂 
	 * @author nativeas
	 * 
	 */
	public class AsyncRecycleFactory extends EventDispatcher
	{
		
		/**
		 * 构造函数 
		 * 
		 */
		public function AsyncRecycleFactory()
		{
			BundlerModel.getInstance().addEventListener(BundlerEvent.CHANGE,onBundlerChange);
		}
		
	
		/**
		 * 加载中的bytes 
		 */
		private var _loadingBytes:Dictionary = new Dictionary();
		/**
		 *加载完成的bytes 
		 */
		private var _loadedBytes:Dictionary = new Dictionary();
		
		/**
		 * 资源定义model 
		 */
		private var _resModel:SimpleResObjectDefineModel = SkinUIModelLocator.simpelResModel;
		/**
		 * class Token 存储 
		 */
		private var _classTokens:Dictionary = new Dictionary();
		/**
		 * 类请求队列 
		 */
		private var _classQueue:Dictionary = new Dictionary();
		
		/**
		 * 根据物件UID 获取类定义  
		 * @param $uid
		 * @return 
		 * 
		 */
		public function getRefClass($uid:String):ResourceToken
		{
			var result:ResourceToken  = null;
			if(_classTokens[$uid] ==null)
			{
				_classTokens[$uid]= new ResourceToken();
				
				getResClass($uid);
			}
			result = _classTokens[$uid];
			return result;
		}
		
		
		public function getResClassList($uidArr:Array):ResourceToken
		{
			var resToken:ResourceToken = new ResourceToken();
			resToken.data = new Dictionary();
			var isComp:Boolean = true;
			for each(var uid:String in $uidArr)
			{
				var token:ResourceToken = getRefClass(uid);
				resToken.data[uid] = token
			}
				
			setTimeout(checkResClassToken,40,resToken);
			return resToken;
		}
		
		private function checkResClassToken($token:ResourceToken):void
		{
			var isComplete:Boolean = true;
			for (var key:String in $token.data)
			{
				if($token.data[key] is ResourceToken)
				{
					var tk:ResourceToken = ResourceToken($token.data[key]);
					if(tk.data!=null)
						$token.data[key]=tk.data;
					else
						isComplete=false
				}
			}
			
			if(isComplete)
				$token.dispatchEvent(new Event(Event.COMPLETE));
			else
				setTimeout(checkResClassToken,100,$token);
		}
		
		
		/**
		 * 监听资源包载入信息
		 * 如果资源包数据发生变化，会遍历所有需要实例化返回的类队列 
		 * @param event
		 * 
		 */
		protected function onBundlerChange(event:Event):void
		{
			var tmp:Array = _getClassQueue;
			_getClassQueue=[];
			while(tmp.length>0)
			{
				var uid:String = tmp.shift();
				getResClass(uid);
			}
		}
		
		/**
		 * 
		 */
		private var _getClassQueue:Array = [];
		/**
		 * 
		 * @param $uid
		 * 
		 */
		private function getResClass($uid:String):void
		{
			var sic:SimpleResObject = _resModel.getRes($uid);
			var bundlerUri:String = sic.uri.split("@")[1];
			var ba:ByteArray = BundlerModel.getInstance().getBundler(bundlerUri);
			
			if(!ba)
			{
				_getClassQueue.push($uid);
				
			}else
			{
				var tmp:Array = _classQueue[bundlerUri];
				if(!tmp)
					tmp = [];
				tmp.push($uid);
				_classQueue[bundlerUri] = tmp
				flash.utils.setTimeout(doLoadByte,40,ba,bundlerUri);
			}
		}
		
		private function doLoadByte(ba:ByteArray,bundlerUri:String):void
		{
			if(_loadingBytes[bundlerUri]!=null)
			{
				return ;
			}
			
			if(_loadedBytes[bundlerUri]!=null)
			{
				dispatchClass(bundlerUri);
				return;
			}
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onBinaryLoaded);
			_loadingBytes[bundlerUri] = loader;
			var lc : LoaderContext = new LoaderContext();
			lc.allowCodeImport = true;
			loader.loadBytes(ba,lc);
		}
		
		/**
		 * 二进制数据加载完成 
		 * @param event
		 * 
		 */
		protected function onBinaryLoaded(event:Event):void
		{
			// TODO Auto-generated method stub
			var l:Loader = LoaderInfo(event.currentTarget).loader;
			l.contentLoaderInfo.removeEventListener(Event.COMPLETE,onBinaryLoaded);
			for (var k:String in _loadingBytes)
			{
				if(_loadingBytes[k] == l)
				{
					_loadingBytes[k] = null;
					delete _loadingBytes[k] ;
					_loadedBytes[k] =l;
					dispatchClass(k);
					break;
				}
			}
			
		}
		
		/**
		 * 派发完成事件 
		 * @param bundlerUri
		 * 
		 */
		private function dispatchClass(bundlerUri:String):void
		{
			var l:Loader = _loadedBytes[bundlerUri];
			var tmp:Array = _classQueue[bundlerUri];
			if(!tmp)
				return;
			while(tmp.length>0)
			{
				var uid:String = tmp.shift();
				var sic:SimpleResObject = _resModel.getRes(uid);
				var cls:Class = getClass(sic.uri);
				if(cls==null)
					throw new Error("wxfSkinUILib, AsyncRecycleFacorty Class ,getClass error! Res UID:"+uid+",uri:"+sic.uri+'cause the Error!');
				var token:ResourceToken = _classTokens[uid];
				token.data = cls;
				token.dispatchEvent(new Event(Event.COMPLETE));
				this.dispatchEvent(new Event(Event.CHANGE));
			}
			
		}
		
		/**
		 * 根据物件URI获取类名 
		 * @param itemUri  物件URI 格式为   物件连接名@二进制对象URI
		 * @return 
		 * 
		 */
		private function getClass(itemUri:String):Class
		{
			var linkage:String = itemUri.split("@")[0];
			var bundlerUri:String = itemUri.split("@")[1];
			var bl:Loader = _loadedBytes[bundlerUri];
			return getClassFromLoader(bl,linkage)
		}
		
		/**
		 * 从 Loader 对象里面反射 class 对象 
		 * @param loader  loader对象
		 * @param className 类名
		 * @return  类对象
		 * 
		 */
		internal static function getClassFromLoader(loader : Loader,className : String) : Class 
		{
			try 
			{
				if(loader.contentLoaderInfo.applicationDomain.hasDefinition( className))
				{
					var obj : Object = loader.contentLoaderInfo.applicationDomain.getDefinition( className);
					return Class( obj);
					//return loader.contentLoaderInfo.applicationDomain.getDefinition(className)  as  Class;  		
				}
				else
				{
					trace( "ResourceWarning ,class not found", loader, className);
					return null;
				}
			} catch (e : Error) 
			{
				trace( "ResourceError", e, loader, className);
			}
			return null;
		}
		
		
	}
}