package
{
	import flashx.textLayout.formats.BackgroundColor;
	
	import org.flixel.*;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	
	public class PlayState extends FlxState
	{
		[Embed(source="assets/floor.png")] private var ImgFloor:Class;
		
		private var floor:FlxTileblock;
		protected var player:Player;
		protected var currentBlock:Block;
		private var blocks:FlxGroup = new FlxGroup();
		private var allBlocks:FlxGroup = new FlxGroup();
		private var generating:Boolean = false;
		
		override public function create():void
		{	
			floor = new FlxTileblock(0, FlxG.height, 224, 4);
			floor.loadGraphic(ImgFloor);
			add(floor);
			
			player = new Player();
			add(player);
			player.allBlocks = allBlocks;
			
			// this is dumb, clean it up with some generator later
			// meh
//			currentBlock = new Block(FlxG.width/2 + 4,FlxG.height - 4);
//			add(currentBlock);
//			blocks.add(currentBlock);
//			allBlocks.add(currentBlock);
//			currentBlock.allBlocks = allBlocks;
			
//			currentBlock = new Block(FlxG.width/2 + 4,FlxG.height -12);
//			add(currentBlock);
//			blocks.add(currentBlock);
//			allBlocks.add(currentBlock);
//			currentBlock.allBlocks = allBlocks;
//			
//			currentBlock = new Block(FlxG.width/2 -  8,FlxG.height - 8);
//			add(currentBlock);
//			blocks.add(currentBlock);
//			allBlocks.add(currentBlock);
//			currentBlock.allBlocks = allBlocks;
//			
			currentBlock = new Block(FlxG.width/2 -  8,FlxG.height - 4);
			add(currentBlock);
			blocks.add(currentBlock);
			allBlocks.add(currentBlock);
			currentBlock.allBlocks = allBlocks;
			
//			for (var i:String in blocks.members)
//			{
//				trace(blocks.members[i].x,blocks.members[i].y);
//			}
		}
		
		public function generateBlocks():void
		{
			if (!generating)
			{
				var dog:Number;
				generating = true;
				currentBlock = new Block(FlxG.width/2 - 8, 8);
				add(currentBlock);
				allBlocks.add(currentBlock);
				currentBlock.allBlocks = allBlocks;
			}
			if (currentBlock.canMove(0,1))
			{
				// do nothing at all even ever!
			}
			else
			{
				trace("generating a new block");
				blocks.add(currentBlock);
				generating = false;
				generateBlocks();
			}
		}
		
		override public function update():void
		{
			generateBlocks();
			
			var tempBlocks:FlxGroup = new FlxGroup();
			
//			if (FlxG.keys.X)
//			{
//				var block:Block;
//				var i:String;
//				if (player.facingLeft())
//				{
//					for (i in blocks.members)
//					{
//						blocks = blocks.members[i];
//						if (block.x == player.x - 4
//							&& block.y <= player.y + 4)
//						{
//							tempBlocks.add(block);
//						}
//					}
//				}
//				else if (player.facingRight())
//				{
//					for (i in blocks.members)
//					{
//						block = blocks.members[i];
//						if (block.x == player.x + 4
//							&& block.y <= player.y + 4)
//						{
//							tempBlocks.add(block);
//						}
//					}
//				}
//			}
			if (FlxG.keys.X)
			{
				var block:Block;
				var i:String;
				if (player.facingLeft())
				{
					for (i in blocks.members)
					{
						block = blocks.members[i];
						if (block.x == player.x - 4 && block.y <= player.y + 4)
						{
							tempBlocks.add(block);
						}
					}
				}
				if (player.facingRight())
				{
					for (i in blocks.members)
					{
						block = blocks.members[i];
						if (block.x == player.x + 4 && block.y <= player.y + 4)
						{
							tempBlocks.add(block);
						}
					}
				}
			}
			if (tempBlocks.members.length <= 0 || !FlxG.keys.X)
			{
				player.blocks.clear();
			}
			player.blocks = tempBlocks;
			
//			else
//			{
//				player.blocks.clear();
//			}
			
			super.update();
			FlxG.collide();
		}
	}
}