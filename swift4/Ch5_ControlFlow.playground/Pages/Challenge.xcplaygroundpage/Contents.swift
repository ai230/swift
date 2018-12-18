/*:
 # Chapter Challenge: Game Conditions
 ---
 ### Tasks
 1. Create an optional called **currentWeapon** and assign it a string value
 2. Use optional binding to access **currentWeapon**
 3. Creat a variable called **currentEXP** and assign it an integer value
 4. Use a `switch` statement with **currentEXP** to evaluate different cases
 5. Create a dictionary called **playerLevels** and assign it some key-value pairs of type string and integer
 6. Use a `for-in` loop to iterate over **playerLevels** and print out its key-value pairs in an interpolated string
 7. Add a guard statement inside the `for-in` loop to mamke sure each player is at least level 1 to proceed
 */
// 1
var currentWeapon: String? = "Giant's hammer"

// 2
if let newCurrentWepon = currentWeapon {
    print("You have current wepon \(newCurrentWepon)")
} else {
    print("No you don't have it")
}

// 3
var currentEXP = 10

// 4
switch currentEXP {
case 1...5:
    print("Between 1 and 5")
case 6...10:
    print("Between 6 and 10")
default:
    print("\(currentEXP)")
}
// 5
var playerLevels = ["Blue": 1, "Yellow":0, "Green":3]

// 6
for (name, level) in playerLevels {
    print(" \(name) is \(level)")
}

// 7
for (name, level) in playerLevels {
    guard level > 0 else {
        print("\(name) is ander level1")
        continue
    }
    print("Level \(name) is \(level)")
}
//: [Previous Topic](@previous)
