package;

import Projectile.ProjectileType;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	// A class variable to represent the character, monsters, delta time, and projectiles.
	private var _player:Player;
	private var _monsters:FlxTypedGroup<RangedMonster>;
	private var _elapsed:Float;
	private var _projectiles:FlxTypedGroup<Projectile>;

	override public function create()
	{
		// Create and add a new group of projectiles.
		_projectiles = new FlxTypedGroup<Projectile>();
		add(_projectiles);

		// Create a new instance of the player at the point
		// (50, 50) on the screen.
		_player = new Player(50, 50);
		// Add the player to the scene.
		add(_player);

		// Spawn some melee monsters as a test.
		_monsters = new FlxTypedGroup<RangedMonster>();
		add(_monsters);

		// Spawn 100 ranged monsters in the world.
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
		_projectiles.forEachExists(handleProjectiles);
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
			_projectiles.add(new Projectile(_player.x, _player.y, mousePos, ProjectileType.FIRE_BOLT));
		}
	}

	/**
	 * Handle shooting for the ranged units.
	 * @param monster The ranged unit.
	 */
	private function handleRangedAI(monster:RangedMonster):Void
	{
		if (monster.shouldFire(_elapsed))
		{
			var projectile = new Projectile(monster.x, monster.y, monster.getTarget().getPosition(), monster.getProjectileType());
			_projectiles.add(projectile);
		}
	}

	/**
	 * Memory management for the projectiles.
	 * @param projectile 
	 */
	private function handleProjectiles(projectile:Projectile):Void
	{
		if (projectile.getDurationAlive() >= 2)
		{
			projectile.alive = false;
			projectile.exists = false;
		}
	}
}
