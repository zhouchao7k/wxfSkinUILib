package org.oswxf.skinui.vo
{
	import flash.utils.Dictionary;

	public class ComponentViewObjectDefinetionVO extends ViewObjecDefinetionVO
	{
		public function ComponentViewObjectDefinetionVO()
		{
			className = 'org.oswxf.skinui.vo.ComponentViewObjectDefinetionVO'
		}
		
		
		/**
		 * ccomponent class name; 
		 */
		public var component_classRef:String = '';
		
		/**
		 * [skinname] = uid
		 */
		public var skinList:Dictionary = new Dictionary();
		
		public var compProps:Dictionary = new Dictionary();
		
		/**
		 * boot strap Key
		 * [bootkey] = itemname 
		 */
		public var refList:Dictionary = new Dictionary();
		
		/**
		 * useStyle 
		 */		
		public var useStyle:Boolean = false
		/**
		 * style name for component by style sheet 
		 */
		public var styleName:String = "";
	}
}