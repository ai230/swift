/*:
 # Type Aliasing
 ---
 
 ## Topic Essentials
 Type aliasing is a great tool for combining complex or unwieldy custom values or collections of values into clearer types.
 
 ### Objectives
 + Create a type alias called **AttackTuple** and give it a type of (String, Int, Bool)
 + Create a type alias for a closure called **ArrayClosure** and give it a type of ([String]) -> Void
 + Use **AttackTuple** as a return type for a function
 + Use **ArrayClosure** as an input parameter for a function
 */
// Test variables
typealias AttackTuple = (String, Int, Bool)
var sunStrike: AttackTuple = ("Sun Strike", 35, false)

typealias ArrayCloture = ([Int]) -> Void

// Type alias as a return value
func returnAttack() -> AttackTuple {
    return ("Hunmer Sweep", 42, true)
}

print(returnAttack())

// Type alias as a function parameter
func fetchPlayerScores(closure: ArrayCloture) {
    let scores = [934,234,101]
    closure(scores)
}

fetchPlayerScores { (scores) in
    for score in scores {
        print(score)
    }
}
/*:
 [Previous Topic](@previous)
 
 [Next Topic](@next)
 */
