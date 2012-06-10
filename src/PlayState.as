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
		private var numBlocks:Number = 0;
		private var counter:Number = 0;
		private var winText:FlxText;
		private var playerDead:Boolean = false;
		
		override public function create():void
		{	
			floor = new FlxTileblock(0, FlxG.height, 224, 4);
			floor.loadGraphic(ImgFloor);
			add(floor);
			
			player = new Player();
			add(player);
					
			currentBlock = new Block(FlxG.width/2 -  8,FlxG.height - 4);
			add(currentBlock);
			blocks.add(currentBlock);
			allBlocks.add(currentBlock);
			currentBlock.allBlocks = allBlocks;
			numBlocks += 1;

			currentBlock = new Block(FlxG.width/2 -  8,FlxG.height - 8);
			add(currentBlock);
			allBlocks.add(currentBlock);
			currentBlock.allBlocks = allBlocks;
			blocks.add(currentBlock);
			numBlocks += 1;
			
			winText = new FlxText(0,0,40);
			winText.text = "you\nhave\nnot\nwon\n:(";
			winText.alignment = "center";
			winText.flicker(-1);
			add(winText);
		}
		
		public function generateBlocks():void
		{
			if (!generating)
			{
				generating = true;
				
				currentBlock = new Block(Math.floor(Math.random()*FlxG.width/4)*4, 8);
				add(currentBlock);
				allBlocks.add(currentBlock);
				currentBlock.allBlocks = allBlocks;
				numBlocks += 1;
			}
			if (currentBlock.landed)
			{
				blocks.add(currentBlock);
				generating = false;
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
			if (!playerDead)
			{
				if (numBlocks > 0)
				{
					if (currentBlock.x == player.x && currentBlock.y == player.y)
					{
						playerDead = true;
					}
					
					counter += FlxG.elapsed;
					if (counter >= 0.2)
					{
						counter = 0;
						generateBlocks();
					}
					
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
									tempBlock = block;
								}
							}
						}
					}
					if (tempBlock == null || !FlxG.keys.X)
					{
						player.block = null;
					}
					player.block = tempBlock;
					var tower:FlxGroup = new FlxGroup;
					
					for (i in allBlocks.members)
					{
						block = allBlocks.members[i];
						if (block.isMaxTowerHeight())
						{
							tower = block.tower();
						}
					}
					
					for (i in tower.members)
					{
						block = tower.members[i];
						allBlocks.remove(block,true);
						remove(block,true);
						numBlocks -= 1;
					}
				}
				else
				{
					winText.text = "YOU\nHAVE\nNOW\nWON!\n:D";
					
					if (FlxG.keys.X)
					{
						FlxG.resetGame();
					}
					
				}
				super.update();
				FlxG.collide();	
			}
			else
			{
				winText.text = "you\nare\nnow\ndead\n:|";
				if (FlxG.keys.X)
				{
					FlxG.resetGame();
				}
			}
		}
	}
}