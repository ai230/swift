/*:
 # Basic Swift Classes
 ---
 
 ## Topic Essentials
 Classes and structures are going to be the foundational building blocks of any application you write. You can add properties, methods and initializers to any class, and you can even create new classes as subclasses of other existing classes.
 
 ### Objectives
 + Create a simple class called **Adventurer**
 + Assign some instance properties with and without initial values
 + Add an optional class property
 + Add a type property
 + Define designated and convenience initializers
 + Explore computed properties, both read-only and read-write
 */
// Declaring a new class
class Adventurer {
    
    //Instance properties
    var name: String
    var hp: Int
    let maxHealth: Int = 100
    
    // Type properties
    static var credo = "Defend the helpless!"
    
    // Optionals
    var specialMove: String?
    
    // Computed properties
    var toFullHP: Int {
        return maxHealth - hp
    }
    
    var health: Int {
        get {
            return hp
        }
        
        set {
            hp = newValue
        }
    }
    
    // Class init
    init(name: String, hp: Int) {
        self.name = name
        self.hp = hp
    }
    
    convenience init(name: String) {
        self.init(name: name, hp: 100)
    }
}

var newPlayer = Adventurer(name: "Harrison", hp: 95)
var defaultPlayer = Adventurer(name: "Steven")

newPlayer.health
newPlayer.health = 85
newPlayer.health
newPlayer.hp
newPlayer.toFullHP

defaultPlayer.health

/*:
 [Previous Topic](@previous)
 
 [Next Topic](@next)
*/

