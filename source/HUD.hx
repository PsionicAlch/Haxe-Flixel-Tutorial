import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class HUD extends FlxTypedGroup<FlxSprite>
{
    private var _monsterCounter:FlxText;
    private var _fireBtn:FlxButton;
    private var _iceBtn:FlxButton;
    private var _poisonBtn:FlxButton;
    private var _shockBtn:FlxButton;

    public function new(player:Player) 
    {
        super();

        _monsterCounter = new FlxText(0, 0, 0, "Monsters Left: 0", 10);
        add(_monsterCounter);

        _iceBtn = new FlxButton(0, 0, "Ice Bolt", () -> player.setProjectileType(ICE_BOLT));
        _iceBtn.screenCenter(X);
        _iceBtn.y = FlxG.height - _iceBtn.height - 2;
        _iceBtn.x = _iceBtn.x - (_iceBtn.width / 2) - 2;
        add(_iceBtn);

        _poisonBtn = new FlxButton(0, 0, "Poison Bolt", () -> player.setProjectileType(POISON_BOLT));
        _poisonBtn.screenCenter(X);
        _poisonBtn.y = FlxG.height - _poisonBtn.height - 2;
        _poisonBtn.x = _poisonBtn.x + (_poisonBtn.width / 2) + 2;
        add(_poisonBtn);

        _fireBtn = new FlxButton(0, 0, "Fire Bolt", () -> player.setProjectileType(FIRE_BOLT));
        _fireBtn.y = FlxG.height - _fireBtn.height - 2;
        _fireBtn.x = _iceBtn.x - _fireBtn.width - 2;
        add(_fireBtn);

        _shockBtn = new FlxButton(0, 0, "Shock Bolt", () -> player.setProjectileType(SHOCK_BOLT));
        _shockBtn.y = FlxG.height - _shockBtn.height - 2;
        _shockBtn.x = _poisonBtn.x + _shockBtn.width + 2;
        add(_shockBtn);

        forEach((sprite:FlxSprite) -> sprite.scrollFactor.set(0, 0));
    }

    public function updateHUD(ammountOfMonsters:Int) 
    {
        _monsterCounter.text = 'Monsters Left: ${ammountOfMonsters}';
    }
}