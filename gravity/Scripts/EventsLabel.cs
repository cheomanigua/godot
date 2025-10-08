using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;
using Godot;

public partial class EventsLabel : Label
{
    private CancellationTokenSource _cts = new CancellationTokenSource();

    // Prevent duplicate subscriptions
    public override void _Ready()
    {
        EventManager.MessageEvent -= OnMessageEvent;
        EventManager.MessageEvent += OnMessageEvent;
        Visible = false;
    }

    public override void _ExitTree()
    {
        EventManager.MessageEvent -= OnMessageEvent; // Unsubscribe to prevent memory leaks if node is deleted
        _cts.Cancel();
        _cts.Dispose();
    }

    private void OnMessageEvent(string message)
    {
        Text = message;
        _cts.Cancel();
        _cts.Dispose();
        _cts = new CancellationTokenSource();
        WaitForTimeout(_cts.Token);
    }

    public async void WaitForTimeout(CancellationToken cancellationToken)
    {
        Visible = true;
        try
        {
            await Task.Delay(3000, cancellationToken);
            Visible = false;
        }
        catch (TaskCanceledException)
        {
            Debug.Print("Cancelling gracefully");
        }
    }
}