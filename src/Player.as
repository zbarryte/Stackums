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
			//acceleration.y = 222;
		}
		
		public function facingLeft():Boolean {return facing == LEFT;}
		
		public function facingRight():Boolean {return facing == RIGHT;}
		
		public function steadyFall():void {move(0,0.5);}
		
		public function move(dx:Number,dy:Number):void
		{			
			dx *= frameWidth;
			dy *= frameHeight;
			
			//trace(canMove(dx,dy));
//			trace("can move?",canMove(dx,dy),dx,dy);
			
			// Can the player move forward? (or can the player push the block into an open spot?)
			if (canMove(dx,dy))// || (block != null && block.canMove(dx,dy)))// || (block != null && canMove(dx*2,dy*2)))
			{	
//				if (block != null && block.canMove(dx,dy))
//				{
//					dy = 0;
//				}
				
				// Move the player
				x += dx;
				y += dy;
				
//				var blocks:FlxGroup = new FlxGroup;
//				// Yes, should the player push a block?
//				if (block != null && block.canMove(dx,dy))
//				{
//					// Yes, prepare the block to be pushed
//					blocks.add(block);
//				}
//				// Move the prepared block (yes, this is extremely circuitous...)
//				for (var i:String in blocks.members)
//				{
//					blocks.members[i].move(dx,dy);
//				}
				
				if (block != null)
				{
					block.move(dx,dy);
				}
				
				if (dy < 0)
				{
					jumpHeight += -dy/frameHeight;
//					trace(jumpHeight);
				}
			}
		}
		
		public function canMove(dx:Number,dy:Number):Boolean
		{
//			trace("does not overlap", doesNotOverlapAt(x + dx, y + dy + frameHeight/2, state.allBlocks));
//			trace("doesn't overlap", doesNotOverlapAt(x+dx,y+dy,state.allBlocks));
//			trace("not does overlap",!overlapsAt(x+dx,y+dy,state.allBlocks));
			//trace(y + dy <= FlxG.height - frameHeight);
			// Bound the block within the frame from left and right
			return (x + dx >= 0
				&& x + dx <= FlxG.width - frameWidth
				&& y + dy <= FlxG.height - frameHeight
//				&& y + dy + frameHeight/2 <= FlxG.height -frameHeight
				&& y + dy >= 0
//				&& y + dy + frameHeight/2 >= 0
				&& doesNotOverlapAt(x + dx, y + dy, state.allBlocks)
				&& doesNotOverlapAt(x + dx, y + dy + frameHeight/2, state.allBlocks));
			//|| (block != null && block.x == x + dx && block.y == y + dy + frameHeight/2);
		}
		
		public function doesNotOverlapAt(X:Number,Y:Number,group:FlxGroup):Boolean
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
		
		public function jump():void
		{
			//for (var i:Number = 0; i <= 3; i++)
//			if (jumpHeight < maxJumpHeight)
//			{
//			jumpHeight += 1;
//			trace("can move in loop?", canMove(0,-0.5));
			move(0,-0.5);
//			}
		}
		
		public function continueJumpOrSteadyFall():void
		{			
			if (jumpHeight < maxJumpHeight)
			{
				jump();
			}
			else
			{
//				trace("steady falling");
				steadyFall();
			}
		}
		
		override public function update():void
		{	
			
			actionTimer += FlxG.elapsed;
			if (FlxG.keys.justPressed("LEFT") ||
				FlxG.keys.justPressed("RIGHT") ||
				FlxG.keys.justPressed("SPACE"))
			{
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