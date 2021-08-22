import flixel.util.FlxColor;
import MeleeMonster.MeleeType;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.ui.FlxBar;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;

class Level1State extends FlxState
{
    private var _player:Player;
    private var _meleeMonsters:FlxTypedGroup<MeleeMonster>;
    private var _projectiles:FlxTypedGroup<Projectile>;
    private var _map:FlxOgmo3Loader;
    private var _walls:FlxTilemap;
    private var _amountOfMonsters:Int;
    private var _healthBar:FlxBar;
    private var _backgroundMusic:Array<String>;
    private var _soundEffects:Array<FlxSound>;

    override function create()
    {
        FlxG.worldBounds.set(-1000, -1000, 2000, 2000);

        _map = new FlxOgmo3Loader(AssetPaths.IntroductionToHaxeFlixel__ogmo, AssetPaths.level1Map__json);
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

        _meleeMonsters = new FlxTypedGroup<MeleeMonster>();
        add(_meleeMonsters);

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
            FlxG.sound.load(AssetPaths.fire_bolt__wav, 1, false),
            FlxG.sound.load(AssetPaths.ice_bolt__wav, 1, false),
            FlxG.sound.load(AssetPaths.poison_bolt__wav, 1, false),
            FlxG.sound.load(AssetPaths.shock_bolt__wav, 1, false),
            FlxG.sound.load(AssetPaths.player_getting_hit__wav, 1, false),
            FlxG.sound.load(AssetPaths.skeleton_getting_hit__wav, 1, false),
            FlxG.sound.load(AssetPaths.zombie_getting_hit__wav, 1, false)
        ];

        super.create();
    }

    override function update(elapsed:Float) 
    {
        if (FlxG.sound.music == null) FlxG.sound.playMusic(_backgroundMusic[Random.int(0, _backgroundMusic.length - 1)], 1, false);
        if (_player.health < 100) _player.health += elapsed;
        if (_player.health <= 0) FlxG.camera.fade(FlxColor.RED, 0.33, () -> FlxG.resetState());
        if (_amountOfMonsters <= 0) FlxG.camera.fade(FlxColor.GREEN, 0.33, false, () -> FlxG.switchState(new LevelSelectState()));

        _healthBar.value = _player.health;

        handleInput();

        _projectiles.forEachAlive((projectile:Projectile) -> if (projectile.getDurationAlive() >= 2) projectile.kill());
        _meleeMonsters.forEachAlive((monster:MeleeMonster) -> monster.move());

        FlxG.overlap(_meleeMonsters, _projectiles, (monster:MeleeMonster, projectile:Projectile) -> 
        {
            if (projectile.getSpawner() == _player)
            {
                monster.kill();
                projectile.kill();
    
                switch (monster.getType())
                {
                    case ZOMBIE:
                        _soundEffects[6].play();
                    case SKELETON:
                        _soundEffects[5].play();
                }
            }
        });
        FlxG.collide(_player, _meleeMonsters, (player:Player, monster:MeleeMonster) -> 
        {
            player.health = player.health - 10;
            _soundEffects[4].play();
        });
        FlxG.collide(_projectiles, _walls, (projectile:Projectile, wall:FlxTilemap) -> projectile.kill());
        FlxG.collide(_player, _walls);
        FlxG.collide(_meleeMonsters, _walls);

        super.update(elapsed);
    }

    private function initEntities(entity: EntityData)
    {
        switch (entity.name)
        {
            case "player":
                _player.setPosition(entity.x, entity.y);
            case "melee_monster":
                var monsterTypes = [MeleeType.ZOMBIE, MeleeType.SKELETON];

                _meleeMonsters.add(new MeleeMonster(entity.x, entity.y, _player, monsterTypes[Random.int(0, monsterTypes.length - 1)]));
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