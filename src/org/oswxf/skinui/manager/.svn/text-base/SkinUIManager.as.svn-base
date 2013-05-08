package org.oswxf.skinui.manager
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import org.oswxf.skinui.model.BundlerModel;
	import org.oswxf.skinui.model.SkinUIModelLocator;
	import org.oswxf.skinui.model.ViewBlockModel;
	import org.oswxf.skinui.token.ResourceToken;
	import org.oswxf.skinui.vo.ResBundlerObject;
	import org.oswxf.skinui.vo.SimpleResObject;
	import org.oswxf.skinui.vo.ViewBlockDefinitionVO;

	/**
	 *  SkinUI Manager
	 * @author nativeas
	 * 
	 */
	public class SkinUIManager
	{
		public function SkinUIManager()
		{
			if(_instace)
				throw new Error('单例')
		}
		
		private static  var _instace: SkinUIManager = null;
		public static function getInstance():SkinUIManager
		{
			if(!_instace)
				_instace = new SkinUIManager();
			return _instace
		}
		private var _bManager:BundlerModel = BundlerModel.getInstance();
		
		/**
		 * 存入资源包数据 
		 * @param $uri
		 * @param $bytes
		 * @return 
		 * 
		 */
		public function setBundler($uri:String,$bytes:ByteArray):Boolean
		{
			return _bManager.setBundler($uri,$bytes);
		}
		
		/**
		 * 获取资源包列表 
		 * @return 
		 * 
		 */
		public function getBundlerList():Vector.<ResBundlerObject>
		{
			return _bManager.getBundlerList();
		}
		
		
		public function getResListByBundlerURI($bundlerURI:String):Vector.<SimpleResObject>
		{
			 return SkinUIModelLocator.simpelResModel.getResListByURI($bundlerURI);
		}
		
		/**
		 * 根据UID 获取 res对象 
		 * @param $uid
		 * @return 
		 * 
		 */
		public function getResByUID($uid:String):SimpleResObject
		{
			return SkinUIModelLocator.simpelResModel.getRes($uid);
		}
		
		
		/**
		 * 导入res 配置 
		 * @param $json_str
		 * [{"uid":"uid1","type":1,"description":"ddss","uri":"kkk@ddd"},
		 * {"uid":"uid2","type":1,"description":"ddss","uri":"kkk@ddd"}]
		 */
		public function initResConfig($json_str:String):void
		{
			SkinUIModelLocator.simpelResModel.serialize = $json_str;
			SkinUIModelLocator.simpelResModel.getBunderURIList()
		}
		
		private var _aysncRecyFactory:AsyncRecycleFactory = new AsyncRecycleFactory();
		
		/**
		 * 根据UID获取类实例
		 * @param $uid
		 * @return 
		 * 
		 */
		public function getResDefinitionByUID($uid:String):ResourceToken
		{
			return _aysncRecyFactory.getRefClass($uid);
		}
		
		
		/**
		 * 根据 uid 数组获取class
		 * 完成之后返回complete
		 * @param $uidArr
		 * @return 
		 * 
		 */
		public function getResList($uidArr:Array ):ResourceToken
		{
			return _aysncRecyFactory.getResClassList($uidArr);
		}
		
		private var _vbModel:ViewBlockModel = SkinUIModelLocator.viewBlockModel;
		/**
		 * 存入viewblock 对象
		 * @param $ns  namespcae
		 * @param $vb  
		 * 
		 */
		public function setViewBlock($vb:ViewBlockDefinitionVO):void
		{
			_vbModel.setViewBlock($vb.namespace,$vb);
		}
		
		
		/**
		 * 发起viewblock 预先下载资源流程 
		 * @param $vbo
		 * @param $ed
		 * @return 
		 * 
		 */
		public function getReadyViewBlockVO($vbo:ViewBlockDefinitionVO,$ed:EventDispatcher):ResourceToken
		{
			return ViewBlockInstantiationManager.getInstance().getReadyForViewBlock($vbo,$ed);
		}
		
		/**
		 * 删除view block 对象 
		 * @param $ns
		 * 
		 */
		public function delViewBlock($ns:String):void
		{
			_vbModel.delViewBlock($ns);
		}
		
		/**
		 * 根据 viewblock 的ns获取对象 
		 * @param $ns namespace
		 * @return 
		 * 
		 */
		public function getViewBlock($ns:String):ViewBlockDefinitionVO
		{
			return _vbModel.getViewBlock($ns);
		}
		
		/**
		 * 获取当前管理的viewblock 对象的所有ns 
		 * @return 
		 * 
		 */
		public function getViewBlockNSList():Array
		{
			return _vbModel.getNSList();
		}
		
		
		
		private var _code:CodeGenerateManager = new CodeGenerateManager();
		/**
		 * 输出生成代码 
		 * @param $ns
		 * @return 
		 * 
		 */
		public function outputViewBlockGeneratedCodeFile($ns:String):String
		{
			return _code.genViewBlockByNS($ns);
		}
		
		private var _sm:StyleManager =StyleManager.getInstance()
			
		/**
		 * 输入Style 
		 * @param $style
		 * 
		 */
		public function inputStyleSheetString($style:String):void
		{
			_sm.inputStyleSheet($style);
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
			return _sm.getStyleDefine();
		}
		
		
		/**
		 * 输出样式字串 
		 * @return 
		 * 
		 */	
		public function generateStyleSheetString():String
		{
			return _sm.generateStyleSheetString();
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
			_sm.setStyleDefine($stylename,$compName,$key,$value,$isRes)
		}
		
		
	}
}