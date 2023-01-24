package;

import haxe.Json;
import flixel.effects.FlxFlicker;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import options.PreferencesOptions;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;
import flixel.util.FlxGradient;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;
	
	var scoreText:FlxText;
	var missesText:FlxText;
	var gdhtsText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;


	public static var lerpScore:Int = 0;
	var lerpMisses:Int = 0;
	var lerpCombo:Int = 0;
	var lerpGD:Int = 0;
	
	var intendedScore:Int = 0;
	var intendedMisses:Int = 0;
	var intendedCombo:Int = 0;
	var intendedGD:Int = 0;

	var bg:FlxSprite;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	var intendedColor:Int;

	var colorTween:FlxTween;
	var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);

	private var iconArray:Array<HealthIconNew> = [];

	var scoreBG:FlxSprite;

	/* option 2
	var freeSongs:Array<Dynamic> = [
		'Tutorial',
		'Bopeebo', 
		'Fresh', 
		'Dadbattle',
		'Spookeez', 
		'South', 
		'Monster',
		'Pico', 
		'Philly', 
		'Blammed',
		'Satin-Panties', 
		'High', 
		'Milf',
		'Cocoa', 
		'Eggnog', 
		'Winter-Horrorland',
		'senpai', 
		'roses', 
		'thorns'
	];

	var freeWeeks:Array<Dynamic> = [
		1,
		1, 
		1, 
		1,
		2, 
		2, 
		2,
		3, 
		3, 
		3,
		4, 
		4, 
		4,
		5, 
		5, 
		5,
		6, 
		6, 
		6
	];

	var freeChar:Array<Dynamic> = [
		'gf',
		'dad', 
		'dad', 
		'dad',
		'spooky', 
		'spooky', 
		'monster',
		'pico', 
		'pico', 
		'pico',
		'mom', 
		'mom', 
		'mom',
		'parents-christmas', 
		'parents-christmas', 
		'monster',
		'senpai', 
		'senpai-angry', 
		'spirit'
	];

	var freeColor:Array<Dynamic> = [
		'0xFFA5004D',
		'0xFFBD7BD3', 
		'0xFFBD7BD3', 
		'0xFFBD7BD3',
		'0xFFdd947f', 
		'0xFFdd947f', 
		'0xFFF2FF6D',
		'0xFFB7D855', 
		'0xFFB7D855', 
		'0xFFB7D855',
		'0xFFD8558E', 
		'0xFFD8558E', 
		'0xFFD8558E',
		'0xFFcb6ab4', 
		'0xFFcb6ab4', 
		'0xFFF2FF6D',
		'0xFFFFAA6F', 
		'0xFFFFAA6F', 
		'0xFFFF3C6E'
	];*/
	override function create()
	{

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
			{
				var data:Array<String> = initSonglist[i].split('|');
				songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1], FlxColor.fromString(data[3])));

			if (data[3] == null)
				{
				data == ['0xFFFFFFFF'];
				}
			}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end
		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = PreferencesOptions.Antialiasing;
		add(bg);

		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x55FFBDF8, 0xAAFFFDF3], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (20 * i) + 30, songs[i].songName, true, false);
			songText.freePlayStyle = false;
			songText.x += 200;
			songText.isMenuItem = true;
			songText.targetY = i;
			songText.forceX = songText.x;
			grpSongs.add(songText);

			var icon:HealthIconNew = new HealthIconNew(songs[i].songCharacter, false);
			icon.sprTracker = songText;
