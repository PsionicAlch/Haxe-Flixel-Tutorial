import Projectile.ProjectileType;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;

class BossMonster extends FlxSprite
{
	private var _attackTimer:Float;
	private var _attackCounter:Float;
	private var _target:FlxObject;
	private var _attackType:Int;
	private var _projectileType:ProjectileType;
	private var _projectileTimer:Float;
	private var _projectileCounter:Float;
	private var _shouldFire:Bool;
	private var _stunVar:Float;

	private static final MOVEMENT_SPEED:Int = 400;

	public function new(x:Float, y:Float, target:FlxObject)
	{
		super(x, y);
		_target = target;
		_attackTimer = Random.float(1, 10);
		_attackCounter = 0;
		_attackType = Random.int(0, 9);
		_projectileCounter = 0;
		_projectileTimer = 0;
		_shouldFire = false;
		_stunVar = 0;

		loadGraphic(AssetPaths.Demon__png, true, 32, 32);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);

		animation.add("down", [1, 2, 3, 4, 5], 6, true);
		animation.add("left", [6, 7, 8, 9, 10, 11, 12], 7, true);
		animation.add("right", [6, 7, 8, 9, 10, 11, 12], 7, true);
		animation.add("up", [13, 14, 15, 16, 17, 18], 6, true);
	}

	override function update(elapsed:Float)
	{		
		_attackCounter += elapsed;
		_projectileCounter += elapsed;

		if (_stunVar <= 0.0) 
		{
			if (_attackCounter >= _attackTimer)
			{
				_attackCounter = 0;
				_attackTimer = Random.float(0.0, 10.0);
				_attackType = Random.int(0, 9);
			}

			attack(_attackType);
		}
		else if (_stunVar > 0.0) 
		{
			_stunVar -= elapsed;
		}

		if (_stunVar < 0) 
		{
			_stunVar = 0;
		}

		animate();

		super.update(elapsed);
	}

	public function getTarget():FlxObject
	{
		return _target;
	}

	public function setTarget(newTarget:FlxObject)
	{
		_target = newTarget;
	}

	public function getProjectileType():ProjectileType
	{
		return _projectileType;
	}

	public function getShouldFire():Bool
	{
		return _shouldFire;
	}

	public function stun() {
		if (_stunVar > 0.0)
			_stunVar = 2.0;
	}

	private function attack(attackType:Int)
	{
		switch (attackType)
		{
			case 1:
				moveToTarget();
			case 2:
				_projectileType = ProjectileType.FIRE_BOLT;
				_projectileTimer = 0.3;
				velocity.x = velocity.y = 0;
				handleShooting();
			case 3:
				_projectileType = ProjectileType.ICE_BOLT;
				_projectileTimer = 0.3;
				velocity.x = velocity.y = 0;
				handleShooting();
			case 4:
				_projectileType = ProjectileType.POISON_BOLT;
				_projectileTimer = 0.3;
				velocity.x = velocity.y = 0;
				handleShooting();
			case 5:
				_projectileType = ProjectileType.SHOCK_BOLT;
				_projectileTimer = 0.3;
				velocity.x = velocity.y = 0;
				handleShooting();
			case 6:
				_projectileType = ProjectileType.FIRE_BOLT;
				_projectileTimer = 0.3;
				velocity.x = velocity.y = 0;
				handleShooting();
			case 7:
				_projectileType = ProjectileType.ICE_BOLT;
				_projectileTimer = 0;
				velocity.x = velocity.y = 0;
				handleShooting();
			case 8:
				_projectileType = ProjectileType.POISON_BOLT;
				_projectileTimer = 0;
				velocity.x = velocity.y = 0;
				handleShooting();
			case 9:
				_projectileType = ProjectileType.SHOCK_BOLT;
				_projectileTimer = 0;
				velocity.x = velocity.y = 0;
				handleShooting();
			default:
				moveToTarget();
		}
	}

	private function moveToTarget()
	{
		FlxVelocity.moveTowardsPoint(this, _target.getPosition(), MOVEMENT_SPEED);

		if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
		{
			if (Math.abs(velocity.x) > Math.abs(velocity.y))
			{
				if (velocity.x < 0)
					facing = FlxObject.LEFT;
				else
					facing = FlxObject.RIGHT;
			}
			else
			{
				if (velocity.y < 0)
					facing = FlxObject.UP;
				else
					facing = FlxObject.DOWN;
			}
		}

		_shouldFire = false;
	}

	private function handleShooting()
	{
		if (_projectileCounter >= _projectileTimer)
		{
			_shouldFire = true;
			_projectileCounter = 0;
		}
		else
		{
			_shouldFire = false;
		}
	}

	private function animate()
	{
		if (velocity.x != 0 || velocity.y != 0)
		{
			switch (facing)
			{
				case FlxObject.UP:
					animation.play("up");
				case FlxObject.LEFT:
					animation.play("left");
				case FlxObject.DOWN:
					animation.play("down");
				case FlxObject.RIGHT:
					animation.play("right");
			}
		}
		else if (velocity.x == 0 || velocity.y == 0)
		{
			switch (facing)
			{
				case FlxObject.UP:
					animation.play("up");
				case FlxObject.LEFT:
					animation.play("left");
				case FlxObject.DOWN:
					animation.play("down");
				case FlxObject.RIGHT:
					animation.play("right");
			}
		}
	}
}
