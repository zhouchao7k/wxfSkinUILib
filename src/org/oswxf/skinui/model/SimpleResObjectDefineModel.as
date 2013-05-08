package org.oswxf.skinui.model
{
	import com.adobe.serialization.json.JSONParseError;
	import com.adobe.serialization.json.JSONParser;
	
	import flash.utils.Dictionary;
	
	import org.oswxf.skinui.vo.SimpleResObject;

	/**
	 * 简单资源对象 
	 * @author nativeas
	 * 
	 */
	public class SimpleResObjectDefineModel
	{
		/**
		 * 存储所有res定义 
		 */		
		private var _resStorage:Dictionary = new Dictionary();
		/**
		 * 存入RESOBj 
		 * @param $res
		 * 
		 */
		public function setResObj($res:SimpleResObject):void
		{
			if(_resStorage[$res.uid]==null)
			{
				//do add item
				_resStorage[$res.uid] = $res;
				return ;
			}
			
			var distRes:SimpleResObject = _resStorage[$res.uid];
			if(compareRes($res,distRes))
				return;
			else
			{
				//do update
				_resStorage[$res.uid] = $res;
				return ;
			}
		}
		
		/**
		 * 比较两个simpleReSobject 
		 * @param $source
		 * @param $dist
		 * @return 
		 * 
		 */
		internal function compareRes($source:SimpleResObject,$dist:SimpleResObject):Boolean
		{
			if($source.description!=$dist.description|| $source.type!=$dist.type||$source.uid!=$dist.uid)
				return false;
			else
				return true;
		}
		
		/**
		 * 删除某个资源 
		 * @param $resUID
		 * @return 
		 * 
		 */
		public function delResObj($resUID:String):Boolean
		{
			if(_resStorage[$resUID]==null)
				return false
			_resStorage[$resUID] = null;
			delete _resStorage[$resUID];
			return true;
		}
		
		/**
		 * 获取某个RES 
		 * @param $resUID
		 * @return 
		 * 
		 */
		public function getRes($resUID:String):SimpleResObject
		{
			return _resStorage[$resUID] as SimpleResObject;
		}
		
		public function getBunderURIList():Vector.<String>
		{
			var result:Vector.<String> = new Vector.<String>;
			for each(var item:SimpleResObject in  _resStorage)
			{
				var itemUri:String = item.uri;
				var bundlerURI:String = itemUri.split("@")[1];
				if(result.indexOf(bundlerURI)==-1)
					result.push(bundlerURI);
			}
			
			return result;
		}
		
		
		public function getResList():Vector.<SimpleResObject>
		{
			var result:Vector.<SimpleResObject> = new Vector.<SimpleResObject>;
			for each( var item:SimpleResObject in _resStorage)
			{
				result.push(item);
			}
			return result;
		}
		
		public function getResListByURI($uri:String):Vector.<SimpleResObject>
		{
			var result:Vector.<SimpleResObject> = new Vector.<SimpleResObject>;
			for each( var item:SimpleResObject in _resStorage)
			{
				var itemUri:String = item.uri;
				var bundlerURI:String = itemUri.split("@")[1];
				if(bundlerURI == $uri)
					result.push(item);
			}
			return result;
		}
		
		
		
		/**
		 * 获得序列化对象 
		 * @return 
		 * 
		 */
		public function get serialize():String
		{
			
			var sit:Vector.<SimpleResObject> = getResList();
			var output:String =JSONParser.encode(sit);// JSON.stringify(sit);
			return output;
		}
		
		/**
		 * 导入序列化对象 
		 * @param $value
		 * @return 
		 * 
		 */
		public function set serialize($value:String ):void
		{
			//throw new Error('need to complete')
			
			var tmp:Object = JSONParser.decode($value);//JSON.parse($value);
			for each(var item:Object in tmp)
			{
				var sip:SimpleResObject = new  SimpleResObject();
				for (var key:String  in item)
				{
					sip[key] = item[key];
				}
				setResObj(sip)
			}
			
		}
		
		
	}
}