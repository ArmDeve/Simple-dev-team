package;

#if desktop
import Discord.DiscordClient;
#end
import options.Preferences;
import Controls.Control;
import flixel.FlxG;
import options.PreferencesOptions;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class OptionsMenu extends MusicBeatState
{
var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [
	'KeyBinds', 
	'Preferences', 
	'Offsets',
	'Reset-Score'
];
	var curSelected:Int = 0;
	var bg:FlxSprite;

	function options(label:String)
		{
switch(label)
{
	case 'KeyBinds':
		openSubState(new options.KeyBindMenu());
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Options Menu(Keybinds)", null);
		#end
	case 'Preferences':
		Preferences.isPauseSubState = false;
	nextState(new options.Preferences());
	case 'Offsets':
		nextState(new options.OffsetsState());
	case 'Reset-Score':
		openSubState(new options.ResetScore());
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Options Menu(Reseting the scores)", null);
		#end
}
		}

	override function create()
	{
		super.create();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Options Menu", null);
		#end

		Preferences.isPauseSubState = false;
		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBGBlue'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = PreferencesOptions.Antialiasing;
		add(bg);

		var bf:FlxSprite = new FlxSprite(0, 100).loadGraphic(Paths.image('bfOptions'));
		bf.setGraphicSize(Std.int(bf.width * 0.8));
		bf.screenCenter(X);
		bf.x += FlxG.width * 0.30;
		bf.antialiasing = PreferencesOptions.Antialiasing;
		bf.y += 700;
		add(bf);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (100 * i) + 0, menuItems[i], true, false);
			songText.isMenuItem = false;
			songText.targetY = i;
			songText.alpha = 0;
			songText.x -= 100;
			songText.forceX = songText.x;
			grpMenuShit.add(songText);
            FlxTween.tween(songText, {alpha: 1, y: songText.y + 30, x: songText.x + 115}, 0.7, {startDelay: 0 + (0.3*i), ease: FlxEase.backInOut});
		}

		FlxTween.tween(bf, {y: bf.y - 620}, 0.7, {startDelay: 1.3, ease: FlxEase.backInOut});

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			nextState(new MainMenuState());
		}
		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			options(menuItems[curSelected]);
		}
	}

	function changeSelection(change:Int = 0):Void
	{

		FlxG.sound.play(Paths.sound('scrollMenu'));
		
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.color = FlxColor.WHITE;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.color = FlxColor.YELLOW;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}