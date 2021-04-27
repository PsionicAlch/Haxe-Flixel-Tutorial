import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.gamepad.id.SwitchJoyconLeftID;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;

enum ProjectileType
{
	FIRE_BOLT;
	ICE_BOLT;
	POISON_BOLT;
	SHOCK_BOLT;
}

class Projectile extends FlxSprite
{
	private static inline var MOVEMENT_SPEED:Float = 600;

	private var _target:FlxPoint;
	private var _type:ProjectileType;
	private var _durationAlive:Float;
	private var _spawner:FlxObject;

	/**
	 * Used to create a new projectile that travels towards where the player
	 * clicked.
	 * @param x The player's X position. 
	 * @param y The player's Y position.
	 * @param target The point where the mouse was clicked.
	 * @param type The type of projectile.
	 */
	public function new(x:Float, y:Float, target:FlxPoint, type:ProjectileType, spawner:FlxObject)
	{
		super(x, y);
		_target = target;
		_type = type;
		_spawner = spawner;

		switch (type)
		{
			case FIRE_BOLT:
				loadGraphic(AssetPaths.Fire_Bolt__png, true, 16, 16);
			case ICE_BOLT:
				loadGraphic(AssetPaths.Ice_Bolt__png, true, 16, 16);
			case POISON_BOLT:
				loadGraphic(AssetPaths.Poison_Bolt__png, true, 16, 16);
			case SHOCK_BOLT:
				loadGraphic(AssetPaths.Shock_Bolt__png, true, 16, 16);
		}

		animation.add("moving", [0, 1], 2, true);
		animation.add("explosion", [2], 1, false);

		velocity.set(MOVEMENT_SPEED, 0);
		velocity.rotate(FlxPoint.weak(0, 0), FlxAngle.angleBetweenPoint(this, _target, true));

		animation.play("moving");
	}

	override function update(elapsed:Float)
	{
		_durationAlive += elapsed;

		super.update(elapsed);
	}

	public function getTarget():FlxPoint
	{
		return _target;
	}

	public function setTarget(newTarget:FlxPoint)
	{
		_target = newTarget;
	}

	/**
	 * Getter for the projectile type.
	 * @return ProjectileType
	 */
	public function getType():ProjectileType
	{
		return _type;
	}

	/**
	 * Getter for the amount of time the projectile has been alive.
	 * @return Float
	 */
	public function getDurationAlive():Float
	{
		return _durationAlive;
	}

	public function getSpawner():FlxObject
	{
		return _spawner;
	}

	public function explode()
	{
		animation.play("explosion");
	}
}
