package;

import Projectile.ProjectileType;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	// A class variable to represent the character in this
	// scene.
	private var _player:Player;
	private var _monsters:FlxTypedGroup<RangedMonster>;
	private var _elapsed:Float;

	override public function create()
	{
		// Create a new instance of the player at the point
		// (50, 50) on the screen.
		_player = new Player(50, 50);
		// Add the player to the scene.
		add(_player);

		// Spawn some melee monsters as a test.
		_monsters = new FlxTypedGroup<RangedMonster>();
		add(_monsters);

		// Spawn 100 melee monsters in the world.
		for (_ in 0...100)
		{
			_monsters.add(new RangedMonster(Std.random(1000), Std.random(1000), _player, ProjectileType.FIRE_BOLT));
		}

		super.create();
	}

	override public function update(elapsed:Float)
	{
		shoot();
		_monsters.forEach(handleRangedAI);
		this._elapsed = elapsed;
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

	private function handleRangedAI(monster:RangedMonster):Void
	{
		if (monster.shouldFire(_elapsed))
		{
			var projectile = new Projectile(monster.x, monster.y, monster.getTarget().getPosition(), monster.getProjectileType());
			add(projectile);
		}
	}
}
