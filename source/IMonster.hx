/**
 * An interface to define the basic layout of all monsters.
 */
interface IMonster
{
	private var damage_per_seconds:Float;
	private var armor:Float;

	private function AI():Void;
}
