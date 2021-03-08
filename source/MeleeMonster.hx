import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;

/**
 * A class to represent the basic melee character.
 */
class MeleeMonster extends FlxSprite
{
	private var damage_per_seconds:Float; // The amount of damage the character can do.
	private var armor:Float; // The amount of armor they have.
	private var movement_speed:Float; // Their movement speed.
	private var target:FlxObject; // What they are targeting.

	public function new(x:Float, y:Float, target:FlxObject)
	{
		super(x, y);

		this.health = 20;
		this.damage_per_seconds = 5;
		this.armor = 10;
		this.movement_speed = Random.int(10, 100);
		this.target = target;

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
		FlxVelocity.moveTowardsPoint(this, target.getPosition(), Std.int(movement_speed));
	}
}
