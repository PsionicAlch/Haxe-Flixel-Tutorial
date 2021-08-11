import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
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
    private var _leader: MeleeMonster;
    private var _points: Array<FlxPoint>;
    private var _pathFindingAlgo: Int = 0;
    private var _healthBar: FlxBar;

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

        if (_pathFindingAlgo == 1)
        {
            _leader = null;
            _points = null;
        }

        _healthBar = new FlxBar(20, 20, LEFT_TO_RIGHT, 100, 10, _player, "health", 0, 100, true);
        _healthBar.createFilledBar(FlxColor.RED, FlxColor.GREEN, true);
        _healthBar.trackParent(20, -20);
        add(_healthBar);

        super.create();
    }

    override function update(elapsed:Float) {
        if (_player.health < 100) _player.health = _player.health + elapsed;

        if (_player.health < 0)
        {
            _player.health = 100;
            _player.setPosition(_playerRespawnPos.getX(), _playerRespawnPos.getY());
        }
        _healthBar.value = _player.health;
        spawnMonsters();

        if (_pathFindingAlgo == 1)
            findClosestMonster();

        shoot();
        handleKeyboard();

        _projectiles.forEachAlive(handleProjectiles);
        _meleeMonsters.forEachAlive(handleMonsterMovement);

        FlxG.overlap(_meleeMonsters, _projectiles, handleMonsterProjectileCollisions);
        FlxG.collide(_player, _meleeMonsters, handlePlayerMonsterCollisions);
        FlxG.collide(_projectiles, _walls, handleProjectilesWallsCollisions);
        FlxG.collide(_player, _walls);
        FlxG.collide(_meleeMonsters, _walls);

        if (_pathFindingAlgo == 1)
            FlxG.collide(_leader, _walls);

        super.update(elapsed);
    }

    private function placePlayer(entity: EntityData)
    {
        if (entity.name == "player")
        {
            _playerRespawnPos = new Position(entity.x, entity.y);
            _player.setPosition(entity.x, entity.y);
        }
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
            _player.health = _player.health - 1;
        }
    }

    private function handleKeyboard()
    {
        if (FlxG.keys.anyPressed([ESCAPE]))
            openSubState(new PauseMenu(FlxColor.BLACK));
            
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
        player.health = player.health - 10;
    }

    private function handleProjectilesWallsCollisions(projectile:Projectile, wall:FlxTilemap)
    {
        projectile.kill();
    }

    private function handleMonsterMovement(monster: MeleeMonster)
    {
        if (_pathFindingAlgo == 0)
        {
            monster.move();
        }
        else 
        {
            if (monster == _leader)
                _points = _walls.findPath(FlxPoint.get(_leader.x + _leader.width / 2, _leader.y + _leader.height / 2), FlxPoint.get(_player.x + _player.width / 2, _player.y + _player.height / 2));
    
            if (_points != null)
                monster.path.start(_points, monster.getMovementSpeed());
        }
    }

    private function findClosestMonster()
    {
        _meleeMonsters.forEachAlive((monster: MeleeMonster) -> {
            if (_leader == null) 
            {
                _leader = monster;
            }
            else 
            {
                var distanceBetweenLeaderAndPlayer = FlxMath.distanceBetween(_leader, _player);
                var distanceBetweenMonsterAndPlayer = FlxMath.distanceBetween(monster, _player);

                if (distanceBetweenMonsterAndPlayer < distanceBetweenLeaderAndPlayer)
                    _leader = monster;
            }
        });
    }
}