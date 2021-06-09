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
    private var exit:FlxButton;
    
    override function create() 
    {
        title = new FlxText(50, 0, 0, "Introduction to HaxeFlixel", 18);
        title.alignment = CENTER;
        title.screenCenter(X);
        add(title);

        play = new FlxButton(0, 0, "Play", clickPlay);
        play.x = (FlxG.width / 2) - (play.width / 2);
		play.y = (FlxG.height / 2);
        add(play);

        exit = new FlxButton(0, 0, "Exit", clickExit);
        exit.x = ((FlxG.width / 2) - exit.width / 2);
		exit.y = (FlxG.height / 2) + play.height + 10;
        add(exit);

        super.create();
    }

    private function clickPlay() 
    {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> {
            FlxG.switchState(new PlayState());
        });
    }

    private function clickExit()
    {
        Sys.exit(0);
    }
}