using Godot;
using System;
using System.Diagnostics;
using System.Runtime.CompilerServices;

public partial class Turret : StaticBody2D
{
    public PackedScene bulletScene = (PackedScene)ResourceLoader.Load("res://Projectile/Bullet/bullet.tscn");
    public GDScript bulletGDScript = GD.Load<GDScript>("res://Projectile/Bullet/bullet.gd");

    enum Munition { LOW_DAMAGE, MEDIUM_DAMAGE, HIGH_DAMAGE }
    [Export]Munition munitionType = Munition.LOW_DAMAGE;
    [Export]float reloadTime = 1f;
    [Export] float cannonRotation = 0f;

    bool detected = false;
    bool canShoot = true;
    float elapsed = 10f;
    Node2D player;
    private Timer timer = new();
    private Sprite2D _cannon;
    private Marker2D _giro;
    private RayCast2D _raycast;

    public override void _Ready()
    {
        AddChild(timer);
        timer.Timeout += OnTimerTimeout;
        timer.Start(reloadTime);

        var radar = GetNode<Area2D>("%Radar");

        radar.Connect("player_detected", Callable.From<Node2D>(OnPlayerDetected));
        radar.Connect("player_lost", Callable.From<Node2D>(OnPlayerLost));

        _cannon = GetNode<Sprite2D>("%Cannon");

        _giro = GetNode<Marker2D>("%Giro");
        _raycast = (RayCast2D)_giro.Call("get_raycast");
    }

    public override void _PhysicsProcess(double delta)
    {
        if (detected)
        {
            Vector2 target = Position.DirectionTo(player.Position);
            var facing = _giro.Transform.X;
            var fov = target.Dot(facing); // Remove fov if you want full 360 rotation

            if (fov > 0)
            {
                _giro.Rotation = (float)Mathf.LerpAngle(_giro.Rotation, target.Angle(), elapsed * delta);
                if (canShoot)
                {
                    if (_raycast.IsColliding())
                    {
                        var collider = _raycast.GetCollider();
                        if (collider != player)
                        {
                            timer.Stop();
                            canShoot = true;
                        }
                        else
                        {
                            if (canShoot)
                            {
                                Shoot();
                                canShoot = false;
                                timer.Start();
                            }
                        }
                    }
                }
            }
            else
            {
                timer.Stop();
                canShoot = true;
            }
        }
        else
        {
            timer.Stop();
            canShoot = true;
        }
    }

    private void OnPlayerDetected(Node2D body)
    {
        player = body;
        detected = true;
        _raycast.Enabled = true;
    }

    public void OnPlayerLost(Node2D body)
    {
        detected = false;
        _raycast.Enabled = false;
    }

    public void OnTimerTimeout()
    {
        canShoot = true;
    }
    public void Shoot()
    {
        Tween tween = CreateTween();
        tween.TweenProperty(_cannon, "position", new Vector2(-10, 0), 0.2f * reloadTime).AsRelative().SetTrans(Tween.TransitionType.Sine);
        tween.TweenProperty(_cannon, "position", new Vector2(10, 0), 0.2f * reloadTime).AsRelative().SetTrans(Tween.TransitionType.Sine);


        var bullet = (Area2D)bulletScene.Instantiate();
        bullet.Transform = new Transform2D(_giro.Rotation, _giro.GlobalPosition + _giro.Transform.X * 32);
        bullet.Set("munition_index", (int)munitionType);
        GetParent().AddChild(bullet);

        // var new_bullet = (GodotObject)bulletGDScript.New();
        // new_bullet.Call("create_bullet", (int)munitionType, Rotation, Position);
        // GetParent().AddChild((Node)new_bullet);
    }
}
