package;

import Projectile.ProjectileType;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	// A class variable to represent the character, monsters, delta time, and projectiles.
	private var _player:Player;
	private var _rangedMonsters:FlxTypedGroup<RangedMonster>;
	private var _meleeMonsters:FlxTypedGroup<MeleeMonster>;
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

		// Spawn some ranged monsters.
		_rangedMonsters = new FlxTypedGroup<RangedMonster>();
		add(_rangedMonsters);

		// Spawn some melee monsters.
		_meleeMonsters = new FlxTypedGroup<MeleeMonster>();
		add(_meleeMonsters);

		// Spawn 10 ranged monsters in the world.
		for (_ in 0...10)
		{
			_rangedMonsters.add(new RangedMonster(Random.float(0, 500), Random.float(0, 500), _player, ProjectileType.FIRE_BOLT));
			_meleeMonsters.add(new MeleeMonster(Random.float(0, 500), Random.float(0, 500), _player));
		}

		super.create();
	}

	override public function update(elapsed:Float)
	{
		shoot();
		_rangedMonsters.forEachAlive(handleRangedMonsters);
		_projectiles.forEachExists(handleProjectiles);

		// Check for colisions.
		FlxG.overlap(_player, _projectiles, handlePlayerProjectileCollisions);
		FlxG.overlap(_rangedMonsters, _projectiles, handleMonsterProjectileCollisions);
		FlxG.overlap(_meleeMonsters, _projectiles, handleMonsterProjectileCollisions);
		FlxG.collide(_player, _meleeMonsters, handlePlayerMonsterCollisions);

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
			_projectiles.add(new Projectile(_player.x, _player.y, mousePos, ProjectileType.FIRE_BOLT, _player));
		}
	}

	/**
	 * Handle shooting for the ranged units.
	 * @param monster The ranged unit.
	 */
	private function handleRangedMonsters(monster:RangedMonster)
	{
		if (monster.getShouldFire())
		{
			var projectile = new Projectile(monster.x, monster.y, monster.getTarget().getPosition(), monster.getProjectileType(), monster);
			_projectiles.add(projectile);
		}
	}

	private function handlePlayerProjectileCollisions(player:Player, projectile:Projectile)
	{
		if (projectile.getSpawner() != player)
		{
			player.setPosition(Random.float(0, 500));
			projectile.kill();
		}
	}

	private function handlePlayerMonsterCollisions(player:Player, monster:MeleeMonster)
	{
		player.setPosition(Random.float(0, 500));
	}

	private function handleMonsterProjectileCollisions(monster:FlxObject, projectile:Projectile)
	{
		if (projectile.getSpawner() == _player)
		{
			monster.kill();
			projectile.kill();
		}
	}

	/**
	 * Memory management for the projectiles.
	 * @param projectile 
	 */
	private function handleProjectiles(projectile:Projectile)
	{
		if (projectile.getDurationAlive() >= 2)
		{
			projectile.alive = false;
			projectile.exists = false;
		}
	}
}
