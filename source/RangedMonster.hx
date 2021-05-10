import MonsterProjectile.MonsterProjectileType;
import MonsterProjectile;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class RangedMonster extends FlxSprite
{
	// The basic variables of each ranged monster.
	private var _armor:Float;
	private var _target:FlxObject;
	private var _projectileType:MonsterProjectileType;
	private var _lastShot:Float;
	private var _shotVar:Float;
	private var _shouldFire:Bool;

	public function new(x:Float, y:Float, target:FlxObject, projectileType:MonsterProjectileType)
	{
		super(x, y);

		_armor = 0;
		this._target = target;
		this._projectileType = projectileType;
		_lastShot = 0;
		_shotVar = Random.float(0.5, 3);
		_shouldFire = false;

		makeGraphic(20, 20, FlxColor.CYAN);
	}

	override function update(elapsed:Float)
	{
		_lastShot += elapsed;

		if (_lastShot >= _shotVar)
		{
			_lastShot = 0;
			_shouldFire = true;
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
	public function getProjectileType():MonsterProjectileType
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
