typealias Probability = Float

struct EventDecider
{
    static func random(with probability: Probability) -> Bool
    {
        return Float.random(in: 0...1) <= probability
    }
}
