package;

import haxe.rtti.CType.Abstractdef;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxRandom;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import options.PreferencesOptions;
import Song.SwagSong;
import lime.app.Application;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var isPixelStage:Bool = false;
	public static var storyDifficulty:Int = 1;
	var boxUp:FlxSprite;
	var boxDown:FlxSprite;
	var sick:Int = 0;
	var good:Int = 0;
	var bad:Int = 0;
	var shit:Int = 0;
	
	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;
	public var botplaySine:Float = 0;

	public static var dad:Character;
	private var gf:Character;
	public static var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];
	private var enemyStrums:FlxTypedGroup<StaticStrums>;

	/*private var mustHitSection:Bool = false;
	private var charCam:Array<Float> = [0,0,0,0];
	public var scrollFactor:Int = 35;
	private var positions:Array<Float> = [0,0];*/

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;
	private static var prevCamFollow:FlxObject;

	public var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var hudGroup:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<StaticStrums>;

	public static var instance:PlayState = null;
	
	private var camZooming:Bool = false;
	public var curSong:String = "";
	var rating:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
    static public var monsterAss_sets:String = '';

	var doof:DialogueBox;

	/**
	  * animation data or direction idk
	**/
	var singArray:Array<String> = ["singLEFT", "singDOWN", "singUP", "singRIGHT"];

	var healthTxt:FlxText;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	public var timeBarBG:FlxSprite;
	public var timeBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIconNew;
	private var iconP2:HealthIconNew;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var offsets:FlxSprite;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	public var ratingPercent:Float;

	var bgGirls:BackgroundGirls;

	var comboPercentaje:Int = 0;
	var talking:Bool = true;
	var missesCounter:Int = 0;
	var goodHitsCounter:Int = 0;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	var comboBreaks:Int = 0;
	var ratingABCD:String = 'NONE';
	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	var start:Bool = false;

	public static var iconRotate:Bool = false;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;
	var musicTime:Float = 0;

	var inCutscene:Bool = false;
	var rosesEventTrail:FlxTrail;
	var musicTimeInfo:FlxText;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end
	var songLength:Float = 0;
	var sineInOut(default, null):Null<EaseFunction>;

	var data:Dynamic;

	var bfTrail:FlxSprite;
	var dadTrail:FlxSprite;

	override public function create()
	{
		instance = this;

		if (curSong.startsWith('school'))
			isPixelStage = true;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		Application.current.window.title = "Friday Night Funkin' Simple Engine" + ' | ${SONG.song}: ${CoolUtil.difficultyString()}';

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		#if desktop
		FlxCamera.defaultCameras = [camGame];
		#end

		FlxG.autoPause = false;
		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		var sploosh = new NoteSplash(100, 100, 0);
		sploosh.alpha = 0.1;
		if (PreferencesOptions.NoteSplash)grpNoteSplashes.add(sploosh);

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.dialogues('senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.dialogues('rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.dialogues('thornsDialogue'));
			case 'tutorial':
				dialogue = CoolUtil.coolTextFile(Paths.dialogues('tutorialDialogue'));
		}

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + ' ' + SONG.song + " (" + storyDifficultyText + ') ', 'Score: ${songScore} | Rating: ${rating} | Misses: ${missesCounter} | GoodHts: ${goodHitsCounter} | Combo: ${comboPercentaje}', iconRPC);
		#end

		switch (SONG.song.toLowerCase())
		{
                        case 'spookeez' | 'monster' | 'south': 
                        {
                                curStage = 'spooky';
	                          halloweenLevel = true;

		                  var hallowTex = Paths.getSparrowAtlas('halloween_bg');

	                          halloweenBG = new FlxSprite(-200, -85);
		                  halloweenBG.frames = hallowTex;
	                          halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
	                          halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
	                          halloweenBG.animation.play('idle');
	                          halloweenBG.antialiasing = PreferencesOptions.Antialiasing;
	                          add(halloweenBG);

		                  isHalloween = true;
		          }
		          case 'pico' | 'blammed' | 'philly': 
                        {
		                  curStage = 'philly';

		                  var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
		                  bg.scrollFactor.set(0.8, 0.8);
		                  add(bg);

	                          var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
		                  city.scrollFactor.set(0.3, 0.3);
		                  city.setGraphicSize(Std.int(city.width * 0.85));
		                  city.updateHitbox();
		                  add(city);

		                  phillyCityLights = new FlxTypedGroup<FlxSprite>();
		                  add(phillyCityLights);

		                  for (i in 0...5)
		                  {
		                          var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
		                          light.scrollFactor.set(0.3, 0.3);
		                          light.visible = false;
		                          light.setGraphicSize(Std.int(light.width * 0.85));
		                          light.updateHitbox();
		                          light.antialiasing = PreferencesOptions.Antialiasing;
		                          phillyCityLights.add(light);
		                  }

		                  var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
		                  add(streetBehind);

	                          phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
		                  add(phillyTrain);

		                  trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
		                  FlxG.sound.list.add(trainSound);

		                  // var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

		                  var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
	                          add(street);
		          }
		          case 'milf' | 'satin-panties' | 'high':
		          {
		                  curStage = 'limo';
		                  defaultCamZoom = 0.90;

		                  var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
		                  skyBG.scrollFactor.set(0.1, 0.1);
		                  add(skyBG);

		                  var bgLimo:FlxSprite = new FlxSprite(-200, 480);
		                  bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
		                  bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
		                  bgLimo.animation.play('drive');
		                  bgLimo.scrollFactor.set(0.4, 0.4);
		                  add(bgLimo);

		                  grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
		                  add(grpLimoDancers);

		                  for (i in 0...5)
		                  {
		                          var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
		                          dancer.scrollFactor.set(0.4, 0.4);
		                          grpLimoDancers.add(dancer);
		                  }

		                  var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
		                  overlayShit.alpha = 0.5;

		                  var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

		                  limo = new FlxSprite(-120, 550);
		                  limo.frames = limoTex;
		                  limo.animation.addByPrefix('drive', "Limo stage", 24);
		                  limo.animation.play('drive');
		                  limo.antialiasing = PreferencesOptions.Antialiasing;

		                  fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
		                  // add(limo);

		          }
		          case 'cocoa' | 'eggnog':
		          {
	                          curStage = 'mall';

		                  defaultCamZoom = 0.80;

		                  var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
		                  bg.antialiasing = PreferencesOptions.Antialiasing;
		                  bg.scrollFactor.set(0.2, 0.2);
		                  bg.active = false;
		                  bg.setGraphicSize(Std.int(bg.width * 0.8));
		                  bg.updateHitbox();
		                  add(bg);

		                  upperBoppers = new FlxSprite(-240, -90);
		                  upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
		                  upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
		                  upperBoppers.antialiasing = PreferencesOptions.Antialiasing;
		                  upperBoppers.scrollFactor.set(0.33, 0.33);
		                  upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
		                  upperBoppers.updateHitbox();
		                  add(upperBoppers);

		                  var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
		                  bgEscalator.antialiasing = PreferencesOptions.Antialiasing;
		                  bgEscalator.scrollFactor.set(0.3, 0.3);
		                  bgEscalator.active = false;
		                  bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
		                  bgEscalator.updateHitbox();
		                  add(bgEscalator);

		                  var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
		                  tree.antialiasing = PreferencesOptions.Antialiasing;
		                  tree.scrollFactor.set(0.40, 0.40);
		                  add(tree);

		                  bottomBoppers = new FlxSprite(-300, 140);
		                  bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
		                  bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
		                  bottomBoppers.antialiasing = PreferencesOptions.Antialiasing;
	                          bottomBoppers.scrollFactor.set(0.9, 0.9);
	                          bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
		                  bottomBoppers.updateHitbox();
		                  add(bottomBoppers);

		                  var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
		                  fgSnow.active = false;
		                  fgSnow.antialiasing = PreferencesOptions.Antialiasing;
		                  add(fgSnow);

		                  santa = new FlxSprite(-840, 150);
		                  santa.frames = Paths.getSparrowAtlas('christmas/santa');
		                  santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
		                  santa.antialiasing = PreferencesOptions.Antialiasing;
		                  add(santa);

		          }
		          case 'winter-horrorland':
		          {
		                  curStage = 'mallEvil';
		                  var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
		                  bg.antialiasing = PreferencesOptions.Antialiasing;
		                  bg.scrollFactor.set(0.2, 0.2);
		                  bg.active = false;
		                  bg.setGraphicSize(Std.int(bg.width * 0.8));
		                  bg.updateHitbox();
		                  add(bg);

		                  var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
		                  evilTree.antialiasing = PreferencesOptions.Antialiasing;
		                  evilTree.scrollFactor.set(0.2, 0.2);
		                  add(evilTree);

		                  var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
	                          evilSnow.antialiasing = PreferencesOptions.Antialiasing;
		                  add(evilSnow);
                        }
		          case 'senpai' | 'roses':
		          {
		                  curStage = 'school';
						  isPixelStage = true;
		                  // defaultCamZoom = 0.9;

		                  var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
		                  bgSky.scrollFactor.set(0.1, 0.1);
		                  add(bgSky);

		                  var repositionShit = -200;

		                  var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
		                  bgSchool.scrollFactor.set(0.6, 0.90);
						  bgSchool.antialiasing = PreferencesOptions.Antialiasing;
		                  add(bgSchool);

		                  var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
		                  bgStreet.scrollFactor.set(0.95, 0.95);
		                  add(bgStreet);

		                  var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
		                  fgTrees.scrollFactor.set(0.9, 0.9);
						  fgTrees.antialiasing = PreferencesOptions.Antialiasing;
		                  add(fgTrees);

		                  var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
		                  var treetex = Paths.getPackerAtlas('weeb/weebTrees');
		                  bgTrees.frames = treetex;
		                  bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
		                  bgTrees.animation.play('treeLoop');
		                  bgTrees.scrollFactor.set(0.85, 0.85);
						  bgTrees.antialiasing = PreferencesOptions.Antialiasing;
		                  add(bgTrees);

		                  var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
		                  treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
		                  treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
		                  treeLeaves.animation.play('leaves');
		                  treeLeaves.scrollFactor.set(0.85, 0.85);
						  treeLeaves.antialiasing = PreferencesOptions.Antialiasing;
		                  add(treeLeaves);

		                  var widShit = Std.int(bgSky.width * 6);

		                  bgSky.setGraphicSize(widShit);
		                  bgSchool.setGraphicSize(widShit);
		                  bgStreet.setGraphicSize(widShit);
		                  bgTrees.setGraphicSize(Std.int(widShit * 1.4));
		                  fgTrees.setGraphicSize(Std.int(widShit * 0.8));
		                  treeLeaves.setGraphicSize(widShit);

		                  fgTrees.updateHitbox();
		                  bgSky.updateHitbox();
		                  bgSchool.updateHitbox();
		                  bgStreet.updateHitbox();
		                  bgTrees.updateHitbox();
		                  treeLeaves.updateHitbox();

		                  bgGirls = new BackgroundGirls(-100, 190);
		                  bgGirls.scrollFactor.set(0.9, 0.9);
						  bgGirls.antialiasing = PreferencesOptions.Antialiasing;

		                  if (SONG.song.toLowerCase() == 'roses')
	                          {
		                          bgGirls.getScared();
		                  }

		                  bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
		                  bgGirls.updateHitbox();
		                  add(bgGirls);

		          }
		          case 'thorns':
		          {
		                  curStage = 'schoolEvil';
						  isPixelStage = true;

		                  var posX = 400;
	                          var posY = 250;

		                  var bg:FlxSprite = new FlxSprite(posX, posY);
		                  bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
		                  bg.animation.addByPrefix('idle', 'background 2', 24);
		                  bg.animation.play('idle');
		                  bg.scrollFactor.set(0.8, 0.9);
		                  bg.scale.set(6, 6);
		                  add(bg);

		          }
		          default:
		          {
		                  defaultCamZoom = 0.9;
		                  curStage = 'stage';
		                  var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
		                  bg.antialiasing = PreferencesOptions.Antialiasing;
		                  bg.scrollFactor.set(0.9, 0.9);
		                  bg.active = false;
		                  add(bg);

		                  var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
		                  stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		                  stageFront.updateHitbox();
		                  stageFront.antialiasing = PreferencesOptions.Antialiasing;
		                  stageFront.scrollFactor.set(0.9, 0.9);
		                  stageFront.active = false;
		                  add(stageFront);

		                  var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
		                  stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		                  stageCurtains.updateHitbox();
		                  stageCurtains.antialiasing = PreferencesOptions.Antialiasing;
		                  stageCurtains.scrollFactor.set(1.3, 1.3);
		                  stageCurtains.active = false;

		                  add(stageCurtains);
		          }
              }

			  var gfVersion:String = SONG.gfVersion;
				  switch (SONG.gfVersion)
				  {
					  case 'gf-car':
						  gfVersion = 'gf-car';
					  case 'gf-christmas':
						  gfVersion = 'gf-christmas';
					  case 'gf-pixel':
						  gfVersion = 'gf-pixel';
					  case 'gf':
						  gfVersion = 'gf';
				  }

		monsterAss_sets = 'Monster_Assets';
	if (curStage.startsWith('mall'))
		monsterAss_sets = 'christmas/monsterChristmas';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);
		gf.antialiasing = PreferencesOptions.Antialiasing;

		dad = new Character(100, 100, SONG.player2);
		dad.antialiasing = PreferencesOptions.Antialiasing;

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);
		boyfriend.antialiasing = PreferencesOptions.Antialiasing;

		dadTrail = new FlxSprite();
		dadTrail.visible = false;
		dadTrail.antialiasing = true;
		// dadGhost.scale.copyFrom(dad.scale);
		dadTrail.updateHitbox();
		add(dadTrail);

		bfTrail = new FlxSprite();
		bfTrail.visible = false;
		bfTrail.antialiasing = true;
		// bfGhost.scale.copyFrom(boyfriend.scale);
		bfTrail.updateHitbox();
		add(bfTrail);

		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}
