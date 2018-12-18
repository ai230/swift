/*:
 # Chapter Challenge: Battle Grounds
 ---
 
 ### Tasks
 1. Create a type alias called **Attack** with named values for name and damage
 2. Create a type alias called **ItemClosure** with a dictionary of string keys and int values as its paramater and no retur value
 3. Write  valuea simple function called **attackEnemy** with an integer parameter that prints out an interpolated string
 4. Write an overloaded version of **attackEnemy** with a parameter of type Attack and returns a boolean
 5. Use both **attackEnemy** methods
 6. Write a function called **fetchShopItems** that has a closure parameter of type ItemClosure and use it to return an array of scores
 7. Call the **fetchPlayerItems** closure, loop through the shop items and print out an interpolated string
 */
// 1
typealias Attack = (name: String, damage: Int)

// 2
typealias ItemClosure = ([String: Int]) -> Void

// 3
func attackEnemy(attacked: Int) {
    print("Attacked \(attacked) hp")
}

// 4
func attackEnemy(attack: Attack) -> Bool {
    print("You attacked with \(attack.name) hit for \(attack.damage)!\n")
    return false
}

// 5
attackEnemy(attacked: 56)
var enemyWasDefeated = attackEnemy(attack: ("Power slam", 77))

// 6
func fetchShopItems(closure: ItemClosure) {
    let items = ["Soap":12, "Shampoo":8, "Hand cream":16]
    closure(items)
}

// 7
fetchShopItems { (itemsDictionary) in
    for (item, value) in itemsDictionary {
        print("\(item) ->\(value)")
    }
}
//: [Previous Topic](@previous)
