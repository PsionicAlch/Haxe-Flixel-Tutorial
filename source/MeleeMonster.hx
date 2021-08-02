import flixel.util.FlxPath;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;

enum MeleeType
{
	ZOMBIE;
	SKELETON;
}

/**
 * A class to represent the basic melee character.
 */
class MeleeMonster extends FlxSprite
{
	private var _damage_per_seconds:Float; // The amount of damage the character can do.
	private var _armor:Float; // The amount of armor they have.
	private var _movement_speed:Float; // Their movement speed.
	private var _target:FlxObject; // What they are targeting.
	private var _type:MeleeType; // What type of monster is this.

	public function new(x:Float, y:Float, target:FlxObject, type:MeleeType)
	{
		super(x, y);

		this.health = 20;
		this._movement_speed = Random.int(10, 100);
		this._target = target;
		this._type = type;

		switch type
		{
			case ZOMBIE:
				loadGraphic(AssetPaths.Zombie__png, true, 16, 16);
				setFacingFlip(FlxObject.RIGHT, false, false);
				setFacingFlip(FlxObject.LEFT, false, false);

				animation.add("resting down", [0, 1, 2], 3, true);
				animation.add("resting right", [3, 4, 5], 3, true);
				animation.add("resting left", [6, 7, 8], 3, true);
				animation.add("resting up", [9, 10, 11], 3, true);

				animation.add("walking down", [12, 13, 14, 15], 4, true);
				animation.add("walking right", [16, 17], 2, true);
				animation.add("walking left", [18, 19], 2, true);
				animation.add("walking up", [20, 21, 22, 23], 4, true);
			case SKELETON:
				loadGraphic(AssetPaths.Skeleton__png, true, 16, 16);
				setFacingFlip(FlxObject.RIGHT, false, false);
				setFacingFlip(FlxObject.LEFT, true, false);

				animation.add("resting down", [0, 1, 2], 3, true);
				animation.add("resting right", [3, 4, 5], 3, true);
				animation.add("resting left", [3, 4, 5], 3, true);
				animation.add("resting up", [6, 7, 8], 3, true);

				animation.add("walking down", [9, 10, 11, 12], 4, true);
				animation.add("walking right", [13, 14, 15, 16], 4, true);
				animation.add("walking left", [13, 14, 15, 16], 4, true);
				animation.add("walking up", [17, 18, 19, 20], 4, true);
		}

		this.path = new FlxPath();
	}

	override function update(elapsed:Float)
	{
		ai();
		animate();

		super.update(elapsed);
	}

	/**
	 * A function to dictate what the monster does.
	 */
	private function ai():Void
	{
		// Tell the monster to head for the player.

		if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
		{
			if (Math.abs(velocity.x) > Math.abs(velocity.y))
			{
				if (velocity.x < 0)
					facing = FlxObject.LEFT;
				else
					facing = FlxObject.RIGHT;
			}
			else
			{
				if (velocity.y < 0)
					facing = FlxObject.UP;
				else
					facing = FlxObject.DOWN;
			}
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

	public function move()
	{
		FlxVelocity.moveTowardsPoint(this, _target.getPosition(), Std.int(_movement_speed));
	}

	public function getMovementSpeed(): Float
	{
		return this._movement_speed;
	}
}
