import Projectile.ProjectileType;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * Class to represent the player character.
 */
class Player extends FlxSprite
{
	// A constant to represent how fast the player can move.
	static inline var MOVEMENT_SPEED:Float = 350;

	private var _projectileType: ProjectileType;

	/**
	 * Player class' constructor. Used to set the player's initial position
	 * along with a few other things we need to initialize when creating the 
	 * player.
	 * @param x The X position of the player. 
	 * @param y The Y position of the player.
	 */
	public function new(x:Float = 0, y:Float = 0, ?projectileType = ProjectileType.FIRE_BOLT)
	{
		super(x, y);

		// Load the sprite sheet.
		loadGraphic(AssetPaths.Player__png, true, 16, 16);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);

		// Set the animations.
		animation.add("resting down", [0, 1, 2], 3, true);
		animation.add("resting right", [3, 4, 5], 3, true);
		animation.add("resting left", [3, 4, 5], 3, true);
		animation.add("resting up", [6, 7, 8], 3, true);
		animation.add("attack down", [9], 1, false);
		animation.add("attack right", [10], 1, false);
		animation.add("attack left", [10], 1, false);
		animation.add("attack up", [11], 1, false);
		animation.add("walking down", [12, 13, 14, 15], 4, true);
		animation.add("walking right", [16, 17, 18, 19], 4, true);
		animation.add("walking left", [16, 17, 18, 19], 4, true);
		animation.add("walking up", [20, 21, 22, 23], 4, true);

		// Set the player's X and Y drag so that they don't move forever.
		drag.x = drag.y = 1600;

		health = 100;

		_projectileType = projectileType;
	}

	override function update(elapsed:Float)
	{
		movement();
		animate();

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

				facing = FlxObject.UP;
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

				facing = FlxObject.DOWN;
			}
			else if (left)
			{
				newAngle = 180;
				facing = FlxObject.LEFT;
			}
			else if (right)
			{
				newAngle = 0;
				facing = FlxObject.RIGHT;
			}

			velocity.set(MOVEMENT_SPEED, 0);
			velocity.rotate(FlxPoint.weak(0, 0), newAngle);
		}
	}

	private function animate()
	{
		if (velocity.x != 0 || velocity.y != 0)
		{
			switch (facing)
			{
				case FlxObject.UP:
					animation.play("walking up");
				case FlxObject.LEFT:
					animation.play("walking left");
				case FlxObject.DOWN:
					animation.play("walking down");
				case FlxObject.RIGHT:
					animation.play("walking right");
			}
		}
		else if (velocity.x == 0 || velocity.y == 0)
		{
			switch (facing)
			{
				case FlxObject.UP:
					animation.play("resting up");
				case FlxObject.LEFT:
					animation.play("resting left");
				case FlxObject.DOWN:
					animation.play("resting down");
				case FlxObject.RIGHT:
					animation.play("resting right");
			}
		}
	}

	public function fire()
	{
		switch (facing)
		{
			case FlxObject.UP:
				animation.play("attack up");
			case FlxObject.LEFT:
				animation.play("attack left");
			case FlxObject.DOWN:
				animation.play("attack down");
			case FlxObject.RIGHT:
				animation.play("attack right");
		}
	}

	public function setProjectileType(projectileType: ProjectileType)
	{
		this._projectileType = projectileType;
	}

	public function getProjectileType(): ProjectileType
	{
		return this._projectileType;
	}
}
