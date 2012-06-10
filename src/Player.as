package
{		
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="assets/you.png")] private var ImgPlayer:Class;
		public var counter:Number = 0;
		public var blocks:FlxGroup = new FlxGroup();
		public var allBlocks:FlxGroup = new FlxGroup();
		
		public function Player()
		{
			super(FlxG.width/2, FlxG.height - 8);
			loadGraphic(ImgPlayer,false,true);
			facing = RIGHT;
			acceleration.y = 222;
			
		}
		
		public function facingLeft():Boolean
		{
			return facing == LEFT;
		}
		
		public function facingRight():Boolean
		{
			return facing == RIGHT;
		}
		
		public function move(dx:Number,dy:Number):void
		{
			dx *= frameWidth
			dy *= frameHeight
			
			trace(canMove(dx,dy));
			if (canMove(dx,dy) || canMove(dx*2,dy*2))
			{	
				var i:String;
				var canMoveBlocks:Boolean = true;
				for (i in blocks.members)
				{
					if (!blocks.members[i].canMove(dx,dy))
					{
//						var X:Number = blocks.members[i].x;
//						var Y:Number = blocks.members[i].y;
//						trace(X+dx >=0, X+dx <= FlxG.width - 4, Y + dy <= FlxG.height - 4, !overlapsAt(X + dx, Y + dy, allBlocks));
//						trace("this block shouldn't move");
//						trace(blocks.members[i].x + dx, blocks.members[i].y + dy);
						canMoveBlocks = false;
					}
				}
				if (canMoveBlocks)
				{
					for (i in blocks.members)
					{
						blocks.members[i].move(dx,dy);
					}
					x += dx;
					y += dy;
				}
			}
			
		}
		
		public function canMove(dx:Number,dy:Number):Boolean
		{
			return (!overlapsAt(x + dx, y + dy, allBlocks)
				&& x + dx >= 0
				&& x + dx <= FlxG.width - frameWidth);
		}
		
		override public function update():void
		{	
			counter += FlxG.elapsed;
			if (counter >= 0.11)
			{
				counter = 0;
				if (FlxG.keys.LEFT)
				{
					move(-1,0);
					if (blocks.members.length <= 0)
					{
						facing = LEFT;
					}
				}
				if (FlxG.keys.RIGHT)
				{
					move(1,0);
					if (blocks.members.length <= 0)
					{
						facing = RIGHT;
					}
				}
			}
			
			if (isTouching(FLOOR))
			{
				if (FlxG.keys.justPressed("SPACE"))
				{
					velocity.y = -acceleration.y*0.222;
				}
			}
		}
	}
}