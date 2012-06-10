package
{		
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="assets/you.png")] private var ImgPlayer:Class;
		
		public var actionTimer:Number = 0;
		public var block:Block = null;
		
		public function Player()
		{
			super(FlxG.width/2, FlxG.height - 8);
			loadGraphic(ImgPlayer,false,true);
			facing = RIGHT;
			acceleration.y = 222;
		}
		
		public function facingLeft():Boolean {return facing == LEFT;}
		
		public function facingRight():Boolean {return facing == RIGHT;}
		
		public function move(dx:Number,dy:Number):void
		{
			dx *= frameWidth;
			dy *= frameHeight;
			
			// Can the player move forward?
			if (canMove(dx,dy) || (block != null && canMove(dx*2,dy*2)))
			{	
				var blocks:FlxGroup = new FlxGroup;
				// Yes, should the player push a block?
				if (block != null && block.canMove(dx,dy))
				{
					// Yes, prepare the block to be pushed
					blocks.add(block);
				}
				// Move the prepared block (yes, this is extremely circuitous...)
				for (var i:String in blocks.members)
				{
					blocks.members[i].move(dx,dy);
				}
				// Move the player
				x += dx;
				y += dy;
			}
		}
		
		public function canMove(dx:Number,dy:Number):Boolean
		{
			// Bound the block within the frame from left and right
			return x + dx >= 0 && x + dx <= FlxG.width - frameWidth;
		}
		
		override public function update():void
		{	
			actionTimer += FlxG.elapsed;
			// Should action timer reset?
			if (actionTimer >= 0.11)
			{
				// Yes, reset action timer
				actionTimer = 0;
				// Was left pressed?
				if (FlxG.keys.LEFT)
				{
					// Yes, move left
					move(-1,0);
					// Is player holding a block?
					if (block == null)
					{
						// No, so turn to face left
						facing = LEFT;
					}
				}
				// Was right pressed?
				if (FlxG.keys.RIGHT)
				{
					// Yes, move right
					move(1,0);
					// Is player holding a block?
					if (block == null)
					{
						// No, so turn to face right
						facing = RIGHT;
					}
				}
			}
			// Should the player jump?
			if ((isTouching(FLOOR)) && (FlxG.keys.justPressed("SPACE")))
			{
				// Yes, jump!
				velocity.y = -acceleration.y*0.222;
			}
		}
	}
}