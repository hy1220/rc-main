package com.gxuwz.rctrlm.model
{

		public class Regulate
		{
			public var oneDigit:String;
			public var twoDigit:String;
			public var threeDigitLess:String;
			public var threeDigitMore:String;
			public var number:Number;
			public function Regulate(s1:String,s2:String,s3:String,s4:String,n:Number):void
			{
				oneDigit=s1;
				twoDigit=s2;
				threeDigitLess=s3;
				threeDigitMore=s4;
				number=n;
			}
			public function init(s1:String,s2:String,s3:String,s4:String,n:Number):void
			{
				oneDigit=s1;
				twoDigit=s2;
				threeDigitLess=s3;
				threeDigitMore=s4;
				number=n;
			}
		}
}