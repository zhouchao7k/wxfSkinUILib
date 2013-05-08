package sample.view
{
	import flash.display.Sprite;
	
	import org.oswxf.skinui.impl.BaseViewblock;
	
	public class SimpleView extends BaseViewblock
	{
		public function SimpleView()
		{
			super();
		}
		
		override protected function preinit():void
		{
			_namespace = 'sample.view.SimpleView';
			_serialize = 'eNodjEEOgjAQAKlgjXDRcDDG+AQ54BP0ByZeydKussnSNm1Feb2Cc5rDZPKzKA30GBwo3DGEeOnA' +
				'PFHvPYYrPsggU5CnAL1jrAbCd3Wj2e+TZt+JTZqIXImCYUS/nmerF+mdxqA8uUjWHMlE9KAiDdAy' +
				'HvQ4VaQa560L/4csFduATRuNLDpktlIststEpmNWy/ST1T9uSjuV';
		}
		
		public var close_btn:Sprite = null;
	}
}