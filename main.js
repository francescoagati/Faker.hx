// Generated by Haxe 4.0.0-rc.1+1fdd3d59b
(function () { "use strict";
var HxOverrides = function() { };
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Main = function() { };
Main.main = function() {
	console.log("src/Main.hx:23:",JSON.stringify({ a : Math.floor(1001 * Math.random()), atp1 : [{ f : Random.string(100,"abcdefghilmnopqrstuvz1234567890"), tp2 : { y : Random.string(100,"abcdefghilmnopqrstuvz1234567890")}, x : Math.floor(1001 * Math.random())}], b : Random.string(100,"abcdefghilmnopqrstuvz1234567890"), c : Math.floor(1001 * Math.random()), d : Math.random() < 0.5, e : [Math.floor(101 * Math.random())], f : { g : [Math.random() < 0.5]}, tp1 : { f : Random.string(100,"abcdefghilmnopqrstuvz1234567890"), tp2 : { y : Random.string(100,"abcdefghilmnopqrstuvz1234567890")}, x : Math.floor(1001 * Math.random())}},null," "));
};
var Random = function() { };
Random.string = function(length,charactersToUse) {
	if(charactersToUse == null) {
		charactersToUse = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	}
	var str = "";
	var _g = 0;
	while(_g < length) {
		++_g;
		str += charactersToUse.charAt(Math.floor((charactersToUse.length - 1 + 1) * Math.random()));
	}
	return str;
};
Main.main();
})();
