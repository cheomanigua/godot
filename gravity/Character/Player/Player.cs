using Godot;
using System;
using System.Collections.Generic;
using System.Diagnostics;

public partial class Player : RigidBody2D
{
    public PackedScene BulletScene = (PackedScene)ResourceLoader.Load("res://Projectile/Bullet/bullet.tscn");
    private int _health = 10;

    public int Health
    {
        get => _health;
        set => _health = Mathf.Clamp(value, 0, 20);
    }
    private int _ammo = 10;
    public int Ammo
    {
        get => _ammo;
        set => _ammo = Mathf.Clamp(value, 0, 20);
    }
    private float _fuel = 20.0f;
    public float Fuel
    {
        get => _fuel;
        set => _fuel = Mathf.Clamp(value, 0.0f, 20.0f);
    }

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
            Fuel -= _fuelConsumption;
            _trace.Emitting = true;
            UpdateGUI();
            state.ApplyForce(_thrust.Rotated(Rotation));
            if (Mathf.IsEqualApprox(Fuel, 0.0f))
            {
                _thrust = Vector2.Zero;
                _trace.Emitting = false;
                EventManager.BroadcastMessage("Fuel depleted!");
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
            var bullet = BulletScene.Instantiate();
            GetParent().AddChild(bullet);
            bullet.Set("global_position", _muzzle.GlobalPosition);
            bullet.Call("look_at", _shootAt.GlobalPosition);
            Ammo -= 1;
            UpdateGUI();
        }
        else {
            EventManager.BroadcastMessage("Ammo depleted!");
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
            EventManager.BroadcastMessage("Landing Mode");
            Debug.Print($"Fuel consumption: {_fuelConsumption}");
        }
        else {
            _thrust = new Vector2(0, _maxThrust.Y);
            _fuelConsumption = _thrust.Y / _maxThrust.Y * _maxThrustConsumptionValue;
            _torque = 10000;
            EventManager.BroadcastMessage("Agile Mode");
            Debug.Print($"Fuel consumption: {_fuelConsumption}");
        }
    }

    private void take_damage(int damage)
    {
        Health -= damage;
        UpdateGUI();
        if (Health == 2)
        {
            EventManager.BroadcastMessage("Damage Critical!");
        }
        if (Health == 0)
        {
            EventManager.BroadcastMessage("You died!");
        }
    }

    private void take_item(string itemName, int itemValue)
    {
        switch (itemName)
        {
            case "health":
                Health += itemValue;
                break;
            case "ammo":
                Ammo += itemValue;
                break;
            case "fuel":
                Fuel += itemValue;
                break;
        }
        UpdateGUI();
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
        _stats.Text += $"{nameof(Fuel)}: {Fuel:F2}\n";
    }
}