import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxState;

class MapRoomState extends FlxState
{
    private var title: FlxText;
    private var map1: FlxButton;
    private var map2: FlxButton;
    private var map3: FlxButton;
    private var bossMap: FlxButton;
    private var back: FlxButton;

    override function create() 
    {
        title = new FlxText(0, 20, 0, "Map Room", 18);
        title.alignment = CENTER;
        title.screenCenter(X);
        add(title);

        map2 = new FlxButton(0, 0, "Level 2", clickLevel2);
        map2.screenCenter(XY);
        map2.y = map2.y - (map2.height / 2) - 1;
        add(map2);

        map3 = new FlxButton(0, 0, "Level 3", clickLevel3);
        map3.screenCenter(XY);
        map3.y = map3.y + (map3.height / 2) + 1;
        add(map3);

        map1 = new FlxButton(0, 0, "Level 1", clickLevel1);
        map1.screenCenter(X);
        map1.y = map2.y - map1.height - 2;
        add(map1);

        bossMap = new FlxButton(0, 0, "Boss Level", clickBossLevel);
        bossMap.screenCenter(X);
        bossMap.y = map3.y + bossMap.height + 2;
        add(bossMap);

        back = new FlxButton(0, 0, "Go Back", clickBack);
        back.screenCenter(X);
        back.y = bossMap.y + back.height + 2;
        add(back);

        super.create();
    }

    private function clickLevel1()
    {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> {
            FlxG.switchState(new Level1TestState());
        });
    }

    private function clickLevel2()
    {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> {
            FlxG.switchState(new Level2TestState());
        });
    }

    private function clickLevel3()
    {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> {
            FlxG.switchState(new Level3TestState());
        });
    }

    private function clickBossLevel()
    {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> {
            FlxG.switchState(new BossLevelTestState());
        });
    }

    private function clickBack()
    {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> {
            FlxG.switchState(new TestingMenuState());
        });
    }
}