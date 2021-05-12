import Projectile.ProjectileType;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class RangedMonster extends FlxSprite
{
	// The basic variables of each ranged monster.
	private var _target:FlxObject;
	private var _projectileType:ProjectileType;
	private var _lastShot:Float;
	private var _shotVar:Float;
	private var _shouldFire:Bool;

	public function new(x:Float, y:Float, target:FlxObject, projectileType:ProjectileType)
	{
		super(x, y);

		switch (projectileType)
		{
			case FIRE_BOLT:
				loadGraphic(AssetPaths.Dragon_Tower__png, true, 16, 16);
				animation.add("idle", [0], 1, false);
				animation.add("attack", [1, 2, 3], 3, false);
			case ICE_BOLT:
				loadGraphic(AssetPaths.Ice_Tower__png, true, 16, 16);
				animation.add("idle", [0, 1, 2, 3], 4, true);
				animation.add("attack", [4, 5, 6], 3, false);
			case POISON_BOLT:
				loadGraphic(AssetPaths.Poison_Tower__png, true, 16, 16);
				animation.add("idle", [0, 1, 2, 3, 4, 5], 6, true);
				animation.add("attack", [6, 7, 8], 3, false);
			case SHOCK_BOLT:
				loadGraphic(AssetPaths.Tesla_Tower__png, true, 16, 16);
				animation.add("idle", [0], 1, false);
				animation.add("attack", [1, 2, 3], 3, false);
		}

		animation.play("idle");

		this._target = target;
		this._projectileType = projectileType;
		_lastShot = 0;
		_shotVar = 1.0;
		_shouldFire = false;
	}

	override function update(elapsed:Float)
	{
		_lastShot += elapsed;

		if (_lastShot >= _shotVar)
		{
			_lastShot = 0;
			animation.play("attack");
		}

		if (animation.finished)
		{
			_shouldFire = true;
			animation.play("idle");
		}
		else
		{
			_shouldFire = false;
		}

		super.update(elapsed);
	}

	/**
	 * Getter for the monster's target.
	 * @return FlxObject The monster's target.
	 */
	public function getTarget():FlxObject
	{
		return this._target;
	}

	/**
	 * Getter for the type of projectile the monster uses.
	 * @return ProjectileType
	 */
	public function getProjectileType():ProjectileType
	{
		return this._projectileType;
	}

	/**
	 * Getter for whether or not the monster should fire.
	 * @return Bool
	 */
	public function getShouldFire():Bool
	{
		return _shouldFire;
	}
}
