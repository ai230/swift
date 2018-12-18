/*:
 # Methods and Subclassing
 ---
 
 ## Topic Essentials
 A great way to add functionality to your classes is to give them their own methods. Like properties, you can create both instance and type methods for any class.
 
 ### Objectives
 + Create a simple version of our **Adventurer** class
 + Add an instance and a type method
 + Create a new class called **Ranger** as a subclass of **Adventurer**
 + Set up its designated initializer and override the parent class's instance method
 */
//Parent class
class Adventurer {
    var name: String
    static var credo = "Defend the helpless!"

    init(name: String) {
        self.name = name
    }
    
    // Instance methods
    func attack(damage: Int) {
        print("Attack for \(damage) hit points!")
    }

    // Type methods
    static func printCredo() {
        print(credo)
    }
}

// Subclass
class Ranger: Adventurer {
    var classAdvantage: String
    init(name: String, advantage: String) {
        self.classAdvantage = advantage
        super.init(name: name)
    }

    // Overriding methods
    override func attack(damage: Int) {
        print("Ranger attac for \(damage)!")
    }
}

var adventurer = Adventurer(name: "Harrison")
var ranger = Ranger(name: "Steven", advantage: "Stealth")

adventurer.attack(damage: 35)
ranger.attack(damage: 25)

Adventurer.printCredo()
Adventurer.credo

/*:
 [Previous Topic](@previous)
 
 [Next Topic](@next)
 */
