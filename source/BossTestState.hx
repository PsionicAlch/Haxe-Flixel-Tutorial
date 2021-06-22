import Projectile.ProjectileType;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;

class BossTestState extends FlxState
{
    private var _player:Player;
    private var _bossMonster:BossMonster;
    private var _projectiles:FlxTypedGroup<Projectile>;

    override function create() 
    {
        FlxG.worldBounds.set(-5000, -5000, 10000, 10000);

        _projectiles = new FlxTypedGroup<Projectile>();
		add(_projectiles);

        _player = new Player(0, 0);
		add(_player);

        FlxG.camera.follow(_player, TOPDOWN, 1);

        _bossMonster = new BossMonster(Random.float(-5000, 5000), Random.float(-5000, 5000), _player);
		add(_bossMonster);

        super.create();
    }

    override function update(elapsed:Float) 
    {
        shoot();

        handleBossMonster(_bossMonster);

        FlxG.overlap(_player, _projectiles, handlePlayerProjectileCollisions);
        FlxG.overlap(_bossMonster, _projectiles, handleBossProjectileCollisions);
        FlxG.collide(_player, _bossMonster, handlePlayerBossCollisions);

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

    private function handleBossMonster(monster:BossMonster)
    {
        if (monster.getShouldFire())
        {
            var projectile = new Projectile(monster.getMidpoint().x, monster.getMidpoint().y, monster.getTarget().getMidpoint(), monster.getProjectileType(),
                monster);
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

    private function handleBossProjectileCollisions(monster:BossMonster, projectile:Projectile)
    {
        if (projectile.getSpawner() == _player) 
        {
            projectile.kill();
            monster.stun();
        }
    }

    private function handlePlayerBossCollisions(player:Player, monster:BossMonster)
    {
        monster.stun();
        player.setPosition(0, 0);
    }
}