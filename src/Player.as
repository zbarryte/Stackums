package
{		
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="assets/you.png")] private var ImgPlayer:Class;
		
		public var actionTimer:Number = 0;
		public var block:Block = null;
		public var state:PlayState;
		public var maxJumpHeight:Number = 1.5;
		public var jumpHeight:Number = maxJumpHeight;
		
		public function Player()
		{
			super(FlxG.width/2, FlxG.height - 8);
			loadGraphic(ImgPlayer,false,true);
			facing = RIGHT;
		}
		
		public function facingLeft():Boolean {return facing == LEFT;}
		
		public function facingRight():Boolean {return facing == RIGHT;}
		
		public function steadyFall():void {move(0,0.5);}
		
		public function isPulling(dx:Number):Boolean
		{
			return (facing == RIGHT && dx < 0) ||
				(facing == LEFT && dx > 0);
		}
		
		public function isPushing(dx:Number):Boolean
		{
			return (facing == RIGHT && dx > 0) ||
				(facing == LEFT && dx < 0);
		}
		
		public function move(dx:Number,dy:Number):void
		{		
			// Scale up dx and dy
			dx *= frameWidth;
			dy *= frameHeight;
						
			// Is the player holding a block?
			if (block != null)
			{
				// Is the player pushing?
				if (isPushing(dx))
				{
					// Yes, move the blocks first, then the player
					// (This prevents the player from colliding with the yet-to-be-moved block)
					block.move(dx,dy);
					if (canMove(dx,dy))
					{
						x += dx;
						y += dy;
					}
				}
				// Is the player pulling and not about to go through a wall/block?
				else if (isPulling(dx) && canMove(dx,dy))
				{
					// Yes, move the player first, then the block
					// (This prevents the block from colliding with the yet-to-be-moved player)
					x += dx;
					y += dy;
					block.move(dx,dy);
				}
			}
			// No, the player's not holding a block, but can the player move?
			else if (canMove(dx,dy))
			{
				// Yes, so move!
				x += dx;
				y += dy;
				
				// Is the player falling?
				if (dy < 0)
				{
					// Yes, increment the jump height
					jumpHeight += -dy/frameHeight;
				}
			}
		}
		
		public function canMove(dx:Number,dy:Number):Boolean
		{
			// Find potential position
			var X:Number = x + dx;
			var Y:Number = y + dy;
			
			// Check if potential position goes out of bounds or collides
			return (X >= 0
				&& X <= FlxG.width - frameWidth
				&& Y <= FlxG.height - frameHeight
				&& Y >= 0
				&& doesNotOverlapAt(X, Y, state.allBlocks)
				// (Checks overlapping for both the top and bottom of the player)
				&& doesNotOverlapAt(X, Y + frameHeight/2, state.allBlocks));
		}
		
		public function doesNotOverlapAt(X:Number,Y:Number,group:FlxGroup):Boolean
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
		
		public function jump():void {move(0,-0.5);}
		
		public function continueJumpOrSteadyFall():void
		{			
			if (jumpHeight < maxJumpHeight)
			{
				jump();
			}
			else
			{
				steadyFall();
			}
		}
		
		override public function update():void
		{	
			// Update the action timer
			actionTimer += FlxG.elapsed;
			
			// Was a command entered?
			if (FlxG.keys.justPressed("LEFT") ||
				FlxG.keys.justPressed("RIGHT") ||
				FlxG.keys.justPressed("SPACE"))
			{
				// Yes, set
				actionTimer = 0.1;
			}
			
			// Should action timer reset?
			if (actionTimer >= 0.1)
			{
				
				// Yes, reset action timer
				actionTimer = 0;
				
				//			trace("can't move down?", !canMove(0,1));
				//						trace("space pressed?", FlxG.keys.justPressed("SPACE"));
				//			trace("space released", FlxG.keys.justReleased("SPACE"));
				
//				trace("can't fall down?", !canMove(0,0.5));
//				trace("space just pressed?", FlxG.keys.justPressed("SPACE"));
				
				// Should the player jump?
				if (!canMove(0,frameHeight/2) && FlxG.keys.justPressed("SPACE"))//((isTouching(FLOOR)) && (FlxG.keys.justPressed("SPACE")))
				{
					jumpHeight = 0;
					// Yes, jump!
					//velocity.y = -acceleration.y*0.222;
					jump();
				}
				continueJumpOrSteadyFall();
				
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
		}
	}
}