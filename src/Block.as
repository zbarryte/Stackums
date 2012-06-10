package
{
	import flash.utils.Dictionary;
	
	import org.flixel.*;
	
	public class Block extends FlxSprite
	{
		[Embed(source="assets/green.png")] private var ImgBlock:Class;
		private var counter:Number = 0;
		public var allBlocks:FlxGroup = new FlxGroup();
		public var landed:Boolean = false;
		public var ceiling:Block = null;
//		public var isThreeTall:Boolean = false;
		
		public function Block(X:Number=0, Y:Number=0)
		{
			super(X, Y, ImgBlock);
			immovable = true;
		}
		
		
		public function move(dx:Number,dy:Number):void
		{
//			dx = dx*frameWidth;
//			dy = dy*frameWidth;

			if (canMove(dx,dy))
			{
				x += dx;
				y += dy;
			}
			if (ceiling != null)
			{
				ceiling.move(dx,dy);
			}
		}
		
		public function canMove(dx:Number, dy:Number):Boolean
		{
//			trace(x+dx >=0, x+dx <= FlxG.width - 4, y + dy <= FlxG.height - 4, !overlapsAt(x + dx, y + dy, allBlocks));

			return doesNotOvelapAt(x + dx, y + dy, allBlocks)//!overlapsAt(x + dx, y + dy, allBlocks)
				&& x + dx >= 0
				&& x + dx <= FlxG.width - 4
				&& y + dy <= FlxG.height - 4;
		}
		
		public function doesNotOvelapAt(X:Number,Y:Number,group:FlxGroup):Boolean
		{
			var block:Block;
			for (var i:String in group.members)
			{
				block = group.members[i];
				if (block.x == X && block.y == Y)
				{
					return false;
				}
			}
			return true;
		}
		
		public function addCeiling():void
		{
			var block:Block;
			for (var i:String in allBlocks.members)
			{
				block = allBlocks.members[i];
				if (block.x == x && block.y == y - frameHeight)
				{
					ceiling = block;
				}
			}
			if (doesNotOvelapAt(x, y - frameHeight, allBlocks))
			{
				ceiling = null;
			}
//			if (doesNotOverlapAt(x,y - frameHeight,allBlocks))
//			{
//				ceiling = null;
//			}
//			if (doesNotOverlapAt(x, y + frameHeight, allBlocks))
//			{
//				ceiling = null;
//			}
				
		}
		
		public function isThreeTall():Boolean
		{
			return ceiling != null && ceiling.ceiling != null;
		}
		
		override public function update():void
		{			
			counter += FlxG.elapsed;
			if (counter >= 0.5)
			{
				counter = 0;
				move(0,frameHeight);
			}
			if (!canMove(0,frameHeight))
			{
//				trace("hit ground");
				landed = true;
			}
			else
			{
				landed = false;
			}
			addCeiling();
//			trace(ceiling);
			
//			if (isThreeTall())
//			{
//				isThreeTall = true;
////				trace("three tall");
//			}
		}
	}
}