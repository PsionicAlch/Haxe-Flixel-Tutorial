import Projectile.ProjectileType;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;

class RangedTestState extends FlxState
{
    private var _player:Player;
    private var _rangedMonsters:FlxTypedGroup<RangedMonster>;
    private var _projectiles:FlxTypedGroup<Projectile>;

    override function create() 
    {
        FlxG.worldBounds.set(-5000, -5000, 10000, 10000);

        _projectiles = new FlxTypedGroup<Projectile>();
		add(_projectiles);

        _player = new Player(0, 0);
        add(_player);

        FlxG.camera.follow(_player, TOPDOWN, 1);

        _rangedMonsters = new FlxTypedGroup<RangedMonster>();
		add(_rangedMonsters);

        for (_ in 0...100)
        {
            _rangedMonsters.add(new RangedMonster(Random.float(-5000, 5000), Random.float(-5000, 5000), _player, ProjectileType.FIRE_BOLT));
            _rangedMonsters.add(new RangedMonster(Random.float(-5000, 5000), Random.float(-5000, 5000), _player, ProjectileType.ICE_BOLT));
            _rangedMonsters.add(new RangedMonster(Random.float(-5000, 5000), Random.float(-5000, 5000), _player, ProjectileType.POISON_BOLT));
            _rangedMonsters.add(new RangedMonster(Random.float(-5000, 5000), Random.float(-5000, 5000), _player, ProjectileType.SHOCK_BOLT));
        }

        super.create();
    }

    override function update(elapsed:Float) {
        shoot();

        _rangedMonsters.forEachAlive(handleRangedMonsters);
        _projectiles.forEachAlive(handleProjectiles);

        FlxG.overlap(_player, _projectiles, handlePlayerProjectileCollisions);
		FlxG.overlap(_rangedMonsters, _projectiles, handleMonsterProjectileCollisions);

        super.update(elapsed);
    }

    private function shoot()
    {
        if (FlxG.mouse.justPressed)
        {
            var mousePos = FlxG.mouse.getPosition();
            _projectiles.add(new Projectile(_player.getMidpoint().x, _player.getMidpoint().y, mousePos, ProjectileType.FIRE_BOLT, _player));
            _player.fire();
        }
    }

    private function handleRangedMonsters(monster:RangedMonster)
    {
        if (monster.getShouldFire())
        {
            var projectile = new Projectile(monster.getMidpoint().x, monster.getMidpoint().y, monster.getTarget().getMidpoint(), monster.getProjectileType(),
                monster);
            _projectiles.add(projectile);
        }
    }

    private function handleProjectiles(projectile:Projectile)
    {
        if (projectile.getDurationAlive() >= 2)
        {
            projectile.kill();
        }
    }

    private function handlePlayerProjectileCollisions(player:Player, projectile:Projectile)
    {
        if (projectile.getSpawner() != player)
        {
            player.setPosition(0, 0);
            projectile.kill();
        }
    }

    private function handleMonsterProjectileCollisions(monster:RangedMonster, projectile:Projectile)
    {
        if (projectile.getSpawner() == _player)
        {
            monster.kill();
            projectile.kill();
        }
    }
}