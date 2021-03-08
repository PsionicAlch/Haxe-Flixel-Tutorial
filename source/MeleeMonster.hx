import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;

/**
 * A class to represent the basic melee character.
 */
class MeleeMonster extends FlxSprite
{
	private var _damage_per_seconds:Float; // The amount of damage the character can do.
	private var _armor:Float; // The amount of armor they have.
	private var _movement_speed:Float; // Their movement speed.
	private var _target:FlxObject; // What they are targeting.

	public function new(x:Float, y:Float, target:FlxObject)
	{
		super(x, y);

		this.health = 20;
		this._damage_per_seconds = 5;
		this._armor = 10;
		this._movement_speed = Random.int(10, 100);
		this._target = target;

		makeGraphic(20, 20, FlxColor.GREEN);
	}

	override function update(elapsed:Float)
	{
		AI();

		super.update(elapsed);
	}

	/**
	 * A function to dictate what the monster does.
	 */
	private function AI():Void
	{
		// Tell the monster to head for the player.
		FlxVelocity.moveTowardsPoint(this, _target.getPosition(), Std.int(_movement_speed));
	}
}
