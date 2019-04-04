package colyseus.server;
import colyseus.server.presence.*;
import colyseus.server.serializer.*;
import js.node.events.EventEmitter;
import js.Promise;

typedef RoomConstructor<T> = Presence->Room<T>;
typedef SimulationCallback = Float->Void;
typedef RoomAvailable = {
	var roomId: String;
	var clients: Int;
	var maxClients: Int;
	@:optional var metadata: Dynamic;
};

typedef BroadcastOptions = {
	@:optional var except: Client;
	@:optional var afterNextPatch: Bool;
};

@:jsRequire("colyseus","Room")
extern class Room<T> extends EventEmitter<Dynamic> {
	var clock: Clock;
	var roomId: String;
	var roomName: String;
	var maxClients: Float;
	var patchRate: Float;
	var autoDispose: Bool;
	var state: T;
	var metadata: Dynamic;
	var presence: Presence;
	var clients: Array<Client>;
	var protected: Dynamic;
	var seatReservationTime: Float;
	var reservedSeats: Array<String>; //perhaps this is wrong as it was Set originally; investigate this
	var reservedSeatTimeouts: Dynamic;
	var reconnections: Dynamic;
	var isDisconnecting: Bool;
	function new(?presence:Presence):Void;
	function onMessage(client:Client, data:Dynamic):Void;
	function onInit(options:Dynamic):Void;
	function onJoin(client:Client, ?options:Dynamic, ?auth:Dynamic):haxe.extern.EitherType<Void, Promise<Dynamic>>;
	function onLeave(client:Client, ?consented:Bool):haxe.extern.EitherType<Void, Promise<Dynamic>>;
	function onDispose():haxe.extern.EitherType<Void, Promise<Dynamic>>;
	function requestJoin(options:Dynamic, ?isNew:Bool):haxe.extern.EitherType<Float, Bool>;
	function onAuth(options:Dynamic):haxe.extern.EitherType<Bool, Promise<Dynamic>>;
	var readonly: Dynamic;
	var locked: Bool;
	function hasReachedMaxClients():Bool;
	function setSeatReservationTime(seconds:Float):Room<T>;
	function hasReservedSeat(sessionId:String):Bool;
	function setSimulationInterval(callback:SimulationCallback, ?delay:Float):Void;
	function setPatchRate(milliseconds:Float):Void;
	function setState(newState:Dynamic):Void;
	function setMetadata(meta:Dynamic):Void;
	function lock():Void;
	function unlock():Void;
	function send(client:Client, data:Dynamic):Void;
	function broadcast(data:Dynamic, ?options:BroadcastOptions):Bool;
	function getAvailableData():Promise<RoomAvailable>;
	function disconnect():Promise<Dynamic>;
	var get_serializer: String;
	function _getSerializer():Serializer<T>;
	function sendState(client:Client):Void;
	function broadcastPatch():Bool;
	function broadcastAfterPatch():Void;
	function allowReconnection(client:Client, ?seconds:Float):Promise<Client>;
	function _reserveSeat(client:Client, ?seconds:Float, ?allowReconnection:Bool):Promise<Bool>;
	function resetAutoDisposeTimeout(timeoutInSeconds:Float):Void;
	function _disposeIfEmpty():Bool;
	function _dispose():Promise<Dynamic>;
}

typedef Clock = Dynamic;
