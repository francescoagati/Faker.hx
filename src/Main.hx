import Faker.make;

typedef Tp1 = {x:Int, f:String, tp2:Tp2}
typedef Tp2 = {y:String}

typedef A = {
	a:Int,
	b:String,
	c:Float,
	d:Bool,
	tp1:Tp1,
	atp1:Array<Tp1>,
	e:Array<Int>,
	f:{
		g:Array<Bool>, ?h:String,y:Array<String>
	},
	?i:Int,
}

class Main {
	static function main() {
		var tower = make(A);
		trace(haxe.Json.stringify(tower, null, " "));
	}
}
