using Godot;

public partial class Donut : StaticBody2D
{
    public PackedScene BulletScene = (PackedScene)ResourceLoader.Load("res://Projectile/Bullet/bullet.tscn");
    public GDScript BulletGDScript = GD.Load<GDScript>("res://Projectile/Bullet/bullet.gd");

    enum Munition { LOW_DAMAGE, MEDIUM_DAMAGE, HIGH_DAMAGE }
    [Export] Munition MunitionType = Munition.LOW_DAMAGE;
    [Export] float ReloadTime = 1f;

    private bool _detected = false;
    private bool _canShoot = true;
    private float _elapsed = 10f;
    private Node2D _player;
    private RayCast2D _raycast = new();
    private Timer _timer = new();
  

    public override void _Ready()
    {
        AddChild(_raycast);
        _raycast.TargetPosition = new Vector2(350, 0);
        
        AddChild(_timer);
        _timer.Timeout += OnTimerTimeout;
        _timer.Start(ReloadTime);

        var radar = GetNode<Area2D>("%Radar");
        radar.Connect("player_detected", Callable.From<Node2D>(OnPlayerDetected));
        radar.Connect("player_lost", Callable.From<Node2D>(OnPlayerLost));
    }

    public override void _PhysicsProcess(double delta)
    {
        if (_detected)
        {
            Vector2 target = Position.DirectionTo(_player.Position);
            var facing = Transform.X;
            var fov = target.Dot(facing);

            if (fov > 0)
            {
                Rotation = (float)Mathf.LerpAngle(Rotation, target.Angle(), _elapsed * delta);
                if (_canShoot && _raycast.IsColliding())
                {
                    var collider = _raycast.GetCollider();
                    if (collider != _player)
                    {
                        _timer.Stop();
                        _canShoot = true;
                    }
                    else
                    {
                        if (_canShoot)
                        {
                            Shoot();
                            _canShoot = false;
                            _timer.Start();
                        }
                    }
                }
            }
            else
            {
                _timer.Stop();
                _canShoot = true;
            }
        }
        else
        {
            _timer.Stop();
            _canShoot = true;
        }

        QueueRedraw();
    }

    public override void _Draw()
    {
        DrawLine(_raycast.Position, _raycast.TargetPosition, Colors.Green, 1.0f);
        DrawCircle(_raycast.TargetPosition, 8.0f, Colors.SkyBlue, false);
    }

    private void OnPlayerDetected(Node2D body)
    {
        _player = body;
        _detected = true;
        _raycast.Enabled = true;
    }

    public void OnPlayerLost(Node2D body)
    {
        _detected = false;
        _raycast.Enabled = false;
    }

    public void OnTimerTimeout()
    {
        _canShoot = true;
    }

    public void Shoot()
    {
        var bullet = (Area2D)BulletScene.Instantiate();
        bullet.Transform = new Transform2D(Rotation, Position + Transform.X * 20);
        bullet.Set("munition_index", (int)MunitionType);
        GetParent().AddChild(bullet);

        // var bullet = (GodotObject)BulletGDSCript.New();
        // bullet.Call("create_bullet", (int)MunitionType, Rotation, Position);
        // GetParent().AddChild((Node)bullet);
    }
}
