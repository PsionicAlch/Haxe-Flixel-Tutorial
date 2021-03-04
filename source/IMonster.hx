import flixel.FlxObject;

/**
 * An interface to define the basic layout of all monsters.
 */
interface IMonster
{
	private var _damage_per_seconds:Float;
	private var _armor:Float;
	private var _movement_speed:Float;
	private var _target:FlxObject;
}
