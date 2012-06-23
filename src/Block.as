package
{	
	import org.flixel.*;
	
	public class Block extends FlxSprite
	{
//		[Embed(source="assets/green.png")] private var MintChipImg:Class;
		
		private var actionTimer:Number = 0;
		public var maxActionTimer:Number = 0.5;
		public var allBlocks:FlxGroup = new FlxGroup();
		public var ceiling:Block = null;
		public var maxTowerHeight:Number = 7;
		public var flavor:String = null;
		
		public function Block(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
		}
				
		public function steadyFall():void {move(0,frameHeight);}
		
		public function hasLanded():Boolean {return !canMove(0,frameHeight);}
		
		public function move(dx:Number,dy:Number):void
		{
			// Can the block move?
			if (canMove(dx,dy))
			{
				// Yes, move the block
				x += dx;
				y += dy;
				
				// Then try to move the block above it (if one exists)
				// (This block will, in turn, move the block above it, if one exists)
				// (Note that this means that a block will only move in a tower if the block directly below it does so)
				if (ceiling != null)
				{
					ceiling.move(dx,dy);
				}
			}
		}
		
		public function canMove(dx:Number, dy:Number):Boolean
		{
			// Find potential position
			var X:Number = x + dx;
			var Y:Number = y + dy;
			
			// Check whether or not potential postion goes out of bounds or collides with blocks
			return doesNotOvelapAt(x + dx, y + dy, allBlocks)
				&& x + dx >= 0
				&& x + dx <= FlxG.width - 4
				&& y + dy <= FlxG.height - 4;
		}
		
		public function doesNotOvelapAt(X:Number,Y:Number,group:FlxGroup):Boolean
		{
			// Does at least one block exist at the desired coordinate?
			var block:Block;
			for (var i:String in group.members)
			{
				block = group.members[i];
				if (block.x == X && block.y == Y)
				{
					// Yes, at least one block overlaps
					return false;
				}
			}
			// No, none overlap
			return true;
		}
		
		public function addCeiling():void
		{
			// Is there a block above the existing block?
			var block:Block;
			for (var i:String in allBlocks.members)
			{
				block = allBlocks.members[i];
				if (block.x == x && block.y == y - frameHeight)
				{
					// Yes, declare it the ceiling
					ceiling = block;
				}
			}
			// Otherwise, declare the ceiling block null
			if (doesNotOvelapAt(x, y - frameHeight, allBlocks))
			{
				ceiling = null;
			}	
		}
		
		public function towerHeight():Number
		{
			// Recursive function that determines tower height
			return towerHeightHelper(this);
		}
		
		public function towerHeightHelper(block:Block):Number
		{
			// Is this the top block in the flavor tower?
			if (block.ceiling == null || block.ceiling.flavor != block.flavor)
			{
				// Yes, start the height count at 1
				return 1;
			}
			// Otherwise, add 1 to the running count
			return towerHeightHelper(block.ceiling) + 1;
		}
		
		public function isMaxTowerHeight():Boolean {return towerHeight() == maxTowerHeight;}
		
		public function tower():FlxGroup
		{
			var group:FlxGroup = new FlxGroup();
			group.add(this)
			// Recursive function that determines the tower itself
			return towerHelper(this,group);
		}
		
		public function towerHelper(block:Block,group:FlxGroup):FlxGroup
		{
			// Is this the top block in the flavor tower?
			if (block.ceiling == null || block.ceiling.flavor != block.flavor)
			{
				// Yes, this is the complete tower
				return group;
			}
			// Otherwise, add the block's ceiling to the tower
			group.add(block.ceiling);
			return towerHelper(block.ceiling,group);
		}
		
		override public function update():void
		{	
			// Update the action timer
			// (The block folls after cycles of the timer)
			actionTimer += FlxG.elapsed;
			
			// Is the block in a falling cycle?
			if (actionTimer >= maxActionTimer)
			{
				// Yes, reset action timer
				actionTimer = 0;
				
				// Then steady fall
				steadyFall();
			}
			
			// Keep track of ceiling
			addCeiling();
		}
	}
}