icon.antialiasing = PreferencesOptions.Antialiasing;
			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		// scoreText.alignment = RIGHT;
		scoreText.borderSize = 2.6;

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 170, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		missesText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		missesText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missesText.borderSize = 2.6;
		add(missesText);

		gdhtsText = new FlxText(scoreText.x, scoreText.y + 65, 0, "", 24);
		gdhtsText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		gdhtsText.borderSize = 2.6;
		add(gdhtsText);

		comboText = new FlxText(scoreText.x, scoreText.y + 95, 0, "", 24);
		comboText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		comboText.borderSize = 2.6;
		add(comboText);

		diffText = new FlxText(scoreText.x + 135, scoreText.y + 135, 0, "", 24);
		diffText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		diffText.borderSize = 2.6;
		add(diffText);

		add(scoreText);

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		var leText:String = "Press TAB to see the ratings you got on the song";
		var size:Int = 18;

		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.borderSize = 1;
		text.scrollFactor.set();
		add(text);
		super.create();

		changeSelection();
		changeDiff();

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */
		
		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, songColor:Int = 0xFFffffff)
		{
			songs.push(new SongMetadata(songName, weekNum, songCharacter, songColor));
		}
	
	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, colorSong:Int = 0xFFffffff)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		var color:Int = 0xFFffffff;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num], colorSong);

			if (songCharacters.length != 1)
				num++;
		}
		}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var songSHIT:String = '';

		var diffSHIT:Int = 0;

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));
		lerpMisses = Math.floor(FlxMath.lerp(lerpMisses, intendedMisses, 0.4));
		lerpCombo = Math.floor(FlxMath.lerp(lerpCombo, intendedCombo, 0.4));
		lerpGD = Math.floor(FlxMath.lerp(lerpGD, intendedGD, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		if (Math.abs(lerpMisses - intendedMisses) <= 10)
			lerpMisses = intendedMisses;

		if (Math.abs(lerpCombo - intendedCombo) <= 10)
			lerpCombo = intendedCombo;

		if (Math.abs(lerpGD - intendedGD) <= 10)
			lerpGD = intendedGD;

		//uva
		scoreText.text = "PERSONAL BEST:" + lerpScore;
		missesText.text = "Misses: " + lerpMisses;
		gdhtsText.text = "GoodHits: " + lerpGD;
		comboText.text = "Combo: " + lerpCombo + '%';

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (FlxG.mouse.wheel != 0)
			changeSelection(curSelected -= (FlxG.mouse.wheel * 1));

songSHIT = songs[curSelected].songName;
diffSHIT = curDifficulty;

		if (FlxG.keys.justPressed.TAB)
			{
				#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at their Ratings", null);
		#end
			openSubState(new RatingsSubState(songSHIT, diffSHIT));
			}

		if (controls.BACK)
		{
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
			nextState(new MainMenuState());

			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if (accepted)
		{
			FlxG.sound.music.fadeOut(1, 0);
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();

			FlxG.sound.play(Paths.sound('confirmMenu'));

					new FlxTimer().start(1, function(tmr:FlxTimer)
						{
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
	
				//trace(poop);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
	
				PlayState.storyWeek = songs[curSelected].week;
				//trace('CUR WEEK' + PlayState.storyWeek);
				loadAndSwitchState(new PlayState()); });
	}
}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;
		
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedMisses = Highscore.getMisses(songs[curSelected].songName, curDifficulty);
		intendedCombo = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		intendedGD = Highscore.getHits(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = ' <${CoolUtil.difficultyArray[0]}> ';
			case 1:
				diffText.text = '<${CoolUtil.difficultyArray[1]}>';
			case 2:
				diffText.text = ' <${CoolUtil.difficultyArray[2]}> ';
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 1);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

switch (curSelected)
		{
		 default:
			var newColor:Int = songs[curSelected].weekColor;
            if (newColor != intendedColor)
				{
					if (colorTween != null)
					{
						colorTween.cancel();
					}
					intendedColor = newColor;
			colorTween = FlxTween.color(bg, 0.5, bg.color, songs[curSelected].weekColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}
		}

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedMisses = Highscore.getMisses(songs[curSelected].songName, curDifficulty);
		intendedCombo = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		intendedGD = Highscore.getHits(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.45;
			iconArray[i].scale.set(0.76, 0.76);
		}

		iconArray[curSelected].scale.set(1, 1);
		iconArray[curSelected].alpha = 1;
		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;
			// item.setGraphicSize(Std.int(item.width * 0.8));
			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var weekColor:Int = 0xFFffffff;

	public function new(song:String, week:Int, songCharacter:String, weekColor:Int = 0xFFffffff)
	{
		this.songName = song;
		this.week = week;
		this.weekColor = weekColor;
		this.songCharacter = songCharacter;
	}
}
