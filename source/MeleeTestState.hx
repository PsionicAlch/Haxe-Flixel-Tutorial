import MeleeMonster.MeleeType;
import Projectile.ProjectileType;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;

class MeleeTestState extends FlxState
{
    private var _player:Player;
    private var _meleeMonsters:FlxTypedGroup<MeleeMonster>;
    private var _projectiles:FlxTypedGroup<Projectile>;

    override function create() {
        FlxG.worldBounds.set(-5000, -5000, 10000, 10000);

        _projectiles = new FlxTypedGroup<Projectile>();
        add(_projectiles);

        _player = new Player(0, 0);
        add(_player);

        FlxG.camera.follow(_player, TOPDOWN, 1);

        _meleeMonsters = new FlxTypedGroup<MeleeMonster>();
        add(_meleeMonsters);

        for (_ in 0...1000)
        {
            _meleeMonsters.add(new MeleeMonster(Random.float(-5000, 5000), Random.float(-5000, 5000), _player, MeleeType.ZOMBIE));
            _meleeMonsters.add(new MeleeMonster(Random.float(-5000, 5000), Random.float(-5000, 5000), _player, MeleeType.SKELETON));
        }

        super.create();
    }

    override function update(elapsed:Float) {
        shoot();

        _projectiles.forEachAlive(handleProjectiles);

        FlxG.overlap(_meleeMonsters, _projectiles, handleMonsterProjectileCollisions);
        FlxG.collide(_player, _meleeMonsters, handlePlayerMonsterCollisions);

        super.update(elapsed);
    }

    private function shoot()
    {
        if (FlxG.mouse.justPressed)
        {
            var mousePos = FlxG.mouse.getPosition();
            _projectiles.add(new Projectile(_player.getGraphicMidpoint().x, _player.getGraphicMidpoint().y, mousePos, ProjectileType.FIRE_BOLT, _player));
            _player.fire();
        }
    }

    private function handleProjectiles(projectile:Projectile)
    {
        if (projectile.getDurationAlive() >= 2)
        {
            projectile.kill();
        }
    }

    private function handleMonsterProjectileCollisions(monster:MeleeMonster, projectile:Projectile)
    {
        if (projectile.getSpawner() == _player)
        {
            monster.kill();
            projectile.kill();
        }
    }

    private function handlePlayerMonsterCollisions(player:Player, monster:MeleeMonster)
    {
        player.setPosition(0, 0);
    }
}