package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import org.oswxf.skinui.comp.controls.ZButton;
	import org.oswxf.skinui.manager.CodeGenerateManager;
	import org.oswxf.skinui.model.BundlerModel;
	import org.oswxf.skinui.model.SkinUIModelLocator;
	import org.oswxf.skinui.vo.ComponentViewObjectDefinetionVO;
	import org.oswxf.skinui.vo.ViewBlockDefinitionVO;
	import org.oswxf.skinui.vo.ViewObjecDefinetionVO;
	
	import sample.SampleModule;
	import sample.view.SampleVBMediator;
	
	public class TestMediator extends Sprite
	{
		public function TestMediator()
		{
			super();
			
			
			var str:String = '[' +
								'{"type":1,"description":"ddss","uri":"kkk@ddd","uid":"uid1"},' +
								'{"type":2,"description":"ddss","uri":"Hello@ddd","uid":"hello"},' +
								'{"type":4,"description":"ddss","uri":"111","uid":"simple"},' +
								'{"type":5,"description":"ddss","uri":"111","uid":"zbutton"}' +
								']';
			
			SkinUIModelLocator.simpelResModel.serialize=str;
			
			
			
			var sampelme:SampleModule = new SampleModule();
			var ed:EventDispatcher =this;
			sampelme.init(ed,this)
			gen();
			flash.utils.setTimeout(callEvent,1000);
			flash.utils.setTimeout(doLoad,2000);
			
//			flash.utils.setTimeout(traceGen2,3000);
		}
		private function traceGen():void
		{
			var boj:CodeGenerateManager = new CodeGenerateManager();
			trace(	boj.genViewBlockByNS('sample.view.SampleViewBlock'));
		}
		
		private function traceGen2():void
		{
			var ns:String = 'sample.view.SampleViewBlock';
			var boj:CodeGenerateManager = new CodeGenerateManager();
			var vob:ViewBlockDefinitionVO = SkinUIModelLocator.viewBlockModel.getViewBlock(ns);
			var bojb:ComponentViewObjectDefinetionVO = new ComponentViewObjectDefinetionVO();
			bojb.component_classRef = 'org.oswxf.skinui.comp.controls.ZButton';
			bojb.skinList['upSkin'] = 'hello';
			bojb.skinList['overSkin'] = 'hello';
			bojb.skinList['downSkin'] = 'hello';
			bojb.skinList['disabledSkin'] = 'hello';
			bojb.uid = 'zbutton';
			bojb.name = 'button1';
			bojb.dynamic_props['x']=150;
			bojb.dynamic_props['y']=150;
			vob.resDefinelis.push(bojb);
			SkinUIModelLocator.viewBlockModel.setViewBlock(ns,vob);
			trace(	boj.genViewBlockByNS(ns));
		}
		
		private function gen():void
		{
			var vbo:ViewBlockDefinitionVO = new ViewBlockDefinitionVO();
			vbo.namespace = 'sample.view.SampleViewBlock';
			var ok_btn:ViewObjecDefinetionVO = new ViewObjecDefinetionVO();
			ok_btn.name= 'ok_btn';
			ok_btn.uid = 'hello';
			ok_btn.dynamic_props['x'] = 50;
			ok_btn.dynamic_props['y'] = 50;
			vbo.resDefinelis.push(ok_btn);
			var sbv:ViewObjecDefinetionVO = new ViewObjecDefinetionVO();
			sbv.name = 'viewB2';
			sbv.uid = 'simple';
			sbv.dynamic_props['namespace'] = 'sample.view.SimpleView';
			sbv.dynamic_props['x'] = 50;
			sbv.dynamic_props['y'] = 50;
			vbo.resDefinelis.push(sbv);
			
			var bojb:ComponentViewObjectDefinetionVO = new ComponentViewObjectDefinetionVO();
			bojb.component_classRef = 'org.oswxf.skinui.comp.controls.ZButton';
			
			bojb.skinList['upSkin'] = 'hello';
			bojb.skinList['overSkin'] = 'hello';
			bojb.skinList['downSkin'] = 'hello';
			bojb.skinList['disabledSkin'] = 'hello';
			bojb.uid = 'zbutton';
			bojb.name = 'button1';
			bojb.dynamic_props['x']=150;
			bojb.dynamic_props['y']=150;
			
			vbo.resDefinelis.push(bojb);
			SkinUIModelLocator.viewBlockModel.setViewBlock(vbo.namespace,vbo);
			var serz:String =SkinUIModelLocator.viewBlockModel.getSerialize(vbo.namespace) 
			trace(serz);
			SkinUIModelLocator.viewBlockModel.setSerialize(serz);
			
			var boj:CodeGenerateManager = new CodeGenerateManager();
			trace(	boj.genViewBlockByNS('sample.view.SampleViewBlock'));
//			return ;
			
			var simpel:ViewBlockDefinitionVO = new ViewBlockDefinitionVO();
			simpel.namespace = "sample.view.SimpleView";
			var close_btn:ViewObjecDefinetionVO = new ViewObjecDefinetionVO();
			close_btn.name = 'close_btn';
			close_btn.uid = 'hello';
			close_btn.dynamic_props['x'] = 50;
			close_btn.dynamic_props['y'] = 50;
			simpel.resDefinelis .push(close_btn);
			
			SkinUIModelLocator.viewBlockModel.setViewBlock(simpel.namespace,simpel);
			trace(SkinUIModelLocator.viewBlockModel.getSerialize(simpel.namespace));
		}
		
		private function callEvent():void
		{
			// TODO Auto Generated method stub
			trace('callEvent');
			this.dispatchEvent(new Event('callSampleViewToShow'));
		}
		
		
		private function doLoad():void
		{
			trace('doLoad');
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
		}
	}
}