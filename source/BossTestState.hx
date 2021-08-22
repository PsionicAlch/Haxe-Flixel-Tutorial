import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.system.FlxSound;
import flixel.ui.FlxBar;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import Projectile.ProjectileType;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;

class BossTestState extends FlxState
{
    private var _player:Player;
    private var _bossMonster:BossMonster;
    private var _projectiles:FlxTypedGroup<Projectile>;
    private var _map:FlxOgmo3Loader;
    private var _walls:FlxTilemap;
    private var _playerRespawnPos:Position;
    private var _bossRespawnPoints:Array<Position> = [];
    private var _playerHealthBar:FlxBar;
    private var _bossHealthBar:FlxBar;
    private var _soundEffects:Array<FlxSound>;

    override function create() 
    {
        FlxG.worldBounds.set(-5000, -5000, 10000, 10000);

        _map = new FlxOgmo3Loader(AssetPaths.IntroductionToHaxeFlixel__ogmo, AssetPaths.bossMap__json);
        _walls = _map.loadTilemap(AssetPaths.WallsAndFloor__png, "walls");
        _walls.follow();
        _walls.setTileProperties(1, FlxObject.ANY);
        _walls.setTileProperties(2, FlxObject.NONE);
        add(_walls);

        _projectiles = new FlxTypedGroup<Projectile>();
		add(_projectiles);

        _player = new Player(0, 0);
        _map.loadEntities(initEntities, "entities");
		add(_player);

        FlxG.camera.follow(_player, TOPDOWN, 1);

        var tempSpawnPoint = _bossRespawnPoints[Random.int(0, _bossRespawnPoints.length - 1)];
        _bossMonster = new BossMonster(tempSpawnPoint.getX(), tempSpawnPoint.getY(), _player);
		add(_bossMonster);

        _playerHealthBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10, _player, "health", 0, 100, true);
        _playerHealthBar.createFilledBar(FlxColor.RED, FlxColor.GREEN, true);
        _playerHealthBar.trackParent(20, -20);
        add(_playerHealthBar);

        _bossHealthBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10, _bossMonster, "health", 0, 1000, true);
        _bossHealthBar.createFilledBar(FlxColor.RED, FlxColor.GREEN, true);
        _bossHealthBar.trackParent(20, -20);
        add(_bossHealthBar);

        FlxG.sound.playMusic(AssetPaths.boss_music__ogg, 1, true);

        _soundEffects = [
            FlxG.sound.load(AssetPaths.fire_bolt__wav, 1, false),                   // 0
            FlxG.sound.load(AssetPaths.ice_bolt__wav, 1, false),                    // 1
            FlxG.sound.load(AssetPaths.poison_bolt__wav, 1, false),                 // 2
            FlxG.sound.load(AssetPaths.shock_bolt__wav, 1, false),                  // 3
            FlxG.sound.load(AssetPaths.player_getting_hit__wav, 1, false),          // 4
            FlxG.sound.load(AssetPaths.demon_getting_hit__wav, 1, false),           // 5
            FlxG.sound.load(AssetPaths.demon_death__wav, 1, false),                 // 6
        ];

        super.create();
    }

    override function update(elapsed:Float) 
    {
        if (_player.health < 100) _player.health = _player.health + elapsed;

        if (_player.health <= 0)
        {
            _player.health = 100;
            _player.setPosition(_playerRespawnPos.getX(), _playerRespawnPos.getY());
        }
        _playerHealthBar.value = _player.health;

        if (_bossMonster.health <= 0)
        {
            _bossMonster.health = 1000;
            var tempPosition = _bossRespawnPoints[Random.int(0, _bossRespawnPoints.length - 1)];
            _bossMonster.setPosition(tempPosition.getX(), tempPosition.getY());
        }
        _bossHealthBar.value = _bossMonster.health;

        shoot();
        handleKeyboard();

        handleBossMonster(_bossMonster);

        FlxG.overlap(_player, _projectiles, handlePlayerProjectileCollisions);
        FlxG.overlap(_bossMonster, _projectiles, handleBossProjectileCollisions);
        FlxG.collide(_player, _bossMonster, handlePlayerBossCollisions);
        FlxG.collide(_projectiles, _walls, handleProjectilesWallsCollisions);
        FlxG.collide(_player, _walls);
        FlxG.collide(_bossMonster, _walls);

        super.update(elapsed);
    }

    private function initEntities(entity: EntityData)
    {
        if (entity.name == "player")
        {
            _playerRespawnPos = new Position(entity.x, entity.y);
            _player.setPosition(entity.x, entity.y);
        }
        else if (entity.name == "boss_monster")
        {
            _bossRespawnPoints.push(new Position(entity.x, entity.y));
        }
    }

    private function shoot()
    {
        if (FlxG.mouse.justPressed)
        {
            var mousePos = FlxG.mouse.getPosition();
            _projectiles.add(new Projectile(_player.getMidpoint().x, _player.getMidpoint().y, mousePos, _player.getProjectileType(), _player));
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

    private function handleBossMonster(monster:BossMonster)
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

    private function handlePlayerProjectileCollisions(player:Player, projectile:Projectile)
    {
        if (projectile.getSpawner() != player)
        {
            player.health = player.health - 10;
            _soundEffects[4].play();
            projectile.kill();
        }
    }

    private function handleBossProjectileCollisions(monster:BossMonster, projectile:Projectile)
    {
        if (projectile.getSpawner() == _player) 
        {
            projectile.kill();
            monster.stun();
            monster.health = monster.health - 10;
            _soundEffects[5].play();
        }
    }

    private function handlePlayerBossCollisions(player:Player, monster:BossMonster)
    {
        monster.stun();
        player.health = player.health - 10;
        _soundEffects[4].play();
    }

    private function handleProjectilesWallsCollisions(projectile:Projectile, wall:FlxTilemap)
    {
        projectile.kill();
    }
}