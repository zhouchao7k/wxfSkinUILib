package org.oswxf.skinui.comp
{
	public interface ISkinUIComp
	{
		
		/**
		 * 
		 * @param $name
		 * @param $class
		 * @return 
		 * 
		 */
		function setClass($name:String, $class:Class):Boolean;
		
		/**
		 * 
		 * @param $propsName
		 * @param $propValue
		 * 
		 */
		function setProps($propsName:String ,$propValue:*):void;
		
		
		/**
		 * 
		 * @param $name
		 * @param $bootstrapObj
		 * @return 
		 * 
		 */
		function setBootstrapObj($name:String, $bootstrapObj:ISkinBootstrapObject):Boolean;
		
		/**
		 * 
		 * 
		 */
		function creation():void;
	}
}