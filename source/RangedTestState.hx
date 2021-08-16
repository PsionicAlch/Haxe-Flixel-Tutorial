import flixel.util.FlxColor;
import flixel.system.FlxSound;
import flixel.ui.FlxBar;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import Projectile.ProjectileType;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;

class RangedTestState extends FlxState
{
    private var _player:Player;
    private var _rangedMonsters:FlxTypedGroup<RangedMonster>;
    private var _projectiles:FlxTypedGroup<Projectile>;
    private var _map:FlxOgmo3Loader;
    private var _walls:FlxTilemap;
    private var _playerRespawnPos:Position;
    private var _monsterPos: Array<Position> = [];
    private var _healthBar:FlxBar;
    private var _backgroundMusic:Array<String>;
    private var _soundEffects: Array<FlxSound>;

    override function create() 
    {
        FlxG.worldBounds.set(-5000, -5000, 10000, 10000);

        _map = new FlxOgmo3Loader(AssetPaths.IntroductionToHaxeFlixel__ogmo, AssetPaths.rangedMap__json);
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

        _rangedMonsters = new FlxTypedGroup<RangedMonster>();
        _map.loadEntities(getMonsterLocations, "melee_monster");
        add(_rangedMonsters);

        _healthBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10, _player, "health", 0, 100, true);
        _healthBar.createFilledBar(FlxColor.RED, FlxColor.GREEN, true);
        _healthBar.trackParent(20, -20);
        add(_healthBar);

        _backgroundMusic = [
            AssetPaths.gameplay_music_1__ogg,
            AssetPaths.gameplay_music_2__ogg,
            AssetPaths.gameplay_music_3__ogg,
            AssetPaths.gameplay_music_4__ogg,
            AssetPaths.gameplay_music_5__ogg,
        ];

        FlxG.sound.playMusic(_backgroundMusic[Random.int(0, _backgroundMusic.length - 1)], 1, false);
        FlxG.sound.music.onComplete = () -> FlxG.sound.music = null;

        _soundEffects = [
            FlxG.sound.load(AssetPaths.fire_bolt__wav, 1, false),                   // 0
            FlxG.sound.load(AssetPaths.ice_bolt__wav, 1, false),                    // 1
            FlxG.sound.load(AssetPaths.poison_bolt__wav, 1, false),                 // 2
            FlxG.sound.load(AssetPaths.shock_bolt__wav, 1, false),                  // 3
            FlxG.sound.load(AssetPaths.player_getting_hit__wav, 1, false),          // 4
            FlxG.sound.load(AssetPaths.dragon_tower_getting_hit__wav, 1, false),    // 5
            FlxG.sound.load(AssetPaths.ice_tower_getting_hit__wav, 1, false),       // 6
            FlxG.sound.load(AssetPaths.poison_tower_getting_hit__wav, 1, false),    // 7
            FlxG.sound.load(AssetPaths.tesla_tower_getting_hit__wav, 1, false),     // 8
        ];

        super.create();
    }

    override function update(elapsed:Float) {
        if (FlxG.sound.music == null) FlxG.sound.playMusic(_backgroundMusic[Random.int(0, _backgroundMusic.length - 1)], 1, false);
        if (_player.health < 100) _player.health = _player.health + elapsed;

        if (_player.health < 0)
        {
            _player.health = 100;
            _player.setPosition(_playerRespawnPos.getX(), _playerRespawnPos.getY());
        }
        _healthBar.value = _player.health;
        spawnMonsters();

        shoot();
        handleKeyboard();

        _rangedMonsters.forEachAlive(handleRangedMonsters);
        _projectiles.forEachAlive(handleProjectiles);

        FlxG.overlap(_player, _projectiles, handlePlayerProjectileCollisions);
		FlxG.overlap(_rangedMonsters, _projectiles, handleMonsterProjectileCollisions);
        FlxG.collide(_projectiles, _walls, handleProjectilesWallsCollisions);
        FlxG.collide(_player, _walls);

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
        {
            _monsterPos.push(new Position(entity.x, entity.y));
        }
    }

    private function spawnMonsters()
    {
        var projectileType: Array<ProjectileType> = [FIRE_BOLT, ICE_BOLT, POISON_BOLT, SHOCK_BOLT];
        var positions: Array<Position> = [];
        var currentMonsterPos: Array<Position> = [];

        _rangedMonsters.forEachAlive((monster: RangedMonster) -> {
            var monsterPos = new Position(monster.getPosition().x, monster.getPosition().y);

            currentMonsterPos.push(monsterPos);
        });

        for (pos in _monsterPos)
        {
            var shouldAdd = true;

            for (currentPos in currentMonsterPos)
            {
                if ((pos.getX() == currentPos.getX()) && (pos.getY() == currentPos.getY()))
                {
                    shouldAdd = false;
                }
            }

            if (shouldAdd) positions.push(pos);
        }

        for (position in positions)
        {
            _rangedMonsters.add(new RangedMonster(position.getX(), position.getY(), _player, projectileType[Random.int(0, projectileType.length -1)]));
        }
    }

    private function shoot()
    {
        if (FlxG.mouse.justPressed)
        {
            var mousePos = FlxG.mouse.getPosition();
            _projectiles.add(new Projectile(_player.getGraphicMidpoint().x, _player.getGraphicMidpoint().y, mousePos, _player.getProjectileType(), _player));
            _player.fire();
            _player.health = _player.health - 1;

            switch (_player.getProjectileType())
            {
                case FIRE_BOLT:
                    _soundEffects[0].play();
                case ICE_BOLT:
                    _soundEffects[1].play();
                case POISON_BOLT:
                    _soundEffects[2].play();
                case SHOCK_BOLT:
                    _soundEffects[3].play();
            }
        }
    }

    private function handleKeyboard()
    {
        if (FlxG.keys.anyPressed([ESCAPE]))
            openSubState(new PauseMenu(FlxColor.BLACK)); 
    }

    private function handleRangedMonsters(monster:RangedMonster)
    {
        if (monster.getShouldFire())
        {
            var projectile = new Projectile(monster.getMidpoint().x, monster.getMidpoint().y, monster.getTarget().getMidpoint(), monster.getProjectileType(), monster);
            _projectiles.add(projectile);

            switch (monster.getProjectileType())
            {
                case FIRE_BOLT:
                    _soundEffects[0].play();
                case ICE_BOLT:
                    _soundEffects[1].play();
                case POISON_BOLT:
                    _soundEffects[2].play();
                case SHOCK_BOLT:
                    _soundEffects[3].play();
            }
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
            _player.health = _player.health - 10;
            _soundEffects[4].play();
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

        switch (monster.getProjectileType())
        {
            case FIRE_BOLT:
                _soundEffects[5].play();
            case ICE_BOLT:
                _soundEffects[6].play();
            case POISON_BOLT:
                _soundEffects[7].play();
            case SHOCK_BOLT:
                _soundEffects[8].play();
        }
    }

    private function handleProjectilesWallsCollisions(projectile:Projectile, wall:FlxTilemap)
    {
        projectile.kill();
    }
}