package sample.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.oswxf.skinui.events.ViewBlockEvent;
	import org.oswxf.skinui.impl.BaseViewMediator;
	import org.oswxf.skinui.model.SkinUIModelLocator;
	import org.oswxf.skinui.vo.ViewBlockDefinitionVO;

	public class SampleVBMediator extends BaseViewMediator
	{
		public function SampleVBMediator()
		{
			
		}
		
		//************************************************************
		// mediator managed viewblocks
		//************************************************************
		/**
		 * sampleViewBlock 
		 */
		public var sampleViewBlock:SampleViewBlock;
//		public var sampleViewBlock2:SampleViewBlock;
//		public var sp2:SimpleView;
		public var container:Sprite;
		
		override public function startup():void
		{
			mapView(SampleViewBlock);
			mapView(SimpleView);
			super.startup();
		}
		
		
		override protected function viewCreated():void
		{
			this.container.addChild(sampleViewBlock);
		}
		
		public function setName($name:String):void
		{
			if(runAysnLogica(setName,$name))
				return ;
		}
		
		private function onCLIK(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace('ok_btn,clicked');
		}
		
	}
}