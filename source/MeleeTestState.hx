import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
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
    private var _map:FlxOgmo3Loader;
    private var _walls:FlxTilemap;
    private var _maxMonsters = 2000;
    private var _ammountOfMonsters: Int;
    private var _monsterPos: Array<Position> = [];
    private var _playerRespawnPos: Position;

    override function create() {
        FlxG.worldBounds.set(-5000, -5000, 10000, 10000);

        _map = new FlxOgmo3Loader(AssetPaths.IntroductionToHaxeFlixel__ogmo, AssetPaths.meleeMap__json);
        _walls = _map.loadTilemap(AssetPaths.WallsAndFloor__png, "walls");
        _walls.follow();
        _walls.setTileProperties(1, FlxObject.ANY);
        _walls.setTileProperties(2, FlxObject.NONE);
        add(_walls);

        _projectiles = new FlxTypedGroup<Projectile>();
        add(_projectiles);

        _player = new Player(0, 0);
        _map.loadEntities(placePlayer, "player");
        add(_player);

        FlxG.camera.follow(_player, TOPDOWN, 1);

        _meleeMonsters = new FlxTypedGroup<MeleeMonster>();
        _map.loadEntities(getMonsterLocations, "melee_monster");
        add(_meleeMonsters);
        _ammountOfMonsters = 0;

        // for (_ in 0...1000)
        // {
        //     _meleeMonsters.add(new MeleeMonster(Random.float(-5000, 5000), Random.float(-5000, 5000), _player, MeleeType.ZOMBIE));
        //     _meleeMonsters.add(new MeleeMonster(Random.float(-5000, 5000), Random.float(-5000, 5000), _player, MeleeType.SKELETON));
        // }

        super.create();
    }

    override function update(elapsed:Float) {
        spawnMonsters();

        shoot();

        _projectiles.forEachAlive(handleProjectiles);

        FlxG.overlap(_meleeMonsters, _projectiles, handleMonsterProjectileCollisions);
        FlxG.collide(_player, _meleeMonsters, handlePlayerMonsterCollisions);
        FlxG.collide(_projectiles, _walls, handleProjectilesWallsCollisions);
        FlxG.collide(_player, _walls);
        FlxG.collide(_meleeMonsters, _walls);

        super.update(elapsed);
    }

    private function placePlayer(entity: EntityData)
    {
        if (entity.name == "player")
            _playerRespawnPos = new Position(entity.x, entity.y);
            _player.setPosition(entity.x, entity.y);
    }

    private function getMonsterLocations(entity: EntityData)
    {
        if (entity.name == "melee_monster")
            _monsterPos.push(new Position(entity.x, entity.y));
    }

    private function spawnMonsters()
    {
        if (_ammountOfMonsters < _maxMonsters)
        {
            var zombiePos: Position = _monsterPos[Random.int(0, _monsterPos.length - 1)];
            _meleeMonsters.add(new MeleeMonster(zombiePos.getX(), zombiePos.getY(), _player, MeleeType.ZOMBIE));

            var skeletonPos: Position = _monsterPos[Random.int(0, _monsterPos.length - 1)];
            _meleeMonsters.add(new MeleeMonster(skeletonPos.getX(), skeletonPos.getY(), _player, MeleeType.SKELETON));

            _ammountOfMonsters = _ammountOfMonsters + 2;
        }
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
        player.setPosition(_playerRespawnPos.getX(), _playerRespawnPos.getY());
    }

    private function handleProjectilesWallsCollisions(projectile:Projectile, wall:FlxTilemap)
    {
        projectile.kill();
    }
}