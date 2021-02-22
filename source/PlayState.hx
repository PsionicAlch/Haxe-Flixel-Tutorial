package;

import flixel.FlxState;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();

		var text = new FlxText(0, 0, 0, "Hello World!", 64);
		text.screenCenter();
		add(text);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
