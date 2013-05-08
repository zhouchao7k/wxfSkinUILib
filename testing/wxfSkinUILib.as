package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.oswxf.skinui.manager.SkinUIManager;
	import org.oswxf.skinui.model.BundlerModel;
	import org.oswxf.skinui.model.SimpleResObjectDefineModel;
	import org.oswxf.skinui.model.SkinUIModelLocator;
	import org.oswxf.skinui.token.ResourceToken;
	import org.oswxf.skinui.vo.SimpleResObject;
	
	public class wxfSkinUILib extends Sprite
	{
		public function wxfSkinUILib()
		{
			
//			var res1:SimpleResObject = new SimpleResObject();
//			res1.uid="111222";
//			res1.uri = "kkk#ddd"
//			res1.type=1;
//			res1.description= "ddss";
			
			var str:String = '[{"type":1,"description":"ddss","uri":"kkk@ddd","uid":"uid1"},' +
				'{"type":1,"description":"ddss","uri":"Hello@ddd","uid":"hello"}]';
			
			SkinUIModelLocator.simpelResModel.serialize=str;
			trace(SkinUIModelLocator.simpelResModel.serialize);
//			
			trace(SkinUIModelLocator.simpelResModel.getBunderURIList());
//			
			var urll:URLLoader = new URLLoader();
			urll.dataFormat = URLLoaderDataFormat.BINARY
			urll.load(new URLRequest("test.swf"));
			urll.addEventListener(Event.COMPLETE,onComplete);
		
		}
		
		protected function onComplete(event:Event):void
		{
			// TODO Auto-generated method stub
			var ba:ByteArray = (event.currentTarget).data;
				
			trace(BundlerModel.getInstance().setBundler("ddd",ba));
			var token:ResourceToken = SkinUIManager.getInstance().getResDefinitionByUID("hello");
			parseToken(token);
			trace('fuk');
		}
		
		private function parseToken(token:ResourceToken):void
		{
			// TODO Auto Generated method stub
			if(!token.data)
			{
				token.addEventListener(Event.COMPLETE,onTokenComplete);
				return;
			}
			
			var cls:Class = token.data;
			this.addChild(new cls() as DisplayObject);
				
		}
		
		protected function onTokenComplete(event:Event):void
		{
			// TODO Auto-generated method stub
			(event.target as ResourceToken).removeEventListener(Event.COMPLETE,onTokenComplete);
			parseToken(event.target as ResourceToken)
		}
	}
}