using System;

public static class EventManager
{
    public static Action AttributeChangeEvent;
    public static Action<string> MessageEvent;

    public static void BroadcastAttributeChange()
    {
        AttributeChangeEvent?.Invoke();
    }

    public static void BroadcastMessage(string message)
    {
        MessageEvent?.Invoke(message);
    }
}
