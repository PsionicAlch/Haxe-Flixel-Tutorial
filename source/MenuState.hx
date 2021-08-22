package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxState;

class MenuState extends FlxState
{
    private var title:FlxText;
    private var play:FlxButton;
    private var testing:FlxButton;
    private var exit:FlxButton;
    
    override function create() 
    {
        title = new FlxText(0, 20, 0, "Introduction to HaxeFlixel", 18);
        title.alignment = CENTER;
        title.screenCenter(X);
        add(title);

        testing = new FlxButton(0, 0, "Test", clickTest);
        testing.screenCenter(XY);
        testing.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav);
        add(testing);

        play = new FlxButton(0, 0, "Play", clickPlay);
        play.screenCenter(X);
        play.y = testing.y - play.height - 2;
        play.onUp.sound = FlxG.sound.load(AssetPaths.button_press__wav);
        add(play);

        exit = new FlxButton(0, 0, "Exit", clickExit);
        exit.screenCenter(X);
        exit.y = testing.y + exit.height + 2;
        exit.onDown.sound = FlxG.sound.load(AssetPaths.button_press__wav);
        add(exit);

        if (FlxG.sound.music == null)
        {
            FlxG.sound.playMusic(AssetPaths.background_menu__ogg, 1, true);
        }

        super.create();
    }

    private function clickPlay() 
    {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> {
            FlxG.switchState(new LevelSelectState());
        });
    }

    private function clickTest()
    {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> {
            FlxG.switchState(new TestingMenuState());
        });
    }

    private function clickExit()
    {
        Sys.exit(0);
    }
}