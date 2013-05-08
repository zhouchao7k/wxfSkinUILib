package sample
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	import sample.contorller.SampleController;

	public class SampleModule
	{
		public function SampleModule()
		{
		}
		private var _controller:SampleController ;
		public function init($ed :EventDispatcher,$container:Sprite):void
		{
			_controller = new SampleController();
			_controller.init($ed,$container);
		}
	}
}