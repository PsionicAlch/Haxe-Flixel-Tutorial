package;

import MonsterProjectile.MonsterProjectile;
import MonsterProjectile.MonsterProjectileType;
import PlayerProjectile.PlayerProjectile;
import PlayerProjectile.PlayerProjectileType;
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
	private var _playerProjectiles:FlxTypedGroup<PlayerProjectile>;
	private var _monsterProjectiles:FlxTypedGroup<MonsterProjectile>;

	override public function create()
	{
		// Create and add a new group of player projectiles.
		_playerProjectiles = new FlxTypedGroup<PlayerProjectile>();
		add(_playerProjectiles);

		// Create and add a new group of monster projectiles.
		_monsterProjectiles = new FlxTypedGroup<MonsterProjectile>();
		add(_monsterProjectiles);

		// Create a new instance of the player at the point
		// (50, 50) on the screen.
		_player = new Player(50, 50);
		// Add the player to the scene.
		add(_player);

		// Tell camera to follow the player.
		FlxG.camera.follow(_player, TOPDOWN, 1);

		// Spawn some ranged monsters.
		_rangedMonsters = new FlxTypedGroup<RangedMonster>();
		add(_rangedMonsters);

		// Spawn some melee monsters.
		_meleeMonsters = new FlxTypedGroup<MeleeMonster>();
		add(_meleeMonsters);

		// Spawn 10 ranged monsters in the world.
		for (_ in 0...10)
		{
			_rangedMonsters.add(new RangedMonster(Random.float(0, 500), Random.float(0, 500), _player, MonsterProjectileType.FIRE_BOLT));
			_meleeMonsters.add(new MeleeMonster(Random.float(0, 500), Random.float(0, 500), _player));
		}

		super.create();
	}

	override public function update(elapsed:Float)
	{
		shoot();
		_rangedMonsters.forEachAlive(handleRangedMonsters);
		_playerProjectiles.forEachExists(handlePlayerProjectiles);
		_monsterProjectiles.forEachExists(handleMonsterProjectiles);

		// Check for colisions.
		FlxG.collide(_player, _monsterProjectiles, handlePlayerProjectileCollisions);
		FlxG.collide(_rangedMonsters, _playerProjectiles, handleMonsterProjectileCollisions);
		FlxG.collide(_meleeMonsters, _playerProjectiles, handleMonsterProjectileCollisions);
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
			_playerProjectiles.add(new PlayerProjectile(_player.x, _player.y, mousePos, PlayerProjectileType.FIRE_BOLT));
			_player.fire();
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
			var projectile = new MonsterProjectile(monster.x, monster.y, monster.getTarget().getPosition(), monster.getProjectileType());
			_monsterProjectiles.add(projectile);
		}
	}

	private function handlePlayerProjectileCollisions(player:Player, projectile:MonsterProjectile)
	{
		player.setPosition(0, 0);
		projectile.kill();
	}

	private function handlePlayerMonsterCollisions(player:Player, monster:MeleeMonster)
	{
		player.setPosition(Random.float(0, 500));
	}

	private function handleMonsterProjectileCollisions(monster:FlxObject, projectile:PlayerProjectile)
	{
		monster.kill();
		projectile.kill();
	}

	/**
	 * Memory management for the player projectiles.
	 * @param projectile 
	 */
	private function handlePlayerProjectiles(projectile:PlayerProjectile)
	{
		if (projectile.getDurationAlive() >= 2)
		{
			projectile.explode();
			projectile.kill();
		}
	}

	/**
	 * Memory management for the monster projectiles.
	 * @param projectile 
	 */
	private function handleMonsterProjectiles(projectile:MonsterProjectile)
	{
		if (projectile.getDurationAlive() >= 2)
		{
			projectile.explode();
			projectile.kill();
		}
	}
}
