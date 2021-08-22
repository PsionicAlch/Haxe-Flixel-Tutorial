import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.util.FlxColor;

class WinMenuState extends FlxState
{
    private var _nextLevel:FlxState;
    private var _title:FlxText;
    private var _nextLvlBtn:FlxButton;
    private var _exitMainBtn:FlxButton;
    private var _exitDesktopBtn:FlxButton;
    
    public function new(?nextLevel = null) 
    {
        super();
        _nextLevel = nextLevel;    
    }

    override function create() 
    {
        _title = new FlxText(0, 40, 0, "Congratulations!", 18);
        _title.alignment = CENTER;
        _title.screenCenter(X);
        add(_title);

        if (_nextLevel == null)
        {
            _exitMainBtn = new FlxButton(0, 0, "Exit to Main Menu", exitMenuFunc);
            _exitMainBtn.screenCenter(XY);
            _exitMainBtn.y = _exitMainBtn.y - (_exitMainBtn.height / 2) - 1;
            _exitMainBtn.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav, 1, false);
            add(_exitMainBtn);

            _exitDesktopBtn = new FlxButton(0, 0, "Exit to Desktop", exitDesktopFunc);
            _exitDesktopBtn.screenCenter(XY);
            _exitDesktopBtn.y = _exitDesktopBtn.y + (_exitDesktopBtn.height / 2) + 1;
            _exitDesktopBtn.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav, 1, false);
            add(_exitDesktopBtn);
        }
        else
        {
            _exitMainBtn = new FlxButton(0, 0, "Exit to Main Menu", exitMenuFunc);
            _exitMainBtn.screenCenter(XY);
            _exitMainBtn.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav, 1, false);
            add(_exitMainBtn);

            _nextLvlBtn = new FlxButton(0, 0, "Next Level", nextLevelFunc);
            _nextLvlBtn.screenCenter(X);
            _nextLvlBtn.y = _exitMainBtn.y - _nextLvlBtn.height - 2;
            _nextLvlBtn.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav, 1, false);
            add(_nextLvlBtn);

            _exitDesktopBtn = new FlxButton(0, 0, "Exit to Desktop", exitDesktopFunc);
            _exitDesktopBtn.screenCenter(X);
            _exitDesktopBtn.y = _exitMainBtn.y + _exitDesktopBtn.height + 2;
            _exitDesktopBtn.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav, 1, false);
            add(_exitDesktopBtn);
        }

        super.create();
    }

    private function nextLevelFunc()
    {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> 
        {
            FlxG.switchState(_nextLevel);
        });
    }

    private function exitMenuFunc()
    {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> 
        {
            FlxG.switchState(new MenuState());
        });
    }

    private function exitDesktopFunc()
    {
        Sys.exit(0);
    }
}