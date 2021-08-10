import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxSubState;

class PauseMenu extends FlxSubState
{
  private var _title: FlxText;
  private var _backBtn: FlxButton;
  private var _menuBtn: FlxButton;
  private var _desktopBtn: FlxButton;

  override function create() {
    super.create();

    _title = new FlxText(0, 40, 0, "Pause Menu", 18);
    _title.alignment = CENTER;
    _title.screenCenter(X);
    add(_title);

    _menuBtn = new FlxButton(0, 0, "Exit to Main Menu", () -> {
      FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> {
        FlxG.switchState(new MenuState());
      });
    });
    _menuBtn.screenCenter(XY);
    add(_menuBtn);

    _backBtn = new FlxButton(0, 0, "Continue", () -> close());
    _backBtn.screenCenter(X);
    _backBtn.y = _menuBtn.y - _backBtn.height - 2;
    add(_backBtn);

    _desktopBtn = new FlxButton(0, 0, "Exit to Desktop", () -> Sys.exit(0));
    _desktopBtn.screenCenter(X);
    _desktopBtn.y = _menuBtn.y + _desktopBtn.height + 2;
    add(_desktopBtn);
  }
}