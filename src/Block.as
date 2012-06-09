package
{
	import flash.utils.Dictionary;
	
	import org.flixel.*;
	
	public class Block extends FlxSprite
	{
		[Embed(source="assets/green.png")] private var ImgBlock:Class;
		private var counter:Number = 0;
		public var allBlocks:FlxGroup = new FlxGroup();
		
		public function Block(X:Number=0, Y:Number=0)
		{
			super(X, Y, ImgBlock);
			immovable = true;
		}
		
		
		public function move(dx:Number,dy:Number):void
		{
			dx = dx*frameWidth;
			dy = dy*frameWidth;
//			trace(canMove(dx,dy));
			if (canMove(dx,dy))
			{
				x += dx;
				y += dy;
			}
		}
		
		public function canMove(dx:Number, dy:Number):Boolean
		{
//			trace(x + dx, y + dy);
//			trace(!overlapsAt(x+dx,y+dy,allBlocks),FlxG.width - 4, FlxG.height - 4)
			return !overlapsAt(x + dx, y + dy, allBlocks)
				&& x + dx >= 0
				&& x + dx <= FlxG.width - 4
				&& y + dy <= FlxG.height - 4;
		}
		
		override public function update():void
		{			
			counter += FlxG.elapsed;
			if (counter >= 0.5)
			{
				counter = 0;
				move(0,1)
//				trace (!overlapsAt(x, y + frameHeight,allBlocks))

//				if (!overlapsAt(x, y + frameHeight,allBlocks))
//				{
//					y += frameHeight;
//				}
			}
//			kludgeUpdate();
		}
		
//		public function kludgeUpdate():void
//		{
//			if (x < 0)
//				x = 0;
//			if (x > FlxG.width - 4)
//				x = FlxG.width - 4;
//			if (y > FlxG.height - 4)
//				y = FlxG.height - 4;
//		}
	}
}