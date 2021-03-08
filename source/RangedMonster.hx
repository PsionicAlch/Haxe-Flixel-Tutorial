import Projectile.ProjectileType;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class RangedMonster extends FlxSprite
{
	// The basic variables of each ranged monster.
	private var _armor:Float;
	private var _target:FlxObject;
	private var _projectileType:ProjectileType;
	private var _lastShot:Float;
	private var _shotVar:Float;

	public function new(x:Float, y:Float, target:FlxObject, projectileType:ProjectileType)
	{
		super(x, y);

		_armor = 0;
		this._target = target;
		this._projectileType = projectileType;
		_lastShot = 0;
		_shotVar = Random.float(0.5, 3);

		makeGraphic(20, 20, FlxColor.BLUE);
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
	 * A function to dictate whether or not the monster should fire a shot.
	 * @param elapsed Delta time.
	 * @return Bool Whether or not the monster should fire a shot.
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
