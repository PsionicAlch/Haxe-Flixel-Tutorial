import flixel.util.FlxColor;
import Projectile.ProjectileType;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;

class Level2State extends FlxState
{
    private var _player:Player;
    private var _rangedMonsters:FlxTypedGroup<RangedMonster>;
    private var _projectiles:FlxTypedGroup<Projectile>;
    private var _map:FlxOgmo3Loader;
    private var _walls:FlxTilemap;
    private var _amountOfMonsters:Int;
    private var _healthBar:FlxBar;
    private var _backgroundMusic:Array<String>;
    private var _soundEffects:Array<FlxSound>;
    private var _hud:HUD;

    override function create() 
    {
        FlxG.worldBounds.set(-1000, -1000, 2000, 2000);

        _map = new FlxOgmo3Loader(AssetPaths.IntroductionToHaxeFlixel__ogmo, AssetPaths.level2Map__json);
        _walls = _map.loadTilemap(AssetPaths.WallsAndFloor__png, "walls");
        _walls.follow();
        _walls.setTileProperties(1, FlxObject.ANY);
        _walls.setTileProperties(2, FlxObject.NONE);
        add(_walls);

        _projectiles = new FlxTypedGroup<Projectile>();
        add(_projectiles);

        _player = new Player(0, 0);
        add(_player);

        FlxG.camera.follow(_player, TOPDOWN, 1);

        _rangedMonsters = new FlxTypedGroup<RangedMonster>();
        add(_rangedMonsters);

        _amountOfMonsters = 0;
        _map.loadEntities(initEntities, "entities");

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

        _hud = new HUD(_player);
        _hud.updateHUD(_amountOfMonsters);
        add(_hud);

        super.create();
    }

    override function update(elapsed:Float) 
    {
        if (FlxG.sound.music == null) FlxG.sound.playMusic(_backgroundMusic[Random.int(0, _backgroundMusic.length - 1)], 1, false);
        if (_player.health < 100) _player.health += elapsed;
        if (_player.health > 100) _player.health = 100;
        if (_player.health <= 0) FlxG.camera.fade(FlxColor.RED, 0.33, false, () -> FlxG.switchState(new DeathMenuState(new Level2State())));
        if (_amountOfMonsters <= 0) FlxG.camera.fade(FlxColor.GREEN, 0.33, false, () -> FlxG.switchState(new WinMenuState(new Level3State())));

        _healthBar.value = _player.health;

        handleInput();

        _projectiles.forEachAlive((projectile:Projectile) -> if (projectile.getDurationAlive() >= 2) projectile.kill());
        _rangedMonsters.forEachAlive((monster:RangedMonster) -> 
        {
            if (monster.getShouldFire() && _walls.ray(monster.getMidpoint(), _player.getMidpoint()))
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
        });

        FlxG.overlap(_rangedMonsters, _projectiles, (monster:RangedMonster, projectile:Projectile) -> 
        {
            if (projectile.getSpawner() == _player)
            {
                monster.kill();
                projectile.kill();
                _amountOfMonsters -= 1;

                _hud.updateHUD(_amountOfMonsters);
    
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
        });
        FlxG.collide(_player, _projectiles, (player:Player, projectile:Projectile) -> 
        {
            projectile.kill();
            player.health = player.health - 10;
            _soundEffects[4].play();
        });
        FlxG.collide(_player, _rangedMonsters);
        FlxG.collide(_projectiles, _walls, (projectile:Projectile, wall:FlxTilemap) -> projectile.kill());
        FlxG.collide(_player, _walls);

        super.update(elapsed);
    }

    private function initEntities(entity: EntityData)
    {
        switch (entity.name)
        {
            case "player":
                _player.setPosition(entity.x, entity.y);
            case "ranged_monster":
                var monsterType = [ProjectileType.FIRE_BOLT, ProjectileType.ICE_BOLT, ProjectileType.POISON_BOLT, ProjectileType.SHOCK_BOLT];

                _rangedMonsters.add(new RangedMonster(entity.x, entity.y, _player, monsterType[Random.int(0, monsterType.length - 1)]));
                _amountOfMonsters += 1;
            default:
                throw 'Unrecognized actor type ${entity.name}';
        }
    }

    private function handleInput()
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

        if (FlxG.keys.anyPressed([ESCAPE])) openSubState(new PauseMenu(FlxColor.BLACK));
    }
}