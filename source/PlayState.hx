package;

import Projectile.ProjectileType;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	// A class variable to represent the character in this
	// scene.
	private var _player:Player;

	override public function create()
	{
		// Create a new instance of the player at the point
		// (50, 50) on the screen.
		_player = new Player(50, 50);
		// Add the player to the scene.
		add(_player);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		shoot();
		super.update(elapsed);
	}

	/**
	 * Used to add a new projectile to the world every time the player presses the
	 * left mouse button.
	 */
	private function shoot()
	{
		if (FlxG.mouse.justPressed)
		{
			var mousePos = FlxG.mouse.getPosition();
			add(new Projectile(_player.x, _player.y, mousePos, ProjectileType.FIRE_BOLT));
		}
	}
}
