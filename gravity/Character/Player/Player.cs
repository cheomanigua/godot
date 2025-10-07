using Godot;
using System.Collections.Generic;
using System.Diagnostics;

public partial class Player : RigidBody2D
{
    public PackedScene bulletScene = (PackedScene)ResourceLoader.Load("res://Projectile/Bullet/bullet.tscn");

    private int _health;
    public int Health { get; set; } = 10;
    private int _ammo;
    public int Ammo { get; set; } = 20;
    private float _fuel;
    public float Fuel { get; set; } = 20.0f;

    // Dictionary<string, object> attributes = new Dictionary<string, object>
    // {
    //     {"health", 0},
    //     {"ammo", 0},
    //     {"fuel", 0.0f}
    // };

    // Dictionary<string, object> top = new Dictionary<string, object>
    // {
    //     {"health", 10},
    //     {"ammo", 20},
    //     {"fuel", 20.0f}
    // };

    private Vector2 _maxThrust = new(0, -500);
    private Vector2 _thrust;
    private float _maxThrustConsumptionValue = 0.01f;
    private float _fuelConsumption;
    private int _torque = 10000;
    private bool _isModeSwitched = false;
    private GpuParticles2D _trace;
    private Marker2D _muzzle;
    private Marker2D _shootAt;
    private Label _stats;

    public override void _Ready()
    {
        _thrust = _maxThrust;
        _fuelConsumption = _thrust.Y / _maxThrust.Y * _maxThrustConsumptionValue;

        GravityScale = 0.2f;
        AngularDamp = 20.0f;
        Mass = 1.0f;

        _trace = GetNode<GpuParticles2D>("%Trace");  
        _muzzle = GetNode<Marker2D>("%Muzzle");
        _shootAt = GetNode<Marker2D>("%ShootAt");
        _stats = GetNode<Label>("%Stats");

        UpdateGUI();

        // foreach (var key in attributes.Keys)
        // {
        //     if (key == "fuel")
        //     {
        //         attributes[key] = System.Convert.ToSingle(top[key]); // Handle float for fuel
        //     }
        //     else
        //     {
        //         attributes[key] = (int)top[key]; // Handle int for health, ammo
        //     }
        // }
    }

    public override void _UnhandledKeyInput(InputEvent @event)
    {
        if (@event.IsActionPressed("ui_select"))
        {
            Shoot();
        }
        if (@event.IsActionPressed("ui_cancel"))
        {
            GetTree().Quit();
        }
        if (@event is InputEventKey keyEvent)
        {
            if (keyEvent.Pressed && keyEvent.Keycode == Key.Q)
            {
                SwitchMode();
            }                
        }
    }

    public override void _IntegrateForces(PhysicsDirectBodyState2D state)
    {
        if (Input.IsActionPressed("ui_up"))
        {
            Fuel = System.Math.Max(0f, Fuel - _fuelConsumption);
            _trace.Emitting = true;
            UpdateGUI();
            state.ApplyForce(_thrust.Rotated(Rotation));
            if (Fuel <= 0.0f)
            {
                _thrust = Vector2.Zero;
                _trace.Emitting = false;
                Debug.Print("Fuel depleted"); // IMPLEMENT SIGNAL INSTEAD
            }
        }
        else {
            _trace.Emitting = false;
        }

        var _rotationDirection = Input.GetAxis("ui_left", "ui_right");
        state.ApplyTorque(_rotationDirection * _torque);
    }

    private void Shoot()
    {
        if (Ammo > 0)
        {
            var bullet = bulletScene.Instantiate();
            GetParent().AddChild(bullet);
            bullet.Set("global_position", _muzzle.GlobalPosition);
            bullet.Call("look_at", _shootAt.GlobalPosition);
            Ammo = System.Math.Max(0, Ammo - 1);
            UpdateGUI();
        }
        else {
            Debug.Print("Ammo depleted!"); // IMPLEMENT SIGNAL INSTEAD
        }
    }

    private void SwitchMode()
    {
        _isModeSwitched = !_isModeSwitched;
        if (_isModeSwitched)
        {
            _thrust = new Vector2(0, -250);
            _fuelConsumption = _thrust.Y / _maxThrust.Y * _maxThrustConsumptionValue;
            _torque = 3000;
            Debug.Print("Landing mode");
            Debug.Print($"Fuel consumption: {_fuelConsumption}");
        }
        else {
            _thrust = new Vector2(0, _maxThrust.Y);
            _fuelConsumption = _thrust.Y / _maxThrust.Y * _maxThrustConsumptionValue;
            _torque = 10000;
            Debug.Print("Agile mode");
            Debug.Print($"Fuel consumption: {_fuelConsumption}");
        }
    }

    private void take_damage(int damage)
    {
        Health = System.Math.Max(0, Health - damage);
        UpdateGUI();
        if (Health == 2)
        {
            Debug.Print("Damage critical!"); // IMPLEMENT SIGNAL INSTEAD
        }
        if (Health == 0)
        {
            Debug.Print("You died!"); // IMPLEMENT SIGNAL INSTEAD
        }
    }

    private void UpdateGUI()
    {
        _stats.Text = "";
        // foreach (var key in attributes.Keys)
        // {
        //     if (key == "fuel")
        //     {
        //         // Format fuel as a float with two decimal places
        //         _stats.Text += $"{key}: {(float)attributes[key]:F2}\n";
        //     }
        //     else
        //     {
        //         // Format other attributes as integers
        //         _stats.Text += $"{key}: {(int)attributes[key]}\n";
        //     }
        // }
        _stats.Text += $"{nameof(Health)}: {Health}\n";
        _stats.Text += $"{nameof(Ammo)}: {Ammo}\n";
        _stats.Text += $"{nameof(Fuel)}: {Fuel}\n";
    }
}