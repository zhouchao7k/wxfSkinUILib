package org.oswxf.skinui.model
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.oswxf.skinui.crypto.Base64Decoder;
	import org.oswxf.skinui.crypto.Base64Encoder;
	import org.oswxf.skinui.vo.ViewBlockDefinitionVO;
	import org.oswxf.skinui.vo.ViewObjecDefinetionVO;

	/**
	 * 所有的面板的管理器
	 * 主要用于加载所有的面板的配置文件
	 * 形成集中管理。
	 * 用于维护、删除面板。
	 * 以及提供一个描述结构树 
	 * @author nativeas
	 * 
	 */
	public class ViewBlockModel
	{
		public function ViewBlockModel()
		{
		}
		
		private var _viewBlockStoreage:Dictionary  = new Dictionary();
		/**
		 * 存入viewblock对象 
		 * @param $ns
		 * @param $vb
		 * 
		 */
		public function setViewBlock($ns:String,$vb:ViewBlockDefinitionVO):void
		{
			_viewBlockStoreage[$ns] = $vb;	
		}
		
		/**
		 * 删除viewblock 对象 
		 * @param $ns
		 * 
		 */
		public function delViewBlock($ns:String):void
		{
			_viewBlockStoreage[$ns] = null;
			delete _viewBlockStoreage[$ns] ;
		}
		
		/**
		 *获取viewblock 
		 * @param $ns
		 * @return 
		 * 
		 */
		public function getViewBlock($ns:String):ViewBlockDefinitionVO
		{
			return _viewBlockStoreage[$ns];
		}
		
		/**
		 *获取ns 列表 
		 * @return 
		 * 
		 */
		public function getNSList():Array
		{
			var result:Array = [];
			for (var key:String in _viewBlockStoreage)
			{
				result.push(key);
			}
			return result;
		}
		
		public function isNSExist($ns:String):Boolean
		{
			return $ns in _viewBlockStoreage;
		}
		
		
		/**
		 * 获得序列化对象 
		 * @return 
		 * 
		 */
		public function getSerialize($ns:String):String
		{
			var obj:ViewBlockDefinitionVO  = this.getViewBlock($ns);
			var ba:ByteArray = new ByteArray();
			ba.writeObject(obj);
			ba.compress();
		
			var ben:Base64Encoder = new Base64Encoder();
			
			ben.encodeBytes(ba);
			return ben.drain();
		}
		
		/**
		 * 导入序列化对象 
		 * @param $value
		 * @return 
		 * 
		 */
		public function setSerialize($value:String ):void
		{
			var deco:Base64Decoder = new Base64Decoder();
			deco.decode($value);
			var ba:ByteArray = deco.drain();
			ba.uncompress();
			var tmp:Object= ba.readObject();
			var tmp2:ViewBlockDefinitionVO = new ViewBlockDefinitionVO();
			for (var k:String in tmp)
			{
				switch(k){
					case "resDefinelis":
						while(tmp[k].length>0)
						{
							var obj:Object =tmp[k].shift();
							var cn:String = obj['className'];
							var targetCls:Class = flash.utils.getDefinitionByName(cn)as Class;
							
							var dist:ViewObjecDefinetionVO = new targetCls() as ViewObjecDefinetionVO;
							for (var objk:String  in obj)
							{
								dist[objk] = obj[objk];
							}
					
							tmp2[k].push(dist);
						}
						break;
					default:
						tmp2[k] = tmp[k];
				}
				
			}
			this.setViewBlock(tmp2.namespace , tmp2);
		}
		
	}
}