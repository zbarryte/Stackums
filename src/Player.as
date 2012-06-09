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
			if (canMove(dx,dy))
			{	
				var i:String;
				var moveBlocks:Boolean = true;
				for (i in blocks.members)
				{
					if (!blocks.members[i].canMove(dx,dy))
					{
						trace(blocks.members[i].x, blocks.members[i].y);
						moveBlocks = false;
					}
				}
				if (moveBlocks)
				{
					for (i in blocks.members)
					{
						blocks.members[i].move(dx,dy);
					}
					x += dx*frameWidth;
					y += dy*frameHeight;
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
//			trace(blocks.members.length);
			counter += FlxG.elapsed;
			if (counter >= 0.11)
			{
				counter = 0;
//				var block:Block;
//				var i:String;
//				var moveBlocks:Boolean = true;
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
				
//				if (FlxG.keys.LEFT && x - frameWidth >= 0)
//				{
//					if (blocks.members.length > 0)
//					{
////						move(-1,0)
//						x -= frameWidth;
//						for (i in blocks.members)
//						{
//							block = blocks.members[i];
////							block.move(-1,0);
//							if (block.overlapsAt(block.x - frameWidth,block.y,allBlocks))// &&!overlapsAt(x - frameWidth, y, allBlocks))
//							{
//								moveBlocks = false;
////								block.x -= frameWidth;
////								x -= frameWidth;
//							}
//						}
//						if (moveBlocks)
//						{
//							for (i in blocks.members)
//							{
//								block = blocks.members[i];
//								trace(block.x,block.y);
//								block.x -= frameWidth;
//							}
//						}
//					}
//					else if (blocks.members.length <=0)
//					{
//						x -= frameWidth;
////						move(-1,0)
//						facing = LEFT;
//					}
//				}				
//				if (FlxG.keys.RIGHT && x + frameWidth <= FlxG.width - frameWidth)
//				{
//					if (blocks.members.length > 0)
//					{
////						move(1,0);
//						x += frameWidth;
//						for (i in blocks.members)
//						{
//							block = blocks.members[i];
////							block.move(1,0);
//							if (block.overlapsAt(block.x + frameWidth,block.y,allBlocks))// && !overlapsAt(x + frameWidth, y, allBlocks))
//							{
//								moveBlocks = false;
////								block.x += frameWidth;
////								x += frameWidth;
//							}
//						}
//						if (moveBlocks)
//						{
//							for (i in blocks.members)
//							{
//								block = blocks.members[i];
//								block.x += frameWidth;
//							}
//						}
//					}
//					else if (blocks.members.length <= 0)
//					{
////						move(1,0);
//						facing = RIGHT;
//						x += frameWidth;
//					}
//					
//				}
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