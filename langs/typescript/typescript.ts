
let isDone: boolean = false;

let decLiteral: number = 6;
let hexLiteral: number = 0xf00d;
let binaryLiteral: number = 0b1010;
let octalLiteral: number = 0o744;

// let name: string = "bob";
let name1 = "smith";

let name2: string = `Gene`;
let age: number = 37;
let sentence: string = `Hello, my name is ${ name2 }. I'll be ${ age + 1 } years old next month.`;

let list1: number[] = [1, 2, 3];
let list2: Array<number> = [1, 2, 3];

// Declare a tuple type
let x: [string, number];
// Initialize it
x = ['hello', 10]; // OK
// Initialize it incorrectly
// x = [10, 'hello']; // Error

console.log(x[0].substr(1)); // OK
// console.log(x[1].substr(1)); // Error, 'number' does not have 'substr'

x[3] = 'world'; // OK, 字符串可以赋值给(string | number)类型

console.log(x[5].toString()); // OK, 'string' 和 'number' 都有 toString

// x[6] = true; // Error, 布尔不是(string | number)类型


enum Color {Red, Green, Blue};
let c: Color = Color.Green;
let colorName: string = Color[2];

alert(colorName);

let notSure: any = 4;
notSure = "maybe a string instead";
notSure = false; // okay, definitely a boolean

notSure.ifItExists(); // okay, ifItExists might exist at runtime
notSure.toFixed(); // okay, toFixed exists (but the compiler doesn't check)

let prettySure: Object = 4;
// prettySure.toFixed(); // Error: Property 'toFixed' doesn't exist on type 'Object'.

let list: any[] = [1, true, "free"];

list[1] = 100;

function warnUser(): void {
    alert("This is my warning message");
}

let unusable: void = undefined;


let someValue: any = "this is a string";

let strLength1: number = (<string>someValue).length;

let strLength2: number = (someValue as string).length;
