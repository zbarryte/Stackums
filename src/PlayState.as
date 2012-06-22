package
{
	import flash.geom.Point;
	
	import flashx.textLayout.formats.BackgroundColor;
	
	import org.flixel.*;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	
	public class PlayState extends FlxState
	{
		[Embed(source="assets/floor.png")] private var ImgFloor:Class;
		
		protected var player:Player;
		protected var currentBlock:Block = new Block();
		public var allBlocks:FlxGroup = new FlxGroup();
		private var removeBlocks:FlxGroup = new FlxGroup();
		private var numBlocks:Number = 0;
		private var generationTimer:Number = 0;
		private var maxGenerationTimer:Number = 0.2;
		private var winText:FlxText;
		private var playerDead:Boolean = false;
		private var coords:Array = new Array();
		
		override public function create():void
		{	
			// Set up player
			player = new Player();
			player.state = this;
			add(player);
			
			// Set up coords
			coords = [
				new Point(FlxG.width/2 - 8,FlxG.height - 4),
				new Point(FlxG.width/2 - 8,FlxG.height - 8),
				new Point(FlxG.width/2 - 4,FlxG.height - 4),
				new Point(FlxG.width/2 - 4,FlxG.height - 8),
				new Point(FlxG.width/2, FlxG.height - 4),
				new Point(FlxG.width/2 - 16,FlxG.height - 4)];
			
			// Init blocks from coords
			initBlocksFromCoords(coords);
			
			winText = new FlxText(0,0,40);
			winText.text = "you\nhave\nnot\nwon\n:(";
			winText.alignment = "center";
			winText.flicker(-1);
			add(winText);
		}
		
		
		public function initBlocksFromCoords(coords:Array):void
		{
			var point:Point;
			for (var i:String in coords)
			{
				point = coords[i];
				addBlock(point.x,point.y);
			}
		}
		
		public function generateBlocks():void
		{
			// Is the current block done falling?
			if (currentBlock.hasLanded() || !currentBlock.alive)
			{		
				// Add a new block at a random x
				addBlock(Math.floor(Math.random()*FlxG.width/4)*4, 0);
			}
		}
		
		public function addBlock(X:Number,Y:Number):void
		{
			// Create block
			currentBlock = new Block(X,Y);
			// Add block to list of blocks and to screen
			allBlocks.add(currentBlock);
			add(currentBlock);
			// Give current block knowledge of other blocks
			currentBlock.allBlocks = allBlocks;
			// Increment block count
			numBlocks += 1;
		}
		
		public function removeBlock(block:Block):void
		{
			// Only decrement block count if block is alive
			if (block.alive)
			{
				numBlocks -= 1;
			}
			// Remove block from list of blocks and from screen
			allBlocks.remove(block,true);
			remove(block,true);
			// Kill the block when done
			block.kill();
		}
		
		override public function update():void
		{					
			// Proceed with game if player is alive
			if (player.alive)
			{
				// Proceed with game if there are more than 0 live blocks
				if (numBlocks > 0)
				{	
					// Generate blocks every cycle of the generation timer
					generationTimer += FlxG.elapsed;
					if (generationTimer >= maxGenerationTimer)
					{
						generationTimer = 0;
						generateBlocks();
					}
					
					// Impatient?
					if (FlxG.keys.DOWN)
					{
						// Speed up current block
						currentBlock.maxActionTimer -= 0.1;
					}
					
					// Grabbing block?
					if (FlxG.keys.X)
					{
						var block:Block;
						var i:String;
						// Is the player facing left?
						if (player.facingLeft())
						{
							// Check if there is a block directly to the left
							for (i in allBlocks.members)
							{
								block = allBlocks.members[i];
								if (block.x == player.x - 4 && block.y == player.y + 4)
								{
									// Yes, grab this block
									player.block = block;
								}
							}
						}
						// Is the player facing right?
						else if (player.facingRight())
						{
							// Check if there is a block directly to the right
							for (i in allBlocks.members)
							{
								block = allBlocks.members[i];
								if (block.x == player.x + 4 && block.y == player.y + 4)
								{
									// Yes, grab this block
									player.block = block;
								}
							}
						}
					}
					// The player's not grabbing a block
					else
					{
						// Set the player's block to be null
						player.block = null;
					}
					
					// Set up list of towers to eliminate
					var towers:FlxGroup = new FlxGroup;
					for (i in allBlocks.members)
					{
						block = allBlocks.members[i];
						if (block.isMaxTowerHeight())
						{
							towers.add(block.tower());
						}
					}
					
					var tower:FlxGroup = new FlxGroup;
					var j:String;
					// Eliminate all blocks in each tower
					for (i in towers.members)
					{	
						tower = towers.members[i];
						for (j in tower.members)
						{
							removeBlock(tower.members[j]);
						}
					}
				}
				// All the blocks are gone, you've won!
				else
				{
					// Change text
					winText.text = "YOU\nHAVE\nNOW\nWON!\n:D";
					
					// Press X to reset game
					if (FlxG.keys.X)
					{
						FlxG.resetGame();
					}
					
				}
				super.update();
			}
			// The player's dead.  Oops.
			else
			{
				// Change text
				winText.text = "you\nare\nnow\ndead\n:|";
				
				// Press X to reset game
				if (FlxG.keys.X)
				{
					FlxG.resetGame();
				}
			}
		}
	}
}