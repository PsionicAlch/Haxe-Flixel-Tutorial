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
	private var _shouldFire:Bool; // Whether or not the monster should shoot.

	public function new(x:Float, y:Float, target:FlxObject, projectileType:ProjectileType)
	{
		super(x, y);

		_armor = 0;
		_target = target;
		_projectileType = projectileType;
		_lastShot = 0;
		_shotVar = Random.int(0, 5);
		_shouldFire = false;

		makeGraphic(20, 20, FlxColor.CYAN);
	}

	override function update(elapsed:Float)
	{
		_lastShot += elapsed;

		// Check to see if the monster should shoot or not.
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
	 * @return FlxObject
	 */
	public function getTarget():FlxObject
	{
		return _target;
	}

	/**
	 * Getter for the type of projectile the monster uses.
	 * @return ProjectileType
	 */
	public function getProjectileType():ProjectileType
	{
		return _projectileType;
	}

	/**
	 * Getter for whether or not the monster should shoot.
	 * @return Bool
	 */
	public function getShouldFire():Bool
	{
		return _shouldFire;
	}
}
