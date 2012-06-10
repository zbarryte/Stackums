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
		protected var currentBlock:Block = new Block();
		private var blocks:FlxGroup = new FlxGroup();
		private var allBlocks:FlxGroup = new FlxGroup();
		private var generating:Boolean = false;
		private var removeBlocks:FlxGroup = new FlxGroup();
		
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
			currentBlock = new Block(FlxG.width/2 -  8,FlxG.height - 4);
			add(currentBlock);
			blocks.add(currentBlock);
			allBlocks.add(currentBlock);
			currentBlock.allBlocks = allBlocks;
//			
			currentBlock = new Block(FlxG.width/2 -  4,FlxG.height - 4);
			add(currentBlock);
			allBlocks.add(currentBlock);
			currentBlock.allBlocks = allBlocks;
			blocks.add(currentBlock);
			
//			trace(currentBlock.allBlocks.members.length);
			
//			currentBlock = new Block(FlxG.width/2 -  8,FlxG.height - 8);
//			add(currentBlock);
//			blocks.add(currentBlock);
//			allBlocks.add(currentBlock);
//			currentBlock.allBlocks = allBlocks;
		}
		
		public function generateBlocks():void
		{
			if (!generating)
			{
//				trace("beginning generating");
				generating = true;
				
				currentBlock = new Block(0,8);//(Math.floor(Math.random()*FlxG.width/4)*4, 8);
				add(currentBlock);
//				blocks.add(currentBlock);
				allBlocks.add(currentBlock);
				currentBlock.allBlocks = allBlocks;
				
//				for (var i:String in allBlocks)
//				{
//					allBlocks.members[i].allBlocks = allBlocks;
//				}
				
//				currentBlock.allBlocks = allBlocks;
//				trace(currentBlock.allBlocks.members.length);
//				trace(player.allBlocks.members.length);
			}
			if (currentBlock.landed)//(!currentBlock.canMove(0,currentBlock.frameHeight))
			{
//				trace("generating a new block");
				blocks.add(currentBlock);
				generating = false;
//				trace(blocks.members.length);
				generateBlocks();
			}
		}
		
		public function removeBlock(block:Block):void
		{
			remove(block);
			removeBlocks.add(block);
			allBlocks.remove(block);
//			blocks.remove(block);
		}
		
		override public function update():void
		{
			
//			trace(!currentBlock.canMove(0,currentBlock.frameHeight));
//			var dx:Number = currentBlock.frameWidth;
//			var dy:Number = currentBlock.frameHeight;
//			var X:Number = currentBlock.x;
//			var Y:Number = currentBlock.y;
//			trace(X+dx >=0, X+dx <= FlxG.width - 4, Y + dy <= FlxG.height - 4, !currentBlock.overlapsAt(X + dx, Y + dy, allBlocks));
			
//			for (var i:String in currentBlock.allBlocks.members)
//			{
//				trace(currentBlock.allBlocks.members[i].y);
//			}
			generateBlocks();
			
//			var tempBlocks:FlxGroup = new FlxGroup();
			var tempBlock:Block;
			
			if (FlxG.keys.X)
			{
				var block:Block;
				var i:String;
				if (player.facingLeft())
				{
					
					for (i in blocks.members)
					{
						block = blocks.members[i];
						if (block.x == player.x - 4 && block.y == player.y + 4)
						{
//							tempBlocks.add(block);
							tempBlock = block;
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
//							tempBlocks.add(block);
							tempBlock = block;
						}
					}
				}
			}
			if (tempBlock == null || !FlxG.keys.X)
//			if (tempBlocks.members.length <= 0 || !FlxG.keys.X)
			{
//				player.blocks.clear();
				player.block = null;
			}
			player.block = tempBlock;
//			player.blocks = tempBlocks;
			
//			else
//			{
//				player.blocks.clear();
//			}
//			var removeBlocks:FlxGroup = new FlxGroup;
			
			var tower:FlxGroup = new FlxGroup;
			
			for (i in allBlocks.members)
			{
				block = allBlocks.members[i];
				if (block.isThreeTall())
				// should really run up the chain, but let's do this for now
				{
					tower.add(block.ceiling.ceiling);
					tower.add(block.ceiling);
					tower.add(block);
//					removeBlocks(block.ceiling.ceiling);
//					removeBlocks(block.ceiling);
//					removeBlocks(block);
//					removeBlock(block.ceiling.ceiling);
//					removeBlock(block.ceiling);
//					removeBlock(block);
				}
			}
			
			for (i in tower.members)
			{
				block = tower.members[i];
				allBlocks.remove(block,true);
				remove(block,true);
			}
			
//			for (var k:String in allBlocks.members)
//			{
//				trace(allBlocks.members[k].x,allBlocks.members[k].y);
//			}
			
//			trace(removeBlocks.members.length);
			
//			if (removeBlocks.members.length > 0)
//			{
//				for (var j:String in removeBlocks.members)
//				{
//					trace("removing");
//					block = removeBlocks.members[j];
//					allBlocks.remove(block);
//				}
////				trace("got to clearing");
////				removeBlocks = new FlxGroup();
//				removeBlocks.clear();
//			}
//			allBlocks.clear();
			
//			trace(removeBlocks.members.length);
			
			
//			for (i in removeBlocks.members)
//			{
//				block = removeBlocks.members[i];
//				if (block != null)
//				{
//					removeBlock(block);
//				}
//			}
			
			super.update();
			FlxG.collide();
		}
	}
}