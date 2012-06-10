package
{	
	import org.flixel.*;
	
	public class Block extends FlxSprite
	{
		[Embed(source="assets/green.png")] private var ImgBlock:Class;
		
		private var actionTimer:Number = 0;
		public var allBlocks:FlxGroup = new FlxGroup();
		public var landed:Boolean = false;
		public var ceiling:Block = null;
		public var maxTowerHeight:Number = 5;
		public var curTowerHeight:Number = 1;
		public var tower:FlxGroup = new FlxGroup;
		
		public function Block(X:Number=0, Y:Number=0)
		{
			super(X, Y, ImgBlock);
			immovable = true;
		}
				
		public function move(dx:Number,dy:Number):void
		{
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
			return doesNotOvelapAt(x + dx, y + dy, allBlocks)
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
		}
		
		public function towerHeight():Number
		{
			return towerHeightHelper(this,curTowerHeight);
		}
		
		public function towerHeightHelper(block:Block,height:Number):Number
		{
			if (block.ceiling == null)
			{
				return 1;
			}
			return towerHeightHelper(block.ceiling,block.ceiling.curTowerHeight) + curTowerHeight;
		}
		
		public function isMaxTowerHeight():Boolean
		{
			return towerHeight() == maxTowerHeight;
		}
		
		override public function update():void
		{	
			trace(towerHeight());
			
			actionTimer += FlxG.elapsed;
			// Should action timer reset?
			if (actionTimer >= 0.5)
			{
				// Yes, reset action timer; steady fall
				actionTimer = 0;
				move(0,frameHeight);
			}
			if (!canMove(0,frameHeight))
			{
				landed = true;
			}
			else
			{
				landed = false;
			}
			addCeiling();
		}
	}
}