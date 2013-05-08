package org.oswxf.skinui.impl
{
	import flash.display.Sprite;
	
	import org.oswxf.skinui.events.ViewBlockEvent;
	import org.oswxf.skinui.manager.ViewBlockInstantiationManager;

	/**
	 * 实现 skinUI的所有面板素材加载，实例化的功能 
	 * @author nativeas
	 * 
	 * -> workflow
	 * 		1. preinit
	 * 		//used to got the res define
	 * 		2. init
	 * 		// to download bundler file , dispatch the progress
	 * 		3. creation
	 * 		// do creation loop
	 * 		4. creationComplete
	 * 		//dispatch creation
	 * 
	 */
	public class BaseViewblock extends Sprite
	{
		/**
		 *  view block namespcae
		 */
		protected var _namespace:String;
		/**
		 * 序列化字串 
		 */
		protected var _serialize:String;
		
		
		public function BaseViewblock()
		{
			
		}
		
		private var _initlialzed:Boolean = false;
		public function get initlialzed():Boolean
		{
			return _initlialzed;
		}

		
		private static var _vim:ViewBlockInstantiationManager = ViewBlockInstantiationManager.getInstance();
		public function completeInitlialzed():void
		{
			if(_initlialzed)
				return;
			_initlialzed = true;
			dispatchEvent(new ViewBlockEvent(ViewBlockEvent.INIRED));
			creation();
		}

		/**
		 * 预先初始化 
		 * @return 
		 * 
		 */
		protected function preinit():void
		{
			_namespace = "";
			_serialize = "";
		}
		
		/**
		 * //异步调用creation
		 * 
		 */
		protected function init():void
		{
			_vim.initClassRef(this,_namespace,_serialize);
		}
		
		public function getNeedBundlerList():Array
		{
			return _vim.getTheNeedBundlerList(this,_namespace,_serialize);
		}
		
		/**
		 * get list of res
		 * get res class
		 * init res obj
		 * fill res obj with dynamic_props
		 * dispatch creation_complete; 
		 * 
		 */
		protected function creation():void
		{
			_vim.viewBlockCration(this,_namespace);
			_isCreationCompleted = true;
			trace(this,'created');
			dispatchEvent(new ViewBlockEvent(ViewBlockEvent.CREATED));
		}
		
		private var _isCreationCompleted:Boolean = false;
		public function get isCreationCompleted():Boolean
		{
			return _isCreationCompleted;
		}
		
		public function get isStarted():Boolean
		{
			return _started;
		}
		private var _started:Boolean = false
		public function start():void
		{
			if(_started)
				return ;
			_started = true
			if(!_initlialzed)
			{
				preinit();
				init();
			}else{
				//遍历动画
			}
		}
		
		public function sleep():void
		{
			if(!_started)
				return ;
			_started = false
			//清理动画
		}
		
		
		
		
		
		
		
		
	}
}