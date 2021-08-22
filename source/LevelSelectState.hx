import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxState;

class LevelSelectState extends FlxState
{
    private var _title:FlxText;
    private var _lvl1Btn:FlxButton;
    private var _lvl2Btn:FlxButton;
    private var _lvl3Btn:FlxButton;
    private var _bossBtn:FlxButton;
    private var _backBtn:FlxButton;

    override function create() 
    {
        _title = new FlxText(0, 20, 0, "Level Select", 18);
        _title.alignment = CENTER;
        _title.screenCenter(X);
        add(_title);

        _lvl3Btn = new FlxButton(0, 0, "Level 3", () -> 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> 
            {
                FlxG.switchState(new Level3State());
            });
        });
        _lvl3Btn.screenCenter(XY);
        _lvl3Btn.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav);
        add(_lvl3Btn);

        _lvl2Btn = new FlxButton(0, 0, "Level 2", () -> 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> 
            {
                FlxG.switchState(new Level2State());
            });
        });
        _lvl2Btn.screenCenter(X);
        _lvl2Btn.y = _lvl3Btn.y - _lvl2Btn.height - 2;
        _lvl2Btn.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav);
        add(_lvl2Btn);

        _lvl1Btn = new FlxButton(0, 0, "Level 1", () -> 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> 
            {
                FlxG.switchState(new Level1State());
            });
        });
        _lvl1Btn.screenCenter(X);
        _lvl1Btn.y = _lvl2Btn.y - _lvl1Btn.height - 2;
        _lvl1Btn.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav);
        add(_lvl1Btn);

        _bossBtn = new FlxButton(0, 0, "Boss Level", () -> 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> 
            {
                FlxG.switchState(new BossLevelState());
            });
        });
        _bossBtn.screenCenter(X);
        _bossBtn.y = _lvl3Btn.y + _bossBtn.height + 2;
        _bossBtn.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav);
        add(_bossBtn);

        _backBtn = new FlxButton(0, 0, "Go Back", () -> 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> 
            {
                FlxG.switchState(new MenuState());
            });
        });
        _backBtn.screenCenter(X);
        _backBtn.y = _bossBtn.y + _backBtn.height + 2;
        _backBtn.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav);
        add(_backBtn);

        super.create();
    }
}