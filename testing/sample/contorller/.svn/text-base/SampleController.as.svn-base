package sample.contorller
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import sample.view.SampleVBMediator;

	public class SampleController
	{
		private var _mediator:SampleVBMediator = null;
		public function SampleController()
		{
			_mediator = new SampleVBMediator;
		}
		
		/**
		 * 监听外部消息 
		 * 
		 */
		public function init($eventBus:EventDispatcher,$container:Sprite):void
		{
			$eventBus.addEventListener('callSampleViewToShow',callSampleViewToShow);
			_mediator.container = $container;
		}
		
		
		private function callSampleViewToShow($e:Event):void
		{
			_mediator.startup();
		}
	}
}