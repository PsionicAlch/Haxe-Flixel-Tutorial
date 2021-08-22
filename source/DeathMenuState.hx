import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class DeathMenuState extends FlxState
{
    private var _currentState:FlxState;
    private var _title:FlxText;
    private var _retryBtn:FlxButton;
    private var _exitMenuBtn:FlxButton;
    private var _exitDesktopBtn:FlxButton;

    public function new(currentState:FlxState) 
    {
        super();
        _currentState = currentState;    
    }
    
    override function create() 
    {
        _title = new FlxText(0, 20, 0, "You Died...", 18);
        _title.alignment = CENTER;
        _title.screenCenter(X);
        add(_title);

        _exitMenuBtn = new FlxButton(0, 0, "Exit to Main Menu", () -> FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> FlxG.switchState(new MenuState())));
        _exitMenuBtn.screenCenter(XY);
        _exitMenuBtn.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav, 1, false);
        add(_exitMenuBtn);

        _retryBtn = new FlxButton(0, 0, "Restart Level", () -> FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> FlxG.switchState(_currentState)));
        _retryBtn.screenCenter(X);
        _retryBtn.y = _exitMenuBtn.y - _retryBtn.height - 2;
        _retryBtn.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav, 1, false);
        add(_retryBtn);

        _exitDesktopBtn = new FlxButton(0, 0, "Exit to Desktop", () -> Sys.exit(0));
        _exitDesktopBtn.screenCenter(X);
        _exitDesktopBtn.y = _exitMenuBtn.y + _exitDesktopBtn.height + 2;
        _exitDesktopBtn.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav, 1, false);
        add(_exitDesktopBtn);

        super.create();
    }
}