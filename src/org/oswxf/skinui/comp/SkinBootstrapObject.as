package org.oswxf.skinui.comp
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import org.oswxf.skinui.impl.BaseViewblock;
	
	public class SkinBootstrapObject implements ISkinBootstrapObject
	{
		public function SkinBootstrapObject()
		{
		}
		
		private var _objClass:Class ;
		
		public function setObjClass(classObj:Class):void
		{
			_objClass = classObj;
		}
		
		private var _skinClasses:Dictionary = null;
		
		public function setSkinClasses(skinName:String, skinClass:Class):void
		{
			if(!_skinClasses)
				_skinClasses = new Dictionary();
			_skinClasses[skinName] = skinClass;
		}
		
		public function bootstrap():DisplayObject
		{
			var obj:DisplayObject = new _objClass() as DisplayObject;
			if(_skinClasses!=null)
			{
				for (var key:String in _skinClasses)
				{
					ISkinUIComp(obj).setClass(key,_skinClasses[key])
				}
			}
			if(obj is ISkinUIComp)
				ISkinUIComp(obj).creation();
			if(obj is BaseViewblock)
				BaseViewblock(obj).start();		
			return obj;
		}
	}
}