add(gf);
		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		add(boyfriend);

		doof = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
//abcdefghijklmn
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (PreferencesOptions.MiddleScroll)
			strumLine.x -= 320;
		if (PreferencesOptions.DownScroll)
			strumLine.y = FlxG.height - 150;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		if (PreferencesOptions.NoteSplash)add(grpNoteSplashes);

		hudGroup = new FlxTypedGroup<FlxSprite>();
		add(hudGroup);

		playerStrums = new FlxTypedGroup<StaticStrums>();
		enemyStrums = new FlxTypedGroup<StaticStrums>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		if (gf != null)
camFollow.setPosition(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y);

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		// timeBar

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();

		if (PreferencesOptions.DownScroll)
			healthBarBG.y = 50;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(dad.iconColor, boyfriend.iconColor);
		// healthBar

		iconP1 = new HealthIconNew(boyfriend.icon, true);
		iconP1.y = healthBar.y - (iconP1.height / 2) - 10;

		iconP2 = new HealthIconNew(dad.icon, false);
		iconP2.y = healthBar.y - (iconP2.height / 2) - 10;
		

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 30, 0, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.92;
		scoreTxt.alpha = 0.87;

		healthTxt = new FlxText(healthBarBG.x, healthBarBG.y - 5, 0, '', 24);
		healthTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		healthTxt.scrollFactor.set();
		healthTxt.borderSize = 2.6;
		healthTxt.alpha = 0.6;

		musicTimeInfo = new FlxText(0, 10, 0, '', 26);
		musicTimeInfo.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		musicTimeInfo.scrollFactor.set();
		musicTimeInfo.borderSize = 2;
		musicTimeInfo.alpha = 0;
		// if (PreferencesOptions.DownScroll)
		// musicTimeInfo.y = FlxG.height - 35;

		FlxTween.tween(musicTimeInfo, {alpha: 1},2 ,{ease: FlxEase.circOut, startDelay: 2.5});
		
		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (isPixelStage)
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'tutorial':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if(PreferencesOptions.HideHud)
			{
				scoreTxt.visible = false;
				musicTimeInfo.visible = false;
				hudGroup.visible = false;
			}
