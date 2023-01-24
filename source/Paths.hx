package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;
	static var lib = '';
    static public var creditsStuff:Array<Dynamic> = 
	[ 
	[
	'AmsDev', // name|icon
	'Main Programmer', // work
	'are you sure you re\nnot gay?\nprove otherwise lol\npls suscribe to my\nchannel XD', // sentence
	'#727FB3', // color
	'https://www.youtube.com/channel/UCLiN7NfSI61E7Fm6g-isUGA' // link
	],
	[
    'MrNiz',
	'Extra Programmer',
	'Pixel Transition\nCoder',
	'#FFFFFF',
	'https://twitter.com/MrNizy'
	],
	[
	'AngelUchiha', 
	'Voice Actor', 
	'If you feel so dumb\nthink about me, you\nwill feel better',
	'#2C2624',
	'https://twitter.com/AngelUchihaaa'
	],
	[
	'AssmanBruh!',
	'Main Artist',
	'Hi bro im assman\nPlaza good',
	'#FFFFFF',
	'https://www.youtube.com/@assmanbruh7030'
	],
	[
	'AndyGamer',
	'Icon Artist',
	'AMONGUS!!?? WERE!!',
	'#2D2C2A',
	'https://twitter.com/AndyGamer1116YT'
	],
	[
	'DrawPant',
	'Extra Animator',
	'hi guys im sas,\nplay friday night\nrayman mod',
	'#FF33FF',
	'https://twitter.com/DrawPant'
	],
	[
	'HiroBerserk',
	'App Icon Artist',
	'Tmr pe\n(Im peruvian XD)',
	'#3B93C6',
	'https://twitter.com/berserk_hiro?t=IGJ8m9FVHz-ugqw1aYsRJA&s=09'
	],
	[
	'Bit',
	'Ratings Artist',
	'I am the least fan\nand burn Paraguay',
	'#FFFFFF',
	'https://twitter.com/Kasler_dumb'
	]
    ];

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function dialogues(key:String)
		{
			return lib = 'assets/data/dialogues/$key.txt';
		}

		inline static public function video(?library:String, key:String)
			{
				return lib = 'assets/videos/$library/$key.mp4';
			}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function stuff(key:String)
		{
			return 'assets/engineThings/$key';
		}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}
}
