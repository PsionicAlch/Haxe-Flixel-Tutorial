import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

/**
 * Class to represent the player character.
 */
class Player extends FlxSprite
{
	// A constant to represent how fast the player can move.
	static inline var MOVEMENT_SPEED:Float = 350;

	/**
	 * Player class' constructor. Used to set the player's initial position
	 * along with a few other things we need to initialize when creating the 
	 * player.
	 * @param x The X position of the player. 
	 * @param y The Y position of the player.
	 */
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		// Give the player a temporary orange square to represent it.
		makeGraphic(20, 20, FlxColor.ORANGE);

		// Set the player's X and Y drag so that they don't move forever.
		drag.x = drag.y = 1600;
	}

	override function update(elapsed:Float)
	{
		movement();

		super.update(elapsed);
	}

	/**
	 * Handle's player movement based on the user's input. This function is
	 * from the Haxe Flixel tutorial at https://haxeflixel.com/documentation/groundwork/
	 */
	private function movement()
	{
		// Initial variable setup to represent the direction in which the
		// player character is moving.
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		// Check for user input.
		up = FlxG.keys.anyPressed([W]);
		down = FlxG.keys.anyPressed([S]);
		left = FlxG.keys.anyPressed([A]);
		right = FlxG.keys.anyPressed([D]);

		// Check to make sure that the user isn't pressing opposite keys
		// at the same time.
		if (up && down)
		{
			up = down = false;
		}

		if (right && left)
		{
			right = left = false;
		}

		if (up || down || left || right)
		{
			var newAngle:Float = 0;

			if (up)
			{
				newAngle = -90;

				if (left)
				{
					newAngle -= 45;
				}
				else if (right)
				{
					newAngle += 45;
				}
			}
			else if (down)
			{
				newAngle = 90;

				if (left)
				{
					newAngle += 45;
				}
				else if (right)
				{
					newAngle -= 45;
				}
			}
			else if (left)
			{
				newAngle = 180;
			}
			else if (right)
			{
				newAngle = 0;
			}

			velocity.set(MOVEMENT_SPEED, 0);
			velocity.rotate(FlxPoint.weak(0, 0), newAngle);
		}
	}
}
