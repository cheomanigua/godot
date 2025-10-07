using Godot;

public partial class Giro : Marker2D
{
    private RayCast2D _raycast = new();
    public RayCast2D Raycast => _raycast;

    public override void _Ready()
    {
        AddChild(_raycast);
        _raycast.TargetPosition = new Vector2(350, 0);
    }

    public override void _PhysicsProcess(double delta)
    {
        QueueRedraw();
    }

    public override void _Draw()
    {
        DrawLine(_raycast.Position, _raycast.TargetPosition, Colors.Green, 1.0f);
        DrawCircle(_raycast.TargetPosition, 8.0f, Colors.SkyBlue, false);
    }
}
