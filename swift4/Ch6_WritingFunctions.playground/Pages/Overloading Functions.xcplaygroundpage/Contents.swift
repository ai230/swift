/*:
 # Overloading Functions
 ---
 
 ## Topic Essentials
 Swift 4 allows us to have multiple functions with the same name as long as their function type, or signature, is different. This is called overloading a function, and is very useful in cases when you may need constant functionality, but with different inputs and outputs.
 
 ### Objectives
 + Create a base function called **attack** with no parameters or return values
 + Create an overloaded function of **attack** with an integer parameter
 + Create another overloaded function of **attack** with two parameters and a return type
 */
// Base function
func attack() {
    print("Attacking!")
}

// Overloaded functions
func attack(damage: Int) {
    print("Attacking for \(damage)!")
}

func attack(damage: Double, weapon: String) -> Bool {
    print("\(damage) damage dealt to enemy.")
    return true
}

attack()
attack(damage: 35)
attack(damage: 30.5, weapon: "Hammer")

/*:
 [Previous Topic](@previous)
 
 [Next Topic](@next)
 */
