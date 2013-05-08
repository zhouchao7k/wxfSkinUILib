package org.oswxf.skinui.manager
{
	import flash.text.StyleSheet;

	public class StyleManager
	{
		public function StyleManager()
		{
		}
		static private var _instance:StyleManager = null;
		
		static public function getInstance():StyleManager
		{
			if(!_instance)
				_instance = new StyleManager();
			return _instance
		}
		
		private var _style:StyleSheet = new StyleSheet();
		private var _store_style:String = '';
		public function inputStyleSheet($style:String):void
		{
			if(_store_style== $style)
				return;
			_store_style = $style;
			_style.parseCSS($style);
		}
		
		/**
		 *  获取style 定义数据
		 * 下面是style定义字串
		 * comp#ccoo{
		 * 	name:"hello";
		 * 	skin-class: SimpleRes("res111");
		 * }
		 * 
		 * 对应格式的内容为
		 *   Object[comp] [ccoo] ["prop"][name] ["hello"] 
		 * 						["skin"]["skin-class"] ["res111"]
		 */
		public function getStyleDefine():Object
		{
			var result:Object = {}
			var sn:Array = _style.styleNames;
			for(var i:int=0;i<sn.length;i++)
			{
				var st:String = sn[i];
				var comp:String=st.split("#")[0];
				var sname:String=st.split("#")[1];
				if(!result[comp])
					result[comp]={};
				if(!result[comp][sname])
				{
					result[comp][sname]={};
					result[comp][sname]['prop']={};
					result[comp][sname]['skin']={};
				}
				var stobj:Object = _style.getStyle(st);
				for (var key:String in stobj)
				{
					var keyVa:String = stobj[key];
					var isRes:Boolean = keyVa.search("SimpleRes")>-1;
					if(isRes){
						var ka:Array = keyVa.split('"');
						result[comp][sname]['skin'][key] = ka[1] 
					}else
					{
						result[comp][sname]['prop'][key] = keyVa 
					}
				}
			}
			return result;
		}
		
		/**
		 * 输出样式字串 
		 * @return 
		 * 
		 */
		public function generateStyleSheetString():String
		{
			var result:String = "";
			var sn:Array = _style.styleNames;
			for(var i:int= 0 ; i <sn.length;i++)
			{
				var item:String = ""
				var styleName:String = sn[i];
				item+=styleName + "\n{";
				
				var styleObj:Object = _style.getStyle(styleName);
				for (var key:String in styleObj)
				{
					item+= key+":" + styleObj[key]+";\n";	
				}
				
				item+= "\n}";
				result+=item +"\n"
			}
			
			return result;
		}
		
		/**
		 * 设置STYLE
		 *  
		 * @param $stylename 样式名称
		 * @param $compName 组件名称
		 * @param $key		属性名
		 * @param $value	属性
		 * @param $isRes	是否为资源，如果是，则$value是uid
		 * 
		 */
		public function setStyleDefine($stylename:String, $compName:String,$key:String,$value:String,$isRes:Boolean=false):void
		{
			var realName:String = $compName+"#"+$stylename;
			var value:String = $value;
			if($isRes)
				value  = "SimpleRes(\""+value+"\")";
			
			var obj:Object = _style.getStyle(realName);
			if(!obj)
				obj = {};
			obj[$key] = value;
			
			_style.setStyle(realName,obj);		
			
		}
		
		
		
	}
}