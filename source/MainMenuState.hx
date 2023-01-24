package;

import flixel.FlxGame;
import options.PreferencesOptions;
import flixel.math.FlxMath;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxGradient;
import haxe.Json;
import lime.utils.Assets;
#if desktop
import Discord.DiscordClient;
#end
import flixel.addons.ui.StrNameLabel;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	
	var menuItems:FlxTypedGroup<FlxSprite>;

	var bgS:FlxSprite;
	var bg:FlxSprite;
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var chars:FlxSprite;
	var animSpeed:Int = 1;
	var menuItemsOptions:Array<String> = ['story mode', 'freeplay', 'credits', 'options'];

	var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);

	function states(label:String)
		{
switch(label)
{
	case 'story mode':
		nextState(new StoryMenuState());
	case 'freeplay':
		nextState(new FreeplayState());
	case 'credits':
		nextState(new CreditsState());
	case 'options':
		nextState(new OptionsMenu());
}
		}

	override function create()
	{
		FlxG.autoPause = false;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if(FlxG.sound.music == null || !FlxG.sound.music.playing || FlxG.sound.music.volume == 0)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

				FlxG.sound.music.fadeIn(4, 0, 1);
	
			}

		Application.current.window.title = "Friday Night Funkin' Simple Engine";

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = PreferencesOptions.Antialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0;
		magenta.setGraphicSize(Std.int(magenta.width * 1.2));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = PreferencesOptions.Antialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x55FFBDF8, 0xAAFFFDF3], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...menuItemsOptions.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0 + (i * 0), 0 + (i * 0));
			menuItem.frames = tex;
			menuItem.scale.y = 0.7;
			menuItem.scale.x = 0.7;
			menuItem.animation.addByPrefix('idle', menuItemsOptions[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', menuItemsOptions[i] + " white", 24);
			menuItem.animation.play('idle');
			//menuItem.updateHitbox();
			menuItem.alpha = 0;
			menuItem.ID = i;
			menuItem.origin.set(0, 0);// lerps bug shit
			menuItems.add(menuItem);
			menuItem.antialiasing = PreferencesOptions.Antialiasing;

			FlxTween.tween(menuItem, {y: menuItem.y + 20 + (i * 180), x: menuItem.x + 400 + (i * 120), alpha: 1}, 0.7, {ease: FlxEase.backInOut,startDelay: 0.3 * i});
		}

		//FlxG.camera.follow(camFollow, null, 0.06);

		bgS = new FlxSprite(-800).loadGraphic(Paths.image('menuSeparator'));
		bgS.scrollFactor.x = 0;
		bgS.scrollFactor.y = 0;
		bgS.setGraphicSize(Std.int(bgS.width * 1));
		bgS.updateHitbox();
		bgS.screenCenter(Y);
		bgS.flipY = true;
		bgS.antialiasing = PreferencesOptions.Antialiasing;
	    add(bgS);

		chars = new FlxSprite(-625, 120);
		chars.antialiasing = PreferencesOptions.Antialiasing;
		add(chars);

		if (FlxG.random.bool(25.40))
		{
			chars.x += 60;
			chars.y += 180;
			chars.frames = Paths.getSparrowAtlas('menuCharacters/assmanMenu', 'shared');
			chars.animation.addByPrefix('dance', 'assman idle', 24, true);
			chars.scale.set(1.4, 1.4);
			chars.animation.play('dance');
			chars.flipX = false;
		}
		else if (FlxG.random.bool(35.90))
		{
			chars.y += 160;
			chars.x += 40;
			chars.frames = Paths.getSparrowAtlas('menuCharacters/amsMenu', 'shared');
			chars.animation.addByPrefix('dance', 'idle', 24, true);
			chars.scale.set(1, 1);
			chars.animation.play('dance');
			chars.flipX = false;
		}
		else if (FlxG.random.bool(23.90))
			{
				chars.y += 160;
				chars.x += 40;
				chars.frames = Paths.getSparrowAtlas('menuCharacters/qboMenu', 'shared');
				chars.animation.addByPrefix('dance', 'idle', 24, true);
				chars.scale.set(1, 1);
				chars.animation.play('dance');
				chars.flipX = false;
			}
		else if (FlxG.random.bool(100))
		{
			chars.y += 95;
			chars.frames = Paths.getSparrowAtlas('menuCharacters/bfMenu', 'shared');
			chars.animation.addByPrefix('dance', 'bf idle instancia 1', 24, true);
			chars.scale.set(0.8, 0.8);
			chars.animation.play('dance');
			chars.flipX = true;
		}
		FlxTween.tween(chars, {x: chars.x + 600}, 0.8, {ease: FlxEase.backInOut});
		FlxTween.tween(bgS, {x: bgS.x + 625}, 0.8, {ease: FlxEase.backInOut});

		var versionShit:FlxText = new FlxText(5, FlxG.height - 48, 0, 'VERSION: 4.0\nStylus Engine R.I.P\nSimple Engine', 12);
		versionShit.scrollFactor.set();
		versionShit.borderSize = 5.2;
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

menuItems.forEach(function(spn:FlxSprite)
	{
spn.scale.y = FlxMath.lerp(0.7,spn.scale.y, 1 - elapsed * 10);
spn.scale.x = FlxMath.lerp(0.7,spn.scale.x, 1 - elapsed * 10);
if (spn.ID == curSelected)
	{
spn.scale.y = FlxMath.lerp(0.9,spn.scale.y, 1 - elapsed * 10);
spn.scale.x = FlxMath.lerp(0.9,spn.scale.x, 1 - elapsed * 10);
	}
	});

			if (controls.ACCEPT)
			{
				if (menuItemsOptions[curSelected] == 'donate')
					{
						FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					}
					else
					{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
FlxTween.tween(chars, {x: -600}, 0.8, {ease: FlxEase.backInOut});
FlxTween.tween(bgS, {x: -800}, 0.8, {ease: FlxEase.backInOut});
FlxTween.tween(spr, {x: 600}, 0.8, {ease: FlxEase.backInOut});

							FlxTween.tween(spr, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
						}
						else
						{
							FlxFlicker.flicker(spr, 0.5, 0.06, false, false, function(flick:FlxFlicker)
							{
								states(menuItemsOptions[curSelected]);
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
					}

			//spr.updateHitbox();
		});
	}
}
