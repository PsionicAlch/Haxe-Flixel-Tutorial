import Projectile.ProjectileType;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class RangedMonster extends FlxSprite
{
	private var _armor:Float; // The amount of armor the monster has.
	private var _target:FlxObject; // The monster's target.
	private var _projectileType:ProjectileType; // The type of projectile the monster uses.
	private var _lastShot:Float; // The last time the monster shot at the target.
	private var _shotVar:Float; // The variable for when the monster should fire.

	public function new(x:Float, y:Float, target:FlxObject, projectileType:ProjectileType)
	{
		super(x, y);

		_armor = 0;
		this._target = target;
		this._projectileType = projectileType;
		_lastShot = 0;
		_shotVar = Random.int(0, 5);

		makeGraphic(20, 20, FlxColor.BLUE);
	}

	/**
	 * Getter for the monster's target.
	 * @return FlxObject
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
	 * Function to check whether or not the monster should fire a shot.
	 * @param elapsed The time elapsed between frames (delta time).
	 * @return Bool Whether or not the monster should fire.
	 */
	public function shouldFire(elapsed:Float):Bool
	{
		_lastShot += elapsed;

		if (_lastShot >= _shotVar)
		{
			_lastShot = 0;
			return true;
		}

		return false;
	}
}
