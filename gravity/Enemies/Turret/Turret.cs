using System;
using Godot;

public partial class Turret : StaticBody2D
{
    public PackedScene BulletScene = (PackedScene)ResourceLoader.Load("res://Projectile/Bullet/bullet.tscn");
    public GDScript BulletGDScript = GD.Load<GDScript>("res://Projectile/Bullet/bullet.gd");

    enum Munition { LOW_DAMAGE, MEDIUM_DAMAGE, HIGH_DAMAGE }
    [Export] Munition MunitionType = Munition.LOW_DAMAGE;
    [Export] int Health = 0;
    [Export] float ReloadTime = 1f;
    [Export] float CannonRotation = 0f;

    private bool _detected = false;
    private bool _canShoot = true;
    private float _elapsed = 10f;
    private Node2D _player;
    private Timer _timer = new();
    private Sprite2D _cannon;
    private Giro _giro;
    private RayCast2D _raycast;

    public override void _Ready()
    {
        AddChild(_timer);
        _timer.Timeout += OnTimerTimeout;
        _timer.Start(ReloadTime);

        var radar = GetNode<Area2D>("%Radar");
        radar.Connect("player_detected", Callable.From<Node2D>(OnPlayerDetected));
        radar.Connect("player_lost", Callable.From<Node2D>(OnPlayerLost));

        _cannon = GetNode<Sprite2D>("%Cannon");

        _giro = GetNode<Giro>("%Giro");
        _giro.Rotation = Mathf.DegToRad(CannonRotation);

        _raycast = _giro.Raycast;
    }

    public override void _PhysicsProcess(double delta)
    {
        if (_detected)
        {
            Vector2 target = Position.DirectionTo(_player.Position);
            var facing = _giro.Transform.X;
            var fov = target.Dot(facing);

            if (fov > 0)
            {
                _giro.Rotation = (float)Mathf.LerpAngle(_giro.Rotation, target.Angle(), _elapsed * delta);
                if (_canShoot)
                {
                    if (_raycast.IsColliding())
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
        Tween tween = CreateTween();
        tween.TweenProperty(_cannon, "position", new Vector2(-10, 0), 0.2f * ReloadTime).AsRelative().SetTrans(Tween.TransitionType.Sine);
        tween.TweenProperty(_cannon, "position", new Vector2(10, 0), 0.2f * ReloadTime).AsRelative().SetTrans(Tween.TransitionType.Sine);


        var bullet = (Area2D)BulletScene.Instantiate();
        bullet.Transform = new Transform2D(_giro.Rotation, _giro.GlobalPosition + _giro.Transform.X * 32);
        bullet.Set("munition_index", (int)MunitionType);
        GetParent().AddChild(bullet);

        // var new_bullet = (GodotObject)BulletGDScript.New();
        // new_bullet.Call("create_bullet", (int)MunitionType, Rotation, Position);
        // GetParent().AddChild((Node)new_bullet);
    }

    public void TakeDamage(int damage)
    {
        var label = new Label();
        AddChild(label);
        label.Position = new Vector2(0, -50) + new Vector2(GD.RandRange(-20, 20), 0);
        label.Position = new Vector2(-10, -30) + new Vector2(GD.RandRange(-20, 20), 0);
        label.Text = $"{damage}";

        Tween tween = CreateTween();
        tween.TweenProperty(label, "position", new Vector2(0, -30), 2.0f).AsRelative().SetEase(Tween.EaseType.InOut);
        tween.SetParallel();
        tween.TweenProperty(label, "modulate:a", 0, 2.0f);
        tween.Connect("finished", Callable.From(() => label.QueueFree()));

        Health -= damage;
        if (Health <= 0) QueueFree();
    }
}
