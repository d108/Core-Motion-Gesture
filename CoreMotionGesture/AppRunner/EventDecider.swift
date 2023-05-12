struct EventDecider
{
    static func randomInPercent(percent: Float) -> Bool
    {
        return Float.random(in: 0...1) <= percent
    }
}
