#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

using StringTools;
using haxe.macro.Tools;
#end

@:dce
class Faker {
	public static macro function make(typeExpr:Expr, fieldExprs:Array<Expr>):Expr {
		var type = try Context.getType(typeExpr.toString()) catch (e:Dynamic) throw new Error(e.toString(), typeExpr.pos);

		switch (type.follow()) {
			case TAnonymous(_.get() => anon):
				var fieldInits = new Map();
				for (e in fieldExprs) {
					switch (e) {
						case macro $i{fieldName} = $value:
							fieldInits[fieldName] = {expr: value.expr, pos: e.pos};
						default:
							throw new Error("Invalid field initialization expression: should be fieldName = value", e.pos);
					}
				}

				var pos = Context.currentPos();
				var objectDecl = getAnonDefaultValueExpr(anon, pos, fieldInits);
				var objectType = type.toComplexType();
				return macro @:pos(pos) ($objectDecl : $objectType);
			default:
				throw new Error("Make should only be used on structure types", typeExpr.pos);
		}
	}

	#if macro
	static function getDefaultValueExpr(type:Type, pos:Position):Expr {
		var e = switch (type.follow()) {
			case TAbstract(_.get() => {pack: [], name: "Int" | "Float"}, []):
				macro Random.int(0, 1000);
			case TAbstract(_.get() => {pack: [], name: "Bool"}, []):
				macro Random.bool();
			case TInst(_.get() => {pack: [], name: "String"}, []):
				macro Random.string(100, "abcdefghilmnopqrstuvz1234567890");

			case TInst(_.get() => {pack: [], name: "Array"}, _ => sub): {
					switch (sub) {
						case [TAbstract(_.get() => {pack: [], name: name}, [])]: {
								switch (name) {
									case "Bool": macro [Random.bool()];
									case "Int" | "Float": macro [Random.int(0, 100)];
									case "String": macro [Random.string(100, "abcdefghilmnopqurstuvz1234567890")];
									case _: macro [];
								}
							}
						case [tp]: {
								var path = tp.toString();
								var expr = Context.parseInlineString('Faker.make($path)', Context.currentPos());
								macro [$expr];
							}
						case []: macro [];
						case _: macro [];
					}
				}

			case TAnonymous(_.get() => anon):
				getAnonDefaultValueExpr(anon, pos);
			default:
				throw new Error("Unsupported type for generating default value: " + type.toString(), pos);
		}
		e.pos = pos;
		return e;
	}

	static function getAnonDefaultValueExpr(anon:AnonType, pos:Position, ?fieldInits:Map<String, Expr>):Expr {
		var declFields = [];

		for (field in anon.fields) {
			var fieldValue = null;
			if (fieldInits != null) {
				fieldValue = fieldInits[field.name];
				fieldInits.remove(field.name);
			}

			if (fieldValue == null) {
				if (field.meta.has(":optional"))
					continue;
				fieldValue = getDefaultValueExpr(field.type, pos);
			}
			declFields.push({field: field.name, expr: fieldValue});
		}

		if (fieldInits != null) {
			for (fieldName in fieldInits.keys())
				throw new Error("Unknown field: " + fieldName, fieldInits[fieldName].pos);
		}

		return {expr: EObjectDecl(declFields), pos: pos};
	}
	#end
}
