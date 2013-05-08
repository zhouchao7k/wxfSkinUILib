package org.oswxf.skinui.vo
{
	/**
	 * 资源对象 
	 * @author nativeas
	 * 
	 */
	public class SimpleResObject
	{
		public function SimpleResObject()
		{
		}
		
		/**
		 * 全局唯一id 
		 */		
		public var uid:String = "";
		
		/**
		 * 描述
		 * 用于描绘这个资源对象用做什么用途 
		 */
		public var description:String = '';
		
		/**
		 * 唯一标识符
		 * 确保在整个runtime中都不会重复出现，
		 * 用于定位素材在素材包中的为止。
		 * 所属ns#时间戳@连接名:包名
		 * 例如
		 * base#123456798@btn1:bundler1
		 */
		public var uri:String = '';
		
		/**
		 *类型
		 * 定义这个素材是什么类型，位图，按钮，动画 
		 */		
		public var type:int = 1;
		
	}
}