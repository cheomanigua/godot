using System.Diagnostics;
using Godot;

public partial class Donut : Area2D
{
    public PackedScene bulletScene = (PackedScene)ResourceLoader.Load("res://Projectile/Bullet/bullet.tscn");
    public GDScript bulletGDScript = GD.Load<GDScript>("res://Projectile/Bullet/bullet.gd");

    enum Munition { LOW_DAMAGE, MEDIUM_DAMAGE, HIGH_DAMAGE }
    [Export]Munition munitionType = Munition.LOW_DAMAGE;
    [Export]float reloadTime = 1f;

    bool detected = false;
    bool canShoot = true;
    float elapsed = 10f;
    Node2D player;
    private RayCast2D raycast = new();
    private Timer timer = new();
  

    public override void _Ready()
    {
        AddChild(raycast);
        raycast.TargetPosition = new Vector2(350, 0);
        
        AddChild(timer);
        timer.Timeout += OnTimerTimout;
        timer.Start(reloadTime);

        var radar = GetNode<Area2D>("%Radar");

        radar.Connect("player_detected", Callable.From<Node2D>(OnPlayerDetected));
        radar.Connect("player_lost", Callable.From<Node2D>(OnPlayerLost));
    }

    public override void _PhysicsProcess(double delta)
    {
        if (detected)
        {
            Vector2 target = Position.DirectionTo(player.Position);
            var facing = Transform.X;
            var fov = target.Dot(facing);

            if (fov > 0)
            {
                Rotation = (float)Mathf.LerpAngle(Rotation, target.Angle(), elapsed * delta);
                if (canShoot)
                {
                    if (raycast.IsColliding())
                    {
                        var collider = raycast.GetCollider();
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

        QueueRedraw();
    }

    public override void _Draw()
    {
        DrawLine(raycast.Position, raycast.TargetPosition, Colors.Green, 1.0f);
        DrawCircle(raycast.TargetPosition, 8.0f, Colors.SkyBlue, false);
    }

    private void OnPlayerDetected(Node2D body)
    {
        player = body;
        detected = true;
        raycast.Enabled = true;
    }

    public void OnPlayerLost(Node2D body)
    {
        detected = false;
        raycast.Enabled = false;
    }

    public void OnTimerTimout()
    {
        canShoot = true;
    }

    public void Shoot()
    {
        var new_bullet = (Area2D)bulletScene.Instantiate();
        new_bullet.Transform = new Transform2D(Rotation, Position);
        new_bullet.Set("munition_index", (int)munitionType);
        GetParent().AddChild(new_bullet);

        // var new_bullet = (GodotObject)bulletGDScript.New();
        // new_bullet.Call("create_bullet", (int)munitionType, Rotation, Position);
        // GetParent().AddChild((Node)new_bullet);
    }
}
