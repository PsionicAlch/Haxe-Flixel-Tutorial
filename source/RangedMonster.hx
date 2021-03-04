import Projectile.ProjectileType;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class RangedMonster extends FlxSprite implements IMonster
{
	private var _damage_per_seconds:Float;
	private var _armor:Float;
	private var _movement_speed:Float;
	private var _target:FlxObject;
	private var _projectileType:ProjectileType;
	private var _lastShot:Float;
	private var _shotVar:Float;

	public function new(x:Float, y:Float, target:FlxObject, projectileType:ProjectileType)
	{
		super(x, y);

		_damage_per_seconds = 0;
		_armor = 0;
		_movement_speed = 0;
		this._target = target;
		this._projectileType = projectileType;
		_lastShot = 0;
		_shotVar = Random.int(0, 5);

		makeGraphic(20, 20, FlxColor.BLUE);
	}

	public function getTarget():FlxObject
	{
		return this._target;
	}

	public function getProjectileType():ProjectileType
	{
		return this._projectileType;
	}

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
