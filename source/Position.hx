class Position
{
    private var _x: Float;
    private var _y: Float;

    public function new(x: Float, y: Float)
    {
        this._x = x;
        this._y = y;
    }

    public function getX(): Float
    {
        return this._x;
    }

    public function getY(): Float
    {
        return this._y;
    }
}