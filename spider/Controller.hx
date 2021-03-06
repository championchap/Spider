package spider;

import haxe.Json;
import haxe.PosInfos;
import haxe.Template;

import php.Lib;
import php.Web;

import spider.PasswordDetails;
import spider.Spider;

import sys.io.File;

class Controller
{

	private var pageTitle:String = "";
	private var name(get, null):String;
	private var forceSSL(default, set):Bool = false; // for this whole controller

	private var header:Header = new Header();

	public function new() {  }

	/*

		Pages

	*/

	public function doDefault() {
		view({  });
	}


	/*

		Redirects

		Very commonly used redirects that it is expected most applications will make use of.

	*/

	public inline function goHome():Void {
		Spider.url = Spider.config.homeURL;
	}

	public inline function goToLost():Void {
		Spider.url = Spider.config.lostURL;
	}

	public inline function goToLogin():Void {
		Spider.url = Spider.config.loginURL;
	}

	public inline function goToLogout():Void {
		Spider.url = Spider.config.logoutURL;
	}

	public inline function goToError():Void {
		Spider.url = Spider.config.errorURL;
	}


	/*

		Output

		Stuff for spitting out pages and views and stuff.

	*/

	private function drawTemplate(path:String, options:{}):String {
		var s:String = File.getContent(path);
		var t:Template = new Template(s);

		return t.execute( options );
	}

	// draw the current view with these properties
	private function view(obj:{}, ?pos:PosInfos) {
		header.set(Header.contentType, Header.html);

		// figure out the location of the template
		var simpleName = StringTools.replace(name, "controller", "");
		var simpleMethod = firstCharToLower(StringTools.replace(pos.methodName, "do", ""));
		var viewPath = '${Spider.config.viewLocation}${simpleName}/${simpleMethod}.mtt';

		// try to execute the template
		try {
			var view = drawTemplate(viewPath, obj);
			var layout = drawTemplate(Spider.config.layoutLocation, { view : view });

			Lib.print(layout);

		} catch(e:String) {
			Lib.print('No Template found at $viewPath.');
		}
	}

	// output this object as a json file
	private function json(obj:{}) {
		header.set(Header.contentType, Header.json);
		Lib.print(Json.stringify(obj));
	}


	// output this object as an xml file
	private function xml(obj:{}) {
		header.set(Header.contentType, Header.xml);
		// TODO
	}

	// output this object as an atom feed
	private function atom(obj:{}) {
		header.set(Header.contentType, Header.atom);
		// TODO
	}

	// output this object as an rss feed
	private function rss(obj:{}) {
		header.set(Header.contentType, Header.rss);
		// TODO
	}


	/*

		File Handling Stuff

	*/

	// TODO : Should return true on success false on fail
	// should also buffer the file uploads
	private function uploadFile():Bool {
		return false;
	}


	/*

		Useful stuff

	*/

	//
	private function flash() {

	}

	private function isEmpty(s:String):Bool {
		if(s == "" || s == null) {
			return true;
		}

		return false;
	}

	private function isNotEmpty(s:String):Bool {
		if(s == "" || s == null) {
			return false;
		}

		return true;
	}

	public static function firstCharToUpper(text:String):String {
		var output = "";

		output += text.charAt(0).toUpperCase();
		output += text.substr(1);

		return output;
	}

	public static function firstCharToLower(text:String):String {
		var output = "";

		output += text.charAt(0).toLowerCase();
		output += text.substr(1);

		return output;
	}


	/*

		Getters and Setters

	*/

	private function set_forceSSL(ssl:Bool):Bool {
		if(ssl) {
			Spider.makeSecure();
		}

		return ssl;
	}

	private function get_name():String {
		var classParts = Type.getClassName(Type.getClass(this)).split(".");
		return classParts[classParts.length - 1].toLowerCase();
	}
}
