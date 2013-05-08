package org.oswxf.skinui.vo
{
	import flash.utils.Dictionary;
	
	/**
	 * 资源定义对象
	 * 用于在面板中定义的资源定义对象
	 * 描述面板中每个显示对象的可用性
	 * 这个对象用于描述显示对象在每个不同的container中的动态修改的属性
	 * @author nativeas
	 */
	public class ViewObjecDefinetionVO
	{
	
		public function ViewObjecDefinetionVO():void
		{
			className = 'org.oswxf.skinui.vo.ViewObjecDefinetionVO'
		}
		public var className:String = '';
		/**
		 * 描述
		 * 确保知道这个实例是做什么用的
		 */
		public var description:String = '';
		
		/**
		 * 标识
		 * 
		 */
		public var uid:String = '';
		
		/**
		 * 原件在代码中的名称 
		 */
		public var name:String = "";
		
	
		/**
		 * 动态属性
		 * 类似x,y,height,weight 
		 */
		public var dynamic_props:Dictionary = new Dictionary;
		
		
		/**
		 * 层级 
		 */
		public var layer:int = -1;
		
		/**
		 * 是否活动，是否会相应鼠标事件 
		 */
		public var interactivable:Boolean = false;
		
		/**
		 * 是否为引用给其他组件对象使用的对象
		 * 如果是，就不会被实例化 
		 */
		public var isRefObject:Boolean = false; 
		
	}
}