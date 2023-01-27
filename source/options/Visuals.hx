package options;

#if desktop
import Discord.DiscordClient;
#end
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxGradient;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.ui.FlxButton;

class Visuals extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);

	var textBG:FlxSprite;

	var desc:FlxText;
	var menuBG:FlxSprite;
	public static var isPauseSubState:Bool = false;

	var grpControls:FlxTypedGroup<Alphabet>;
	var descriptions:Array<String>;
	var vol:Int = 0;
	override function create()
	{
FlxG.mouse.visible = true;

#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Options Menu(Visuals)", null);
		#end
		
		var tex = 'menuDesat';
		menuBG = new FlxSprite().loadGraphic(Paths.image(tex));
controlsStrings = CoolUtil.coolStringFile(
	"\nHide Hud "           + (!PreferencesOptions.HideHud ? "off" : "on") +
	"\nTime Bar "           + (!PreferencesOptions.TimeBar ? "off" : "on") +
	"\nAntialiasing "       + (!PreferencesOptions.Antialiasing ? "off" : "on") +
	"\nFullscreen "         + (!PreferencesOptions.FullScreen ? "off" : "on") +
	"\nFPS "         + (!PreferencesOptions.Fps ? "off" : "on")
); 
descriptions = [
	'Show or hide hud',
	'Show or hide time bar',
	'Sprites Quality',
	'Activate Full Screen',
	'Show or hide FPS'
];


		
		trace(controlsStrings);

		menuBG.color = 0xff4f005b;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x55FFBDF8, 0xAAFFFDF3], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}
		textBG = new FlxSprite(0, FlxG.height - 53).makeGraphic(FlxG.width, 40, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		desc = new FlxText(0, FlxG.height - 50, 0, "", 24);
		desc.scrollFactor.set();
		desc.text = descriptions[0];
		desc.setFormat(null, 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		desc.borderSize = 2.6;
		add(desc);

		// FlxG.save.data.volumeOp = vol;
		vol = FlxG.save.data.volumeOp;

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		desc.screenCenter(X);

		if (PreferencesOptions.HitSoundVolume > 1)
			{
			PreferencesOptions.HitSoundVolume = 1;
			vol = 100;
			}
		if (PreferencesOptions.HitSoundVolume <= 0.0)
			{
			PreferencesOptions.HitSoundVolume = 0.0;
			vol = 0;
			}

		if (curSelected == 5)
			desc.text = 'Hit Sound Volume: ${vol}%';

			if (controls.BACK){
				PreferencesOptions.saveData();
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.save.data.volumeOp = vol;
				if (!isPauseSubState)
					{
				nextState(new OptionsMenu());
			}
			else
			{
				PlayState.SONG;
				nextState(new PlayState());
			}
		}

if (curSelected == 5 && controls.LEFT_P)
	{
	PreferencesOptions.HitSoundVolume -= 0.1;
vol -= 10;
FlxG.save.data.volumeOp = vol;
	}
if (curSelected == 5 && controls.RIGHT_P)
	{
	PreferencesOptions.HitSoundVolume += 0.1;
	FlxG.save.data.volumeOp = vol;
vol += 10;
	}
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);

			if (controls.ACCEPT)
			{
				FlxG.save.data.volumeOp = vol;
				PreferencesOptions.saveData();
				FlxG.resetState();
				if (curSelected != 999) // shit mf
					grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						PreferencesOptions.HideHud = !PreferencesOptions.HideHud;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Hide Hud " + (PreferencesOptions.HideHud ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 0;
						grpControls.add(ctrl);
						case 1:
							PreferencesOptions.HideHud = !PreferencesOptions.HideHud;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Timbe Bar " + (PreferencesOptions.HideHud ? "off" : "on"), true, false);
							ctrl.isMenuItem = true;
							ctrl.targetY = curSelected - 1;
							grpControls.add(ctrl);
						case 2:
							PreferencesOptions.Antialiasing = !PreferencesOptions.Antialiasing;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Antialiasing " + (PreferencesOptions.Antialiasing ? "off" : "on"), true, false);
							ctrl.isMenuItem = true;
							ctrl.targetY = curSelected - 2;
							grpControls.add(ctrl);
						case 3:
							PreferencesOptions.FullScreen = !PreferencesOptions.FullScreen;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Fullscreen " + (PreferencesOptions.FullScreen ? "off" : "on"), true, false);
							ctrl.isMenuItem = true;
							ctrl.targetY = curSelected - 3;
							grpControls.add(ctrl);
							FlxG.fullscreen = PreferencesOptions.FullScreen;
						case 4:
							PreferencesOptions.Fps = !PreferencesOptions.Fps;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "FPS " + (PreferencesOptions.Fps ? "off" : "on"), true, false);
							ctrl.isMenuItem = true;
							ctrl.targetY = curSelected - 4;
							grpControls.add(ctrl);
							Main.toggleMem(PreferencesOptions.Fps);
				}
			}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.color = FlxColor.WHITE;
			// item.setGraphicSize(Std.int(item.width * 0.8));
desc.text = descriptions[curSelected];
desc.screenCenter(X);

			if (item.targetY == 0)
			{
				item.color = FlxColor.YELLOW;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}