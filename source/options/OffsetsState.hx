package options;

import flixel.addons.display.FlxBackdrop;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import options.PreferencesOptions;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.math.FlxMath;

class OffsetsState extends MusicBeatState
{
	var changeModeText:FlxText;
    var sick:FlxSprite;
    var combo:FlxSprite;
	var num:FlxSprite;

	var healthBarBG:FlxSprite;
	var healthBar:FlxBar;
	var dad:Character;
	var boyfriend:Boyfriend;

	var camFollow:FlxObject;

	var defaultX:Float = FlxG.width * 0.55 - 135;
	var defaultY:Float = FlxG.height / 2 - 50;
var bg:FlxSprite;

    override function create()
    {
		FlxG.mouse.visible = true;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Options Menu(Offsets)", null);
		#end

        bg = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat', 'preload'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.color = FlxColor.GRAY;
		bg.antialiasing = PreferencesOptions.Antialiasing;
		add(bg);

		var checkers:FlxBackdrop = new FlxBackdrop(Paths.image('checkers', 'preload'),0,0,true,true,0,0);
		checkers.velocity.x = 20;
		checkers.velocity.y = 20;
		checkers.alpha = 0.4;
		checkers.color = FlxColor.BLACK;
		add(checkers);

        sick = new FlxSprite(-80).loadGraphic(Paths.image('sick', 'shared'));
		sick.setGraphicSize(Std.int(sick.width * 0.7));
		sick.antialiasing = PreferencesOptions.Antialiasing;

		if (FlxG.save.data.changedHit)
			{
				sick.x = FlxG.save.data.changedHitX;
				sick.y = FlxG.save.data.changedHitY;
			}
		add(sick);

		num = new FlxSprite(-80, 20).loadGraphic(Paths.image('num0', 'preload'));
		num.setGraphicSize(Std.int(num.width * 0.5));
num.antialiasing = PreferencesOptions.Antialiasing;
		if (FlxG.save.data.changedHitcombo)
			{
				num.x = FlxG.save.data.changedHitcomboX - 120;
				num.y = 50 + FlxG.save.data.changedHitcomboY;
			}
		add(num);

		changeModeText = new FlxText(0, 4, FlxG.width, "", 24);
		changeModeText.setFormat(null, 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		changeModeText.scrollFactor.set();
		changeModeText.borderSize = 2.6;
		add(changeModeText);

		sick.x = FlxG.save.data.changedHitX;
		sick.y = FlxG.save.data.changedHitY;

		num.x = FlxG.save.data.changedHitcomboX;
		num.y = FlxG.save.data.changedHitcomboY;
		
		updateMode();

		super.create();
	}

	var onComboMenu:Bool = false;

override function update(elapsed:Float)
	{
super.update(elapsed);

changeModeText.screenCenter(X);

		if(controls.ACCEPT)
			{
				onComboMenu = !onComboMenu;
				updateMode();
			}

			if(onComboMenu){
				if (FlxG.mouse.pressed && FlxG.mouse.justMoved)
					{

						num.x = (FlxG.mouse.screenX);
						num.y = (FlxG.mouse.screenY);
			FlxG.save.data.changedHitcomboX = num.x;
			FlxG.save.data.changedHitcomboY = num.y;
			FlxG.save.data.changedHitcombo = true;
					}
			}
			else
				{
					if (FlxG.mouse.pressed && FlxG.mouse.justMoved)
						{
							sick.x = (FlxG.mouse.screenX);
							sick.y = (FlxG.mouse.screenY);

							FlxG.save.data.changedHitX = sick.x;
			FlxG.save.data.changedHitY = sick.y;
			FlxG.save.data.changedHit = true;
						}
				}
		

        if (controls.BACK)
			{
            nextState(new OptionsMenu());
			FlxG.sound.play(Paths.sound('cancelMenu'));
                    } 
	}

	function updateMode()
		{
			
			if(onComboMenu)
				{
				num.alpha = 1;
			sick.alpha = 0.5;
				}
			else
				{
			sick.alpha = 1;
			num.alpha = 0.5;
				}

			if(onComboMenu)
				changeModeText.text = '< Combo Offset (Press Accept to Switch) >';
			else
				changeModeText.text = '< Sick Offset (Press Accept to Switch) >';
		}
                                            
    }