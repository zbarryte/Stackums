package
{		
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="assets/you.png")] private var ImgPlayer:Class;
		
		public var actionTimer:Number = 0;
		public var maxActionTimer:Number = 0.1;
		public var block:Block = null;
		public var state:PlayState;
		public var maxJumpHeight:Number = 1.5;
		public var jumpHeight:Number = maxJumpHeight;
		
		public function Player()
		{
			super(FlxG.width/2, 0);
			loadGraphic(ImgPlayer,false,true);
			facing = RIGHT;
		}
		
		public function facingLeft():Boolean {return facing == LEFT;}
		
		public function facingRight():Boolean {return facing == RIGHT;}
		
		public function steadyFall():void {move(0,0.5);}
		
		public function hasLanded():Boolean {return !canMove(0,frameHeight/2);}
				
		public function jump():void {block = null; move(0,-0.5);}
		
		public function isCrushed():Boolean
		{
			//Does at least one block overlap the player?
			var block:Block
			for (var i:String in state.allBlocks.members)
			{
				block = state.allBlocks.members[i];
				if ((block.x == x && block.y == y) || (block.x == x && block.y == y + frameHeight/2))
				{
					// Yes, the player is crushed
					return true;
				}
			}
			// No, the player is not yet crushed
			return false;
		}
		
		public function isPulling(dx:Number):Boolean
		{
			// Check if the player's facing opposite the direction of motion
			return (facing == RIGHT && dx < 0) ||
				(facing == LEFT && dx > 0);
		}
		
		public function isPushing(dx:Number):Boolean
		{
			// Check if the player's facing the direction of motion
			return (facing == RIGHT && dx > 0) ||
				(facing == LEFT && dx < 0);
		}
		
		public function move(dx:Number,dy:Number):void
		{		
			// Scale up dx and dy
			dx *= frameWidth;
			dy *= frameHeight;
			
			// Is the player hanging?
			if (FlxG.keys.Z && block != null)
			{
				// Don't allow the player to accidentally pull/push the block
				dx = 0;
			}
						
			// Is the player holding a block?  If so it should move with the player.
			// (Note that moving a block moves all blocks above it)
			// (If the block grabbed is falling, the player should not be able to move it left or right)
			// (The player can, however, jump from tower to tower)
			if (block != null && (dx == 0 || block.hasLanded() || hasLanded()))
			{
				// Is the player pushing?
				// (Also must check if the block above can move, if it exists
				if (isPushing(dx) && (block.ceiling == null || block.ceiling.canMove(dx,dy)))
				{
					// Yes, move the block first, then the player
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
			
			// Check whether or not potential position goes out of bounds or collides with blocks
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
		
		public function continueJumpOrSteadyFall():void
		{
			// Can the player still go higher (without exceeding the max jump height?)
			// Also, make sure the player's still holding down the space bar.
			if (jumpHeight < maxJumpHeight && FlxG.keys.SPACE)
			{
				// Yes, keep going up.
				jump();
			}
			// Nope, the player's either reached the peak or isn't holdin space
			else
			{
				// Fall
				steadyFall();
			}
		}
		
		override public function update():void
		{	
			// Update the action timer
			// (The player only responds to key presses after cycles of the timer)
			actionTimer += FlxG.elapsed;
			
			// Was a command entered?
			if (FlxG.keys.justPressed("LEFT") ||
				FlxG.keys.justPressed("RIGHT") ||
				FlxG.keys.justPressed("SPACE"))
			{
				// Yes, set the timer to the max
				// (This allows the player to act on the key commands)
				actionTimer = maxActionTimer;
			}
			
			// Can the player accept actions?
			if (actionTimer >= maxActionTimer)
			{
				// Yes, reset action timer
				actionTimer = 0;
				
				// Jump?
				// (Able to jump if the player cannot fall or is clinding to a block, like wall jumping)
				if ((!canMove(0,frameHeight/2) || block != null) && FlxG.keys.justPressed("SPACE"))
				{
					// Yes, jump
					// (The Jump height tracks motion in the total dy of the jump)
					jumpHeight = 0;
					jump();
				}
				// The player should only fall when not jumping.
				continueJumpOrSteadyFall();
				
				// Move left?
				if (FlxG.keys.LEFT)
				{
					// Yes, move left
					move(-1,0);
					// Is the player holding a block?
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
					// Is the player holding a block?
					if (block == null)
					{
						// No, so turn to face right
						facing = RIGHT;
					}
				}
			}
			// Has the player been crushed?
			if (isCrushed())
			{
				// Kill the player
				this.kill();
			}
		}
	}
}