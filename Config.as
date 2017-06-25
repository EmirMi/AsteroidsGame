package
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.XMLSocket;
	import flash.net.URLRequest;

	public class Config
	{
		public var urlLoader: URLLoader;
		public var pathToXMLFile: String = "assets/config.xml";
		public var xmlData: XML;
		public var _maxBullets:int;
		public var _maxMissiles:int;
		public var _timebShot:int;
		public var _timeMissiles:int;
		public var _timeTeleports:int;

		public function Config()
		{
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onXMLLoaded);
			urlLoader.load(new URLRequest(pathToXMLFile));
		}
		
		public function onXMLLoaded(e:Event):void
		{
			xmlData = new XML(e.target.data);
			_maxBullets = xmlData.config.node.(@id == "maxBullets");
			_maxMissiles = xmlData.config.node.(@id == "maxMissiles");
			_timebShot = xmlData.config.node.(@id == "timeshot");
			_timeMissiles = xmlData.config.node.(@id == "timemissiles");
			_timeTeleports = xmlData.config.node.(@id == "timeteleport");
		}

	}
}