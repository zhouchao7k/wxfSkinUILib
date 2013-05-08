package org.oswxf.skinui.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import org.oswxf.skinui.events.BundlerEvent;
	import org.oswxf.skinui.events.ViewBlockEvent;

	public class BaseViewMediator
	{
		public function BaseViewMediator()
		{
		}
		
		/**
		 *  默认下载用的事件监听
		 */		
		static public var DEFAULT_DOWNLOADER_EVENTDISPATCHER:EventDispatcher = new EventDispatcher()
		/**
		 * 下载bundler所用的下载机制的eventdispatcher 
		 */
		protected var bundlerDownloaderEd:EventDispatcher = null;
		
		/**
		 * 被映射的view 
		 */
		private var _mapedView:Array = [];
		
		/**
		 * 映射View
		 * 指定需要映射的Class，会找到特定的内部对象，然后赋值
		 * @param $view
		 * 
		 */
		protected function mapView($view:Class):void
		{
			var viewname:String = flash.utils.getQualifiedClassName($view);
			var obj:XML = flash.utils.describeType(this);
			var target:XMLList= obj.variable.(@type == viewname);
			for each(var item:XML in target)
			{
				var propName:String = item.@name;
				if(this[propName]==null){
					this[propName] = new $view();
					_mapedView.push(this[propName]);
					trace(this[propName],'maped');
					BaseViewblock(this[propName]).addEventListener(ViewBlockEvent.CREATED,onViewBlockCreation); 
					addMapedEvent(BaseViewblock(this[propName]));
				}
			}
		}
		
		private static var _stMapedViewEvent:Dictionary = new Dictionary();
		public static function mappStaticEvent($eventType:String,$eventHandler:Function):void
		{
			if(_stMapedViewEvent[$eventType]!=null)
				throw new Error('不要重复添加MappingEvent');
			_stMapedViewEvent[$eventType] = $eventHandler;
		}
		
		private var _mapViewEventStorage:Dictionary = new Dictionary();
		
		/**
		 * 映射 事件
		 * 需要在 mapView() 函数之前调用
		 * @param $eventType
		 * @param $eventHandler
		 * 
		 */
		protected function mappingEvent($eventType:String , $eventHandler:Function):void
		{
			if(_mapViewEventStorage[$eventType]!=null)
				throw new Error('不要重复添加MappingEvent');
			_mapViewEventStorage[$eventType]=$eventHandler;
		}
		
		
		/**
		 * 为viewblock 增加映射的Event 
		 * @param $bvb
		 * 
		 */
		private function addMapedEvent($bvb:EventDispatcher):void
		{
			for(var type:String in _mapViewEventStorage)
			{
				$bvb.addEventListener(type,onMappedEventHandler);
			}
			for(var type2:String in _stMapedViewEvent)
			{
				$bvb.addEventListener(type2,onMappedEventHandler);
			}
		}
		
		/**
		 * 触发Mapped Event 
		 * @param event
		 * 
		 */
		protected function onMappedEventHandler(event:Event):void
		{
			for(var type:String in _mapViewEventStorage)
			{
				if(type == event.type)
				{
					_mapViewEventStorage[type].apply(null,[event]);
					return;
				}
			}
			
			for(var type2:String in _stMapedViewEvent)
			{
				if(type2 == event.type)
				{
					_stMapedViewEvent[type2].apply(null,[event]);
					return;
				}
			}
			
		}		
		
		private function onViewBlockCreation(event:Event):void
		{
			trace(event.currentTarget,'onCreation');
			BaseViewblock(event.currentTarget).removeEventListener(ViewBlockEvent.CREATED,onViewBlockCreation);
			checkAllMapedViewCompleted();
		}
		
		protected function debugGetAllMapedViewCompletedInfo():String
		{
			
			var result:String='>>Start=================\n'
			for each(var iv:BaseViewblock in _mapedView)
			{
				var st:String = flash.utils.getQualifiedClassName(iv);
				st += '..created:'+ iv.isCreationCompleted +"\n"; 
				result +=st;
			}
			return result;
		}
		
		/**
		 * 检查是否所有Maped View 全部CreationComplete 
		 * 
		 */
		private function checkAllMapedViewCompleted():void
		{
			var isAllViewCreationComplete:Boolean = true;
			for each(var iv:BaseViewblock in _mapedView)
			{
				if(!iv.isCreationCompleted)
				{
					isAllViewCreationComplete=false;
					break;
				}
			}
			_isViewCreated = isAllViewCreationComplete;
			if(isAllViewCreationComplete)
			{
				mapViewEvent();
				runAysnLogicaQueue();
				viewCreated()
			}
		}
		private var _isViewCreated:Boolean = false;

		public function get isViewCreated():Boolean
		{
			return _isViewCreated;
		}
		
		
		
		internal function isThisVBRelatto($vb:DisplayObjectContainer,$item:DisplayObject):Boolean
		{
			if($item.parent == null)
				return false;
			if($item.parent == $vb|| $item == $vb)
				return true;
			if($item.parent != $vb)
				return isThisVBRelatto($vb,$item.parent);
			return false;
		}
		
	
		private var _isStarted:Boolean = false;
		
		public function get isStarted():Boolean
		{
			return _isStarted;
		}
		/**
		 * 启动 Mediator 
		 * 
		 */
		public function startup():void
		{
			_isStarted = true;
			// TODO Auto Generated method stub
			var nbl:Array = [];
			for each(var iv:BaseViewblock in _mapedView)
			{
				if(!iv.isStarted){ 
					iv.start();
					nbl = nbl.concat(iv.getNeedBundlerList());
				}
			}
			
			dispatchNbl(nbl);
						
		}
		
		/**
		 * 发送需要下载的列表 
		 * @param $nbl
		 * 
		 */
		private function dispatchNbl($nbl:Array):void
		{
			if($nbl.length==0)
				return;
			var post:Array = [];
			$nbl.sort();
			post.push($nbl.shift());
			while($nbl.length>0)
			{
				var item:String= $nbl.shift();
				if(item!= post[post.length-1])
					post.push(item);
			}
			var event:BundlerEvent = new BundlerEvent(BundlerEvent.MISS,post);
			if(bundlerDownloaderEd!=null)
				bundlerDownloaderEd.dispatchEvent(event);
			else
				DEFAULT_DOWNLOADER_EVENTDISPATCHER.dispatchEvent(event);
		}
		
		private var _asyncLogicalQueue:Array = [];
		

		/**
		 * 异步调用函数 
		 * @param args
		 * @return 
		 * 
		 */
		protected function runAysnLogica(...args):Boolean
		{
			var isAsync:Boolean = !_isViewCreated;
			if(isAsync)
			{
				_asyncLogicalQueue.push(args);
			}
			return isAsync;
		}
		
		/**
		 *  处理异步逻辑队列
		 *  
		 */
		private function runAysnLogicaQueue():void
		{
			while(_asyncLogicalQueue.length>0)
			{
				var item:Array = _asyncLogicalQueue.shift();
				var fun:Function = item.shift();
				fun.apply(this,item);
			}
		}
		

		/**
		 * View 创建完成调用的函数
		 * 需要被上级override
		 * 
		 */
		protected function  viewCreated():void
		{
			trace('viewblock created!');
		}
		
		/**
		 *  
		 * 
		 */
		protected function mapViewEvent():void
		{
			trace('do map view event');
		}
		
	}
}