hudGroup.add(healthBarBG);
hudGroup.add(healthBar);

hudGroup.add(iconP2);
hudGroup.add(iconP1);

hudGroup.add(healthTxt);

add(scoreTxt);
add(musicTimeInfo);

		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		healthTxt.cameras = [camHUD];
		iconP1.cameras = [camHUD]; // xd
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		musicTimeInfo.cameras = [camHUD];
		strumLineNotes.cameras = [camHUD];
		doof.cameras = [camHUD];
		start = false;

			boxUp = new FlxSprite(0, -120);
					boxUp.makeGraphic(FlxG.width, 120, FlxColor.BLACK);
		add(boxUp);
		
		boxDown = new FlxSprite(0, 720);
					boxDown.makeGraphic(FlxG.width, 120, FlxColor.BLACK);
		add(boxDown);

		boxUp.cameras = [camHUD];
		boxDown.cameras = [camHUD];

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;
		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();

					if (isPixelStage)
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 0, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					ready.cameras = [camHUD];

					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (isPixelStage)
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 0, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});

					set.cameras = [camHUD];

					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (isPixelStage)
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();

					add(go);
					FlxTween.tween(go, {y: go.y += 0, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
							gf.dance();

			boyfriend.playAnim('idle');
		dad.dance();
			start = true;
						}
					});

					go.cameras = [camHUD];

					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);

					if (SONG.player1 == 'bf')
					{gf.playAnim('cheer');
			        boyfriend.playAnim('hey');}
				case 4:
			}

			swagCounter += 1;
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		timeBarBG = new FlxSprite(0, 15).loadGraphic(Paths.image('healthBar'));
		timeBarBG.screenCenter(X);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.scale.set(2.2, 1.3);
		// timeBarBG.updateHitbox();
		timeBarBG.cameras = [camHUD];

		// if (PreferencesOptions.DownScroll)
		// 	timeBarBG.y = 50;

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, RIGHT_TO_LEFT, Std.int(timeBarBG.scale.x - 0.8), Std.int(timeBarBG.height), this,
			'musicTime', 0, songLength - 1000);
		timeBar.scrollFactor.set();
		timeBar.alpha = 0;
		timeBar.numDivisions = 1000; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
		timeBar.createFilledBar(dad.iconColor, FlxColor.BLACK);
		timeBar.cameras = [camHUD];

		FlxTween.tween(timeBar, {alpha: 1},2 ,{ease: FlxEase.circOut, startDelay: 2.5});
		FlxTween.tween(timeBarBG, {alpha: 1},2 ,{ease: FlxEase.circOut, startDelay: 2.5});

		if (PreferencesOptions.TimeBar)
			{
		hudGroup.add(timeBar);
		hudGroup.add(timeBarBG);
			}

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + ' ' + SONG.song + " (" + storyDifficultyText + ') ', '', iconRPC, true, songLength);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
				{
					var daStrumTime:Float = songNotes[0];
					var daNoteData:Int = Std.int(songNotes[1] % 4);
	
					var gottaHitNote:Bool = section.mustHitSection;
	
					if (songNotes[1] > 3)
					{
						gottaHitNote = !section.mustHitSection;
					}
	
					var oldNote:Note;
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;
	
					var swagNote:Note;
				    swagNote = new Note(daStrumTime, daNoteData, oldNote);
					swagNote.sustainLength = songNotes[2];
					swagNote.scrollFactor.set(0, 0);
	                swagNote.x += strumLine.x + 45;
					var myArrosGuddy:Array <Note> = [];
					var fist = unspawnNotes[0];

					if (fist != null){
					for (k in unspawnNotes){
						if (k.strumTime == fist.strumTime) 
							myArrosGuddy.push(k);
							var animToPlay = singArray[Std.int(Math.abs(swagNote.noteData))];
							doTrailGhostAnim("dad", animToPlay);
						}
					}
				
					if (PreferencesOptions.MiddleScroll)
						swagNote.x -= 215; 
	
					var susLength:Float = swagNote.sustainLength;
	
					susLength = susLength / Conductor.stepCrochet;
					unspawnNotes.push(swagNote);
	
					for (susNote in 0...Math.floor(susLength))
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
	
						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);
	
							sustainNote.x = swagNote.x + 36;
						if (isPixelStage)
							sustainNote.x = swagNote.x + 33;
	
						sustainNote.mustPress = gottaHitNote;
	
						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset

							if (PreferencesOptions.MiddleScroll)
								sustainNote.x += 214;
						}
					}
	
					swagNote.mustPress = gottaHitNote;
	
					if (swagNote.mustPress)
					{
						swagNote.x += FlxG.width / 2; // general offset

						if (PreferencesOptions.MiddleScroll)
						swagNote.x += 215;
	
							/*if (curBeat % 4 == 1 && curSong == 'Fresh' && curBeat > 30)
								{
									swagNote.angle = 20;
								}*/
					}
					else {}
				}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:StaticStrums;
			babyArrow = new StaticStrums(45 + strumLine.x, strumLine.y, 'NOTE_assets', i, player);

			babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();

				babyArrow.y += 150;
				babyArrow.alpha = 0;

				if (isPixelStage)
					{
					FlxTween.tween(babyArrow, {y: babyArrow.y - 150, alpha: 0.85, 'scale.x': 6, 'scale.y': 6}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.3 * i)});
					babyArrow.scale.set(3.4, 3.4);
				}
			else
				{
					babyArrow.scale.set(0.4, 0.4);
					FlxTween.tween(babyArrow, {y: babyArrow.y - 150, alpha: 0.85, 'scale.x': 0.7, 'scale.y': 0.7}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
				}

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				enemyStrums.add(babyArrow);

				if (PreferencesOptions.MiddleScroll){
					babyArrow.scale.set(0.5, 0.5);
					babyArrow.alpha = 0.5;
				}
			}

			enemyStrums.forEach(function(spr:StaticStrums)
				{					
					spr.centerOffsets(); 
				});

				babyArrow.setPositionStatic();
	
				strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: sineInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			camHUD.color = FlxColor.WHITE;

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + ' ' + SONG.song + " (" + storyDifficultyText + ') ', '', iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText + ' ' + SONG.song + " (" + storyDifficultyText + ') ', '', iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText + ' ' + SONG.song + " (" + storyDifficultyText + ') ', '', iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText + ' ' + SONG.song + " (" + storyDifficultyText + ') ', '', iconRPC);
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsText + ' ' + SONG.song + " (" + storyDifficultyText + ') ', '', iconRPC);
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	//uva
	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		var curTime:Float = Conductor.songPosition;
                if (curTime < 0)
                    curTime = 0;
                musicTime = (curTime / songLength) + Conductor.songPosition;
                var secondsTotal:Int = Math.floor((songLength - curTime) / 1000);
                if (secondsTotal < 0)
                    secondsTotal = 0;

                musicTimeInfo.text = "- [" + FlxStringUtil.formatTime(secondsTotal, false) + "] -";
				musicTimeInfo.screenCenter(X);

		if (PreferencesOptions.AutoPlay)
		{if(scoreTxt.visible) {
			botplaySine += 180 * elapsed;
			scoreTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		if (isPixelStage)
			{
				dad.antialiasing = false;
				boyfriend.antialiasing = false;
				gf.antialiasing = false;
			}

		healthTxt.text = '${healthBar.percent}%';
		healthTxt.screenCenter(X);

		scoreTxt.text = 'Score: ${songScore} - Combo: ${comboPercentaje}% - Misses: ${missesCounter} | GoodHits: ${goodHitsCounter} - Rating: ${rating}';
		if (PreferencesOptions.AutoPlay)
			scoreTxt.text = '[AUTO-PLAY]';
		scoreTxt.screenCenter(X);

		if (healthBar.percent > 21) healthTxt.color = FlxColor.WHITE;
		else if (healthBar.percent > 20) healthTxt.color = FlxColor.RED;

		if (comboPercentaje > 100) comboPercentaje = 100;

		if (songScore == 0) rating = "?"; 

		if (goodHitsCounter == 0) rating = "GFC"; 

		if (missesCounter == 1) rating = "FC"; 
 
		 if (missesCounter > 5) rating = "S";
 
		 if (missesCounter > 6) rating = "A";
 
		 if (missesCounter > 19) rating = "B";
 
		 if (missesCounter > 29) rating = "C";
 
		 if (missesCounter > 49) rating = "D";
 
		 if (missesCounter > 99) rating = "F";
 
		 if (missesCounter > 199) rating = "HOW";

		 if (FlxG.keys.justPressed.ALT)
			nextState(new AnimationDebug(SONG.player2));

		if (controls.PAUSE && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
			#if desktop
			DiscordClient.changePresence('Pause Menu ' + SONG.song + " (" + storyDifficultyText + ') ', '', iconRPC);
			#end
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			nextState(new ChartingState());

			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		if (PreferencesOptions.AutoPlay && FlxG.keys.justPressed.ONE)
			{
			  hudGroup.visible = !hudGroup.visible;
			}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP1.scale.set(mult, mult);
		iconP1.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP2.scale.set(mult, mult);
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 21)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;


		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				var characterCameraPosition = dad.curCharacter;
				// cam position
				switch (characterCameraPosition)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai' | 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'pico':
						camFollow.y = dad.getMidpoint().y - 30;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial' || SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
				{
					tweenCamIn();
				}

			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}


		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Dadbattle')
			{
				switch (curBeat)
				{
					case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				}
			}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			interpolateHealth(1);
			trace("User is cheating!");
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			
			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText + ' ' + SONG.song + " (" + storyDifficultyText + ') ', '', iconRPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
				// i am so fucking sorry for this if condition
				if (daNote.isSustainNote
					&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
					swagRect.y /= daNote.scale.y;
					swagRect.height -= swagRect.y;

					daNote.clipRect = swagRect;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					switch (Math.abs(daNote.noteData))
					{
						case 0:
							dad.playAnim('singLEFT' + altAnim, true);
						case 1:
							dad.playAnim('singDOWN' + altAnim, true);
						case 2:
							dad.playAnim('singUP' + altAnim, true);
						case 3:
							dad.playAnim('singRIGHT' + altAnim, true);
					}

					if (SONG.enemyDrainsHealth == true)
						{
						if (Math.abs(daNote.noteData) < 4)
							{
								if (health >= 0.15)
									interpolateHealth(-0.023);
							}
					}

					enemyStrums.forEach(function(spr:StaticStrums)
						{
							if (Math.abs(daNote.noteData)== spr.ID)
								{
									spr.playAnim('confirm', true);


									spr.centerOffsets();

									if (!isPixelStage)
										{
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										}
								}
						});

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				if (PreferencesOptions.DownScroll)
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed, 2))) - 15; // fixed the freaking downscroll
				else
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2))) + 5;

				if ((daNote.y < -daNote.height && !PreferencesOptions.DownScroll || daNote.y >= strumLine.y + 106 && PreferencesOptions.DownScroll) && daNote.mustPress)
				{
					if (daNote.isSustainNote)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					else if (!daNote.isSustainNote)
					{
						interpolateHealth(-0.023);
						missesCounter += 1;
						vocals.volume = 0;
						comboPercentaje = 0;
			combo = 0;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			
			switch (Math.abs(daNote.noteData))
								{
									case 0:
										boyfriend.playAnim('singLEFTmiss', true);
									case 1:
										boyfriend.playAnim('singDOWNmiss', true);
									case 2:
										boyfriend.playAnim('singUPmiss', true);
									case 3:
										boyfriend.playAnim('singRIGHTmiss', true);
								}
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
		enemyStrums.forEach(function(spr:FlxSprite)
            {
                if (spr.animation.curAnim.finished){
					spr.animation.play('static', true);
					spr.centerOffsets();
				}
			});

		if (!inCutscene){
			keyShit();
		}

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	public function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			if (PreferencesOptions.AutoPlay == false)
	{	
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			Highscore.saveMiss(SONG.song, missesCounter, storyDifficulty);
			Highscore.saveRating(SONG.song, comboPercentaje, storyDifficulty);
			Highscore.saveHits(SONG.song, goodHitsCounter, storyDifficulty);


			Highscore.saveSicks(SONG.song, sick, storyDifficulty);
			Highscore.saveGoods(SONG.song, good, storyDifficulty);
			Highscore.saveBads(SONG.song, bad, storyDifficulty);
			Highscore.saveShits(SONG.song, shit, storyDifficulty);
			#end
	}
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				nextState(new MainMenuState());

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				nextState(new PlayState());
			}
		}
		else
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			nextState(new MainMenuState());
		}
	}

	var endingSong:Bool = false;
	var note:Note;

	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		comboPercentaje += 1;

		if(PreferencesOptions.HitSound)
				FlxG.sound.play(Paths.sound('hit'), PreferencesOptions.HitSoundVolume);

		var coolText:FlxText = new FlxText(0, 0, 0, 'COMBO', 40);

		coolText.y = healthBarBG.y - 75;
		if (PreferencesOptions.DownScroll)
		coolText.y = healthBarBG.y + 75;
		coolText.setFormat(Paths.font('vcr.ttf'), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		coolText.borderSize = 3.4;

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			daRating = 'shit';
			shit += 1;
			score = 50;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'bad';
			bad += 1;
			score = 100;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			daRating = 'good';
			good += 1;
			score = 200;

			goodHitsCounter += 1;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.0)
		{
			daRating = 'sick';
			sick += 1;
			score = 250;
			var recycledNote = grpNoteSplashes.recycle(NoteSplash);
			recycledNote.setupNoteSplash(note.x, note.y, note.noteData);
			if (PreferencesOptions.NoteSplash)grpNoteSplashes.add(recycledNote);

			goodHitsCounter += 1;
		}

		songScore += score;

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (isPixelStage)
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();

		if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();

		if (FlxG.save.data.changedHitcombo)
			{
				comboSpr.x = FlxG.save.data.changedHitcomboX;
				comboSpr.y = FlxG.save.data.changedHitcomboY;
			}
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = PreferencesOptions.Antialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = PreferencesOptions.Antialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = comboSpr.x + (43 * daLoop) - 81;
			if (isPixelStage)
				{
					numScore.x = comboSpr.x + (43 * daLoop) - 101;
				}

			numScore.y += FlxG.save.data.changedHitcomboY - 297;
			if (isPixelStage)
				{
					numScore.y -= 60;
				}

			if (!isPixelStage)
			{
				numScore.antialiasing = PreferencesOptions.Antialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (PreferencesOptions.AutoPlay == false)
	{	
			if (comboPercentaje >= 10 || comboPercentaje == 0)
				add(numScore);
		}

			comboSpr.cameras = [camHUD];
numScore.cameras = [camHUD];
rating.cameras = [camHUD];

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */
		coolText.acceleration.y = 550;
		coolText.velocity.y -= FlxG.random.int(140, 175);
		coolText.velocity.x -= FlxG.random.int(0, 10);
		coolText.cameras = [camHUD];

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(coolText, {alpha: 0}, 0.1, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	var mashViolations:Int = 0;
	private function keyShit():Void
	{
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var pressArray:Array<Bool> = [
			controls.LEFT_P,
			controls.DOWN_P,
			controls.UP_P,
			controls.RIGHT_P
		];
		var releaseArray:Array<Bool> = [
			controls.LEFT_R,
			controls.DOWN_R,
			controls.UP_R,
			controls.RIGHT_R
		];

		// Prevent player input if botplay is on
		if(PreferencesOptions.AutoPlay)
		{
			holdArray = [false, false, false, false];
			pressArray = [false, false, false, false];
			releaseArray = [false, false, false, false];
		} 
		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
					goodNoteHit(daNote);
			});
		}
 
		// PRESSES, check for note hits
		if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			boyfriend.holdTimer = 0;
 
			var possibleNotes:Array<Note> = []; // notes that can be hit
			var directionList:Array<Int> = []; // directions that can be hit
			var dumbNotes:Array<Note> = []; // notes to kill later
			var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
			
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (!directionsAccounted[daNote.noteData])
					{
						if (directionList.contains(daNote.noteData))
						{
							directionsAccounted[daNote.noteData] = true;
							for (coolNote in possibleNotes)
							{
								if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
								{ // if it's the same note twice at < 10ms distance, just delete it
									// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
									dumbNotes.push(daNote);
									break;
								}
								// eeh?, doble note?
								var myArrosGuddy:Array <Note> = [];

								var fist = possibleNotes[0];

								if (fist != null){
								for (k in possibleNotes){
									 if (k.strumTime == fist.strumTime) 
										myArrosGuddy.push(k);
										var animToPlay = singArray[Std.int(Math.abs(daNote.noteData))];
										doTrailGhostAnim("bf", animToPlay);
									}
								}
								
								else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
								{ // if daNote is earlier than existing note (coolNote), replace
									possibleNotes.remove(coolNote);
									possibleNotes.push(daNote);
									break;
								}
							}
						}
						else
						{
							possibleNotes.push(daNote);
							directionList.push(daNote.noteData);
						}
					}
				}
			});

			trace('\nCURRENT LINE:\n' + directionsAccounted);
 
			for (note in dumbNotes)
			{
				FlxG.log.add("killing dumb ass note at " + note.strumTime);
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
 
			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
 
			var dontCheck = false;

			for (i in 0...pressArray.length)
			{
				if (pressArray[i] && !directionList.contains(i))
					dontCheck = true;
			}

			if (perfectMode)
				goodNoteHit(possibleNotes[0]);
			else if (possibleNotes.length > 0 && !dontCheck)
			{
				if (!PreferencesOptions.AutoPlay)
				{
					for (shit in 0...pressArray.length)
						{ // if a direction is hit that shouldn't be
							if (pressArray[shit] && !directionList.contains(shit))
								noteMiss(shit, null);
						}
				}
				for (coolNote in possibleNotes)
				{
					if (pressArray[coolNote.noteData])
					{
						if (mashViolations != 0)
							mashViolations--;
						//scoreTxt.color = dad.iconColor;
						goodNoteHit(coolNote);
					}
				}
			}
			else if (!PreferencesOptions.GhostTapping)
				{
					for (shit in 0...pressArray.length)
						if (pressArray[shit])
							noteMiss(shit, null);
				}

			if(dontCheck && possibleNotes.length > 0 && PreferencesOptions.GhostTapping && !PreferencesOptions.AutoPlay)
			{
				if (mashViolations > 8)
				{
					trace('mash violations ' + mashViolations);
					scoreTxt.color = FlxColor.RED;
					noteMiss(0,null);
				}
				else
					mashViolations++;
			}

		}
		
		notes.forEachAlive(function(daNote:Note)
		{
			if(PreferencesOptions.DownScroll && daNote.y > strumLine.y ||
			!PreferencesOptions.DownScroll && daNote.y < strumLine.y)
			{
				// Force good note hit regardless if it's too late to hit it or not as a fail safe
				if(PreferencesOptions.AutoPlay && daNote.canBeHit && daNote.mustPress ||
					PreferencesOptions.AutoPlay && daNote.tooLate && daNote.mustPress)
				{
						goodNoteHit(daNote);
						boyfriend.holdTimer = daNote.sustainLength;

						playerStrums.forEach(function(spr:StaticStrums)
						{
						   spr.playConfirmData(true);
						});
				}
			}
		});

	if (PreferencesOptions.AutoPlay){
		playerStrums.forEach(function(spr:StaticStrums)
		{
			spr.playConfirmData(true);
		});
	}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PreferencesOptions.AutoPlay))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.dance();
				// camX = 0;
				// camY = 0;
		}
 
		playerStrums.forEach(function(spr:StaticStrums)
		{
			if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
				spr.playAnim('pressed');
			if (!holdArray[spr.ID])
				spr.playAnim('static');
 
			if (spr.animation.curAnim.name == 'confirm' && !isPixelStage)
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	} // stop

	function noteMiss(direction:Int = 1,  ?daNote:Note):Void
	{
		if (!boyfriend.stunned)
			{
				vocals.volume = 0;
				if (combo > 5 && gf.animOffsets.exists('sad'))
				{
					gf.playAnim('sad');
				}
				combo = 0; 
	
				if (combo == 0){
					combo -= 1;
				}
	
				songScore -= 10;
				
				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
				// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
				// FlxG.log.add('played imss note');
	
				boyfriend.stunned = true;
	
				// get stunned for 5 seconds
				new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
				{
					boyfriend.stunned = false;
				});
	
					boyfriend.playAnim('sing' + StaticStrums.directionsPrefix[direction] + 'miss', true);
					// case 1:
					// 	boyfriend.playAnim('singDOWNmiss', true);
					// case 2:
					// 	boyfriend.playAnim('singUPmiss', true);
					// case 3:
					// 	boyfriend.playAnim('singRIGHTmiss', true);
			}
	}
