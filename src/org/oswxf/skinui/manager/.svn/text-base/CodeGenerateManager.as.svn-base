package org.oswxf.skinui.manager
{
	import org.oswxf.skinui.SkinUIConst;
	import org.oswxf.skinui.model.SkinUIModelLocator;
	import org.oswxf.skinui.vo.ComponentViewObjectDefinetionVO;
	import org.oswxf.skinui.vo.ViewBlockDefinitionVO;
	import org.oswxf.skinui.vo.ViewObjecDefinetionVO;

	public class CodeGenerateManager
	{
		public function CodeGenerateManager()
		{
		}

		private var template:String ="package @package@\n"+
			"{\n"+
			"@imported@\n"+
			"   \/**\n" +
			"	 * 描述：@desc@\n" +
			"	 * 创建于：@time@\n" +
			"	 *\n" +
			"	 *\/\n"+
			"	public class @class@ extends BaseViewblock\n"+
			"	{\n"+
			"		override protected function preinit():void\n"+
			"		{\n"+
			"			_namespace = '@namespace@';\n"+
			"			_serialize = '@serialize@';\n"+
			"		}\n"+
			"		\n"+
			"@reflist@\n"+
			"	}\n"+
			"}"
		
		
		
		private const itemTempl:String = '		/**\n' +
			'		 * {0}\n' +
			'		 * 类型：{1}\n' +
			'		 */\n' +
			'		public var {3}:{4};\n' +
			''
		public function genViewBlockByNS($namespace:String):String
		{
			return prase($namespace);
		}
		
		
		private var _imported:Array = []
		private function prase($namespace:String):String
		{
			_imported = [];
			var vbo:ViewBlockDefinitionVO = SkinUIModelLocator.viewBlockModel.getViewBlock($namespace);
			var re_namespace:String = $namespace;
			var re_serz:String  = SkinUIModelLocator.viewBlockModel.getSerialize($namespace);
			re_serz = parseSerz(re_serz);
			addimported("flash.display.Sprite");
			addimported("org.oswxf.skinui.impl.BaseViewblock");
			var lastptIdx:int = $namespace.lastIndexOf('.');
			var re_package:String = $namespace.slice(0,lastptIdx);
			var re_class:String = $namespace.slice(lastptIdx+1);
			var re_instList:String = parseRefList(vbo);
			
			var result:String = template;
			result = result.replace('@namespace@',re_namespace);
			result = result.replace('@serialize@',re_serz);
			result = result.replace('@class@',re_class);
			result = result.replace('@package@',re_package);
			result = result.replace('@reflist@',re_instList);
			result = result.replace("@imported@", getImported());
			result = result.replace("@time@",getDateToString(vbo.lastChanged));
			result = result.replace("@desc@",vbo.desc);
			
			return result;
		}
		
		/**
		 * 获取时间
		 * @return YYYY-MM-DD HH:MM
		 */		
		internal function getDateToString(value:Number):String
		{
			var date:Date = new Date();
			date.time = value;
			return date.fullYearUTC + "-" + (date.month + 1) + "-" + date.date + " " + date.hours + ":" + date.minutes; 
		}
		internal function parseSerz($str:String ):String
		{
			var tmp:Array = [];
			tmp = $str.split('\n');
			var result:String = '';
			result = tmp.toString();
			while(result.indexOf(',')>-1)
				result=	result.replace(',',"'+\n  '");
			return result;
		}
			
		
		internal function parseRefList($vbo:ViewBlockDefinitionVO):String
		{
			var templ:String
			var result:String = "";
			for each(var item:ViewObjecDefinetionVO in $vbo.resDefinelis)
			{
				var type:int = SkinUIModelLocator.simpelResModel.getRes(item.uid).type;
				var tname:String = '';
				var ttype:String = '';
				switch(type)
				{
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_BMP:
						tname = '位图';
						ttype = 'Bitmap';
						addimported("flash.display.Bitmap");
						break;
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_MOVIECLIP:
						tname = 'MovieClip动画';
						ttype = 'MovieClip';
						addimported("flash.display.MovieClip");
						break;
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_BTN:
						tname = '按钮';
						ttype = 'Sprite';
						addimported("flash.display.Sprite");
						break;
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_PLACEHOLDER:
						tname = '占位符'
						ttype = 'Sprite';
						addimported("flash.display.Sprite");
						break;
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_VIEWBLOCK:
						tname = 'Viewblock'
						ttype = $vbo.namespace;
						addimported($vbo.namespace);
						break;
					case SkinUIConst.SIMPLE_RES_DEFINE_TYPE_COMPONENT:
						tname = '组件'
						ttype = ComponentViewObjectDefinetionVO(item).component_classRef;
						addimported(ttype);
						break;
				}
				var it:String = itemTempl;
				it = it.replace('{0}',item.description);
				it = it.replace('{1}',tname);
				it = it.replace('{3}',item.name);
				it = it.replace('{4}',ttype);
				
				result += it + '\n\n';
			}
			return result;
		}
		
		internal function addimported($value:String):void
		{
			var imp:String = "import "+$value;
			if(_imported.indexOf(imp)==-1)
				_imported.push(imp);
			_imported.sort();
		}
		
		internal function getImported():String
		{
			var spaced:String = '    ';
			var result:String = "";
			while(_imported.length>0)
			{
				var ip:String = _imported.shift();
				result += spaced+ip+";\n";
			}
			return result;
			
		}
		
		
	}
}