package
{
	import flash.display.Loader;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.formats.BackgroundColor;
	
	import org.flixel.*;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	
	public class PlayState extends FlxState
	{		
		protected var player:Player;
		protected var currentBlock:Block = new Block();
		public var allBlocks:FlxGroup = new FlxGroup();
		private var removeBlocks:FlxGroup = new FlxGroup();
		private var numBlocks:Number = 0;
		private var generationTimer:Number = 0;
		private var maxGenerationTimer:Number = 0.2;
		private var winText:FlxText;
		private var coords:Array = new Array();
		private var blockFlavors:Dictionary = new Dictionary();
		private var flavors:Array = new Array();
		
		override public function create():void
		{	
			// Set up player
			player = new Player();
			player.state = this;
			add(player);
			
			// Set up block flavors awkwardly
			// (Embeds images and maps them to the strings)
			[Embed(source="assets/green.png")] var img0:Class;
			var str0:String = "green";
			blockFlavors[str0] = img0;
			flavors.push(str0);
			[Embed(source="assets/blue.png")] var img1:Class;
			var str1:String = "blue";
			blockFlavors[str1] = img1;
			flavors.push(str1);
			// To add more types of blocks, repeat this process
			// (We haven't discussed functionally different blocks, but making those would require subclassing blocks)
			
			// Set up coords
			coords = [
				new Point(FlxG.width/2 - 8,FlxG.height - 4),
				new Point(FlxG.width/2 - 8,FlxG.height - 8),
				new Point(FlxG.width/2 - 4,FlxG.height - 4),
				new Point(FlxG.width/2 - 4,FlxG.height - 8),
				new Point(FlxG.width/2, FlxG.height - 4),
				new Point(FlxG.width/2 - 16,FlxG.height - 4)];
			
			// Init blocks from coords
			initBlocksFromCoords();
			
			// Draw the win text
			winText = new FlxText(0,0,40);
			winText.text = "you\nhave\nnot\nwon\n:(";
			winText.alignment = "center";
			winText.flicker(-1);
			add(winText);
		}
		
		public function updateFlavors():void
		{
			// Clear old arry
			flavors = new Array();
			// Check the flavors of each block
			var block:Block;
			for (var i:String in allBlocks.members)
			{
				// Add each new flavor to the array of flavors
				block = allBlocks.members[i];
				if (notInFlavors(block.flavor))
				{
					flavors.push(block.flavor);
				}
			}
		}
		
		public function notInFlavors(guessFlavor:String):Boolean
		{
			// Check each flavor against the guessed flavor
			for (var i:String in flavors)
			{
				// There is a match, so it's already in the list of flavors
				if (flavors[i] == guessFlavor)
				{
					return false;
				}
			}
			// It matches none of the other flavors, so it's a new flavor
			return true;
		}
		
		public function initBlocksFromCoords():void
		{
			// Create a block at each listed coordinate
			var point:Point;
			for (var i:String in coords)
			{
				point = coords[i];
				addBlock(point.x,point.y,randomBlockFlavor());
			}
		}
		
		public function generateBlocks():void
		{
			// Is the current block done falling?
			if (currentBlock.hasLanded() || !currentBlock.alive)
			{		
				// Add a new block at a random x
				addBlock(Math.floor(Math.random()*FlxG.width/4)*4, 0, randomBlockFlavor());
			}
		}
		
		public function randomBlockFlavor():String
		{
//			// Take a random key from the dictionary
//			// (To do this, create an array from the keys, then pick a random element in that array)
//			var flavors:Array = new Array();
//			var length:Number = 0;
//			for (var str:String in blockFlavors)
//			{
//				flavors.push(str);
//				length += 1;
//			}
			
			return flavors[Math.floor(Math.random()*flavors.length)];
		}
		
		public function addBlock(X:Number,Y:Number,flavor:String):void
		{			
			// Create block with the image specified by the flavor
			currentBlock = new Block(X,Y,blockFlavors[flavor]);
			currentBlock.flavor = flavor;
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
					// Update flavors
					updateFlavors();
					
					// Generate blocks every cycle of the generation timer
					generationTimer += FlxG.elapsed;
					if (generationTimer >= maxGenerationTimer)
					{
						generationTimer = 0;
						generateBlocks();
					}
					
//					// Impatient?
//					if (FlxG.keys.DOWN)
//					{
//						// Speed up current block
//						currentBlock.maxActionTimer -= 0.1;
//					}
					
					// Grabbing block?
					if (FlxG.keys.X || FlxG.keys.Z)
					{
						player.block = null;
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