/*
	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		if (leftP)
			noteMiss(0);
		if (downP)
			noteMiss(1);
		if (upP)
			noteMiss(2);
		if (rightP)
			noteMiss(3);
	}
*/
	/*function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted [FOR KADE] but you alnotesready know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	
	var etternaModeScore:Int = 0;
	function noteCheck(controlArray:Array<Bool>, note:Note):Void // THANKS KADE AGAIN :3
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			note.noteRating = CrystalTools.judgeNote(note, noteDiff);

			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
			}
		}

*/
	var dadGhostTween:FlxTween;
	var bfGhostTween:FlxTween;
    public function doTrailGhostAnim(char:String, animToPlay:String){
		{
			var ghost:FlxSprite = dadTrail;
			var player:Character = dad;
	
			switch(char.toLowerCase().trim()){
				case 'bf' | 'boyfriend' | '0':
					ghost = bfTrail;
					player = boyfriend;
				case 'dad' | 'opponent' | '1':
					ghost = dadTrail;
					player = dad;
				// case 'mom' | 'opponent2' | '3':
				// 	ghost = momGhost;
				// 	player = mom;
			}
							
			ghost.frames = player.frames;
			ghost.animation.copyFrom(player.animation);
			ghost.x = player.x;
			ghost.y = player.y;
			ghost.animation.play(animToPlay, true);
			ghost.offset.set(player.animOffsets.get(animToPlay)[0], player.animOffsets.get(animToPlay)[1]);
			ghost.flipX = player.flipX;
			ghost.flipY = player.flipY;
			ghost.antialiasing = player.antialiasing;
			ghost.scale.set(player.scale.x, player.scale.y);
			ghost.blend = HARDLIGHT;
			ghost.alpha = 0.8;
			ghost.visible = true;
/*
            huh?
			switch(curStage.toLowerCase()){
				case 'who' | 'voting' | 'nuzzus' | 'idk':
					//erm
				case 'cargo' | 'finalem':
					FlxG.camera.zoom += 0.015;
					camHUD.zoom += 0.015;
				default:
					FlxG.camera.zoom += 0.015;
					camHUD.zoom += 0.03;
			}
*/
	
			switch (char.toLowerCase().trim())
			{
				case 'bf' | 'boyfriend' | '0':
					if (bfGhostTween != null)
						bfGhostTween.cancel();
					ghost.color = boyfriend.iconColor;
						// FlxTween.tween(bfTrail, {x: bfTrail.x +30}, 0.5, {ease: FlxEase.circInOut, onComplete: function(twn){
						//    FlxTween.tween(bfTrail, {x: bfTrail.x- 30}, 0.4, {ease: FlxEase.circInOut});
						// }});
						bfGhostTween = FlxTween.tween(bfTrail, {alpha: 0}, 0.85, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							bfGhostTween = null;
						}
					});
	
				case 'dad' | 'opponent' | '1':
					if (dadGhostTween != null)
						dadGhostTween.cancel();
					ghost.color = dad.iconColor;
					// FlxTween.tween(dadTrail, {x: dadTrail.x - 30}, 0.5, {ease: FlxEase.circInOut, onComplete: function(twn){
					// 	FlxTween.tween(dadTrail, {x: dadTrail.x + 30}, 0.4, {ease: FlxEase.circInOut});
					//  }});
					dadGhostTween = FlxTween.tween(dadTrail, {alpha: 0}, 0.85, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							dadGhostTween = null;
						}
					});
				// case 'mom' | 'opponent2' | '3':
				// 	if (momGhostTween != null)
				// 		momGhostTween.cancel();
				// 	ghost.color = FlxColor.fromRGB(mom.healthColorArray[0] + 50, mom.healthColorArray[1] + 50, mom.healthColorArray[2] + 50);
				// 	momGhostTween = FlxTween.tween(momGhost, {alpha: 0}, 0.75, {
				// 		ease: FlxEase.linear,
				// 		onComplete: function(twn:FlxTween)
				// 		{
				// 			momGhostTween = null;
				// 		}
				// 	});
			}
		}
	}

    function interpolateHealth(ams:Float){
		FlxTween.num(health, health + ams, 0.1, {ease: FlxEase.cubeInOut}, function(name:Float) {
			health = name;
		});
	}
	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note);
				combo += 1;
			}

			if (note.noteData >= 0)
				interpolateHealth(0.023);
			else
				interpolateHealth(0.004);

			var animToPlay = singArray[Std.int(Math.abs(note.noteData))];

			boyfriend.playAnim(animToPlay, true);

			playerStrums.forEach(function(spr:StaticStrums)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.playAnim('confirm');
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	inline static public function deathDialogues(){
		if (PlayState.SONG.player1 == 'bf-pixel')
			{
				FlxG.sound.play(Paths.sound('dialogs/extras-' + FlxG.random.int(1, 8)), 1, false, null, true, function onComplete() 
					{
						FlxG.sound.music.fadeIn(0.2, 0.2, 1);
					});
			}
			else if (PlayState.SONG.player1 == 'bf' || PlayState.SONG.player1 == 'bf-car')
				{
					FlxG.sound.play(Paths.sound('dialogs/dialogues-' + FlxG.random.int(1, 11)), 1, false, null, true, function onComplete() 
						{
							FlxG.sound.music.fadeIn(0.2, 0.2, 1);
						});
				}
				else if (FlxG.random.bool(109))
					{
						FlxG.sound.play(Paths.sound('dialogs/wrong-line'), 1, false, null, true, function onComplete() 
							{
								FlxG.sound.music.fadeIn(0.2, 0.2, 1);
							});
					}
	}

	function blammedEvent()
		{
			for(i in 0...4)
				{
playerStrums.forEach(function(spr:FlxSprite)
	{
		FlxTween.tween(spr, {angle: 360}, 0.5, {ease:FlxEase.cubeInOut});
	});
	enemyStrums.forEach(function(spr:FlxSprite)
		{
			FlxTween.tween(spr, {angle: 360}, 0.5, {ease:FlxEase.cubeInOut});
		});
	}
		}

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (curSong.toLowerCase() == 'blammed' && curBeat >= 154 && curBeat < 159)
			{
				FlxTween.tween(FlxG.camera, {zoom: 1.5}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.sineInOut});
			}

		if (curSong.toLowerCase() == 'blammed' && curBeat == 154)
			{
				blammedEvent();
			}

			if (curSong.toLowerCase() == 'blammed' && curBeat == 153)
				{
					dad.playAnim('blammed', true);

					if (!PreferencesOptions.DownScroll)
						{
					enemyStrums.forEach(function(strums:FlxSprite)
						{
							FlxTween.tween(strums, {y: strums.y + 75}, 0.5, {ease: FlxEase.linear});
						});
						FlxTween.tween(strumLine, {y: strumLine.y + 75}, 0.5, {ease: FlxEase.linear});
					playerStrums.forEach(function(strums:FlxSprite)
						{
							FlxTween.tween(strums, {y: strums.y + 75}, 0.5, {ease: FlxEase.linear});
						});
					    }
						else
						{
enemyStrums.forEach(function(strums:FlxSprite)
						{
							FlxTween.tween(strums, {y: strums.y - 75}, 0.5, {ease: FlxEase.linear});
						});
						FlxTween.tween(strumLine, {y: strumLine.y - 75}, 0.5, {ease: FlxEase.linear});
					playerStrums.forEach(function(strums:FlxSprite)
						{
							FlxTween.tween(strums, {y: strums.y - 75}, 0.5, {ease: FlxEase.linear});
						});
						}

		FlxTween.tween(boxUp, {y: 0}, 0.5, {ease: FlxEase.linear});
		FlxTween.tween(boxDown, {y: 600}, 0.5, {ease: FlxEase.linear});
				}

				if (curSong.toLowerCase() == 'blammed' && curBeat == 159)
					{
					
FlxTween.tween(boxUp, {y: boxUp.y - 120}, 0.5, {ease: FlxEase.linear});
		FlxTween.tween(boxDown, {y: boxDown.y + 120}, 0.5, {ease: FlxEase.linear});

		if (!PreferencesOptions.DownScroll)
			{
		FlxTween.tween(strumLine, {y: strumLine.y - 75}, 0.5, {ease: FlxEase.linear});
		enemyStrums.forEach(function(strums:FlxSprite)
			{
				FlxTween.tween(strums, {y: strums.y - 75}, 0.5, {ease: FlxEase.linear});
			});
		playerStrums.forEach(function(strums:FlxSprite)
			{
				FlxTween.tween(strums, {y: strums.y - 75}, 0.5, {ease: FlxEase.linear});
			});
		}
		else
		{
			FlxTween.tween(strumLine, {y: strumLine.y + 75}, 0.5, {ease: FlxEase.linear});
		enemyStrums.forEach(function(strums:FlxSprite)
			{
				FlxTween.tween(strums, {y: strums.y + 75}, 0.5, {ease: FlxEase.linear});
			});
		playerStrums.forEach(function(strums:FlxSprite)
			{
				FlxTween.tween(strums, {y: strums.y + 75}, 0.5, {ease: FlxEase.linear});
			});
		}
					}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (curBeat % 2 == 0)
			{
				iconP1.angle = 13;
		        iconP2.angle = 13;
			}
			else
				{
					iconP1.angle = -13;
					iconP2.angle = -13;
				}

				iconP1.scale.set(1.2, 1.2);
				iconP2.scale.set(1.2, 1.2);

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curSong.toLowerCase() == 'roses' && curBeat == 111)
			{
				rosesEventTrail = new FlxTrail(dad, null, 4, 24, 0.6, 0.9);

				add(rosesEventTrail);
			}

			if (curSong.toLowerCase() == 'roses' && curBeat == 120)
			{
				remove(rosesEventTrail);
			}

			if (curSong.toLowerCase() == 'roses' && curBeat == 159)
				{
					rosesEventTrail = new FlxTrail(dad, null, 4, 24, 0.6, 0.9);

					add(rosesEventTrail);
				}
				
				if (curSong.toLowerCase() == 'roses' && curBeat == 167)
				{
					remove(rosesEventTrail);
				}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	var curLight:Int = 0;
}