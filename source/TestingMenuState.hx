import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxState;

class TestingMenuState extends FlxState 
{
    private var title:FlxText;
    private var meleeMap:FlxButton;
    private var rangedMap:FlxButton;
    private var bossMap:FlxButton;
    private var back:FlxButton;

    override function create() 
    {
        title = new FlxText(0, 20, 0, "Testing Menu", 18);
        title.alignment = CENTER;
        title.screenCenter(X);
        add(title);

        rangedMap = new FlxButton(0, 0, "Ranged Map", clickRanged);
        rangedMap.screenCenter(XY);
        rangedMap.y = rangedMap.y - (rangedMap.height / 2) - 1;
        add(rangedMap);

        bossMap = new FlxButton(0, 0, "Boss Map", clickBoss);
        bossMap.screenCenter(XY);
        bossMap.y = bossMap.y + (bossMap.height / 2) + 1;
        add(bossMap);

        meleeMap = new FlxButton(0, 0, "Melee Map", clickMelee);
        meleeMap.screenCenter(X);
        meleeMap.y = rangedMap.y - meleeMap.height - 2;
        add(meleeMap);

        back = new FlxButton(0, 0, "Go Back", clickBack);
        back.screenCenter(X);
        back.y = bossMap.y + back.height + 2;
        add(back);

        super.create();
    }

    private function clickMelee()
    {
        FlxG.camera.fade(FlxColor.RED, 0.33, false, () -> {
            FlxG.switchState(new MeleeTestState());
        });
    }

    private function clickRanged()
    {
        FlxG.camera.fade(FlxColor.GREEN, 0.33, false, () -> {
            FlxG.switchState(new RangedTestState());
        });
    }

    private function clickBoss()
    {
        FlxG.camera.fade(FlxColor.BLUE, 0.33, false, () -> {
            FlxG.switchState(new BossTestState());
        });
    }

    private function clickBack()
    {
        FlxG.camera.fade(FlxColor.ORANGE, 0.33, false, () -> {
            FlxG.switchState(new MenuState());
        });
    }
}