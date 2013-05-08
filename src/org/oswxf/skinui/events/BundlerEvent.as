package org.oswxf.skinui.events
{
	

	public class BundlerEvent extends SCEvent
	{
		public static const MISS:String = 'bundler_miss';
		public static const CHANGE:String = 'bundler_change';
		
		public function BundlerEvent(type:String,$miss_bundlers:Array = null)
		{
			super(type)
			this.data = $miss_bundlers;
		}
		
		public function get missing_bundlers():Array
		{
			return this.data as Array;
		}
	}
}