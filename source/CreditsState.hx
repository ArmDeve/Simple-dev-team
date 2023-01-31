package;

import flixel.util.FlxGradient;
import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import options.PreferencesOptions;
import flixel.tweens.FlxTween;
import flash.geom.Rectangle;
import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.*;

class CreditsState extends MusicBeatState
{
    var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);
    var bg:FlxSprite;
    var box:FlxSprite;
    var credGrp:FlxTypedGroup<Alphabet>;
    var iconArray:Array<Icons> = [];

    // IF YOU GET AN ERROR PLEASE IMPORT CredsStuff TO THE STATE

    var desc:FlxText;
    var intendedColor:Int;
	var colorTween:FlxTween;
	var curSelected:Int = 0;
    var someShit:Array<SHIT> = [];

    override function create()
    {
        super.create();

        Main.toggleMem(false); // idk

        for (i in 0...CredsStuff.creditsStuff.length)
            {
        someShit.push(new SHIT(FlxColor.fromString(CredsStuff.creditsStuff[i][3])));
            }

        bg = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
        bg.scrollFactor.set();
        bg.screenCenter();
        bg.antialiasing = PreferencesOptions.Antialiasing;
        add(bg);

		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x55FFBDF8, 0xAAFFFDF3], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
        gradientBar.scrollFactor.set();
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

        box = new FlxSprite(480).loadGraphic(Paths.stuff('bigBox.png'));
        box.scrollFactor.set();
        box.antialiasing = PreferencesOptions.Antialiasing;
        add(box);

        desc = new FlxText(0, 0, 682, CredsStuff.creditsStuff[0][1] + '\n\n\n' + CredsStuff.creditsStuff[0][2], 60);
        //desc.x = 531;
        desc.y = 90;
        desc.scrollFactor.set();
        desc.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        desc.borderSize = 4.4;
        add(desc);

        credGrp = new FlxTypedGroup<Alphabet>();
        add(credGrp);

        for(i in 0...CredsStuff.creditsStuff.length)
            {
                // NEW CREDITS BABEEEEEEE
                var creditsShit = new Alphabet(0, (20 * i) + 0, CredsStuff.creditsStuff[i][0], false, false, 0, 0.75);
                creditsShit.x += 150;
                creditsShit.isMenuItem = true;
                creditsShit.forceX = creditsShit.x;
                creditsShit.targetY = i;
                credGrp.add(creditsShit);

                var Icon:Icons = new Icons('credits/' + CredsStuff.creditsStuff[i][0]);
                Icon.Xsize = 0.7;
                Icon.Antialiasing = PreferencesOptions.Antialiasing;
                Icon.Ysize = 0.7;
				Icon.SprTracker = creditsShit;

				iconArray.push(Icon);
				add(Icon);
            }
            changeSelection();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        desc.x = (box.width / 2) - (desc.width / 2) + box.x;

        if (controls.UP_P || controls.DOWN_P)
        {
            FlxTween.tween(desc,{x:(box.width / 2) - (desc.width / 2) + box.x + 600},0.2,{ease:FlxEase.cubeOut, onComplete: function(twn:FlxTween)
            {
                FlxTween.tween(desc,{x:(box.width / 2) - (desc.width / 2) + box.x},0.2,{ease:FlxEase.cubeOut});
            }});

                    FlxTween.tween(box,{x:box.x + 600},0.2,{ease:FlxEase.cubeOut, onComplete: function(twn:FlxTween){
                        FlxTween.tween(box,{x: 480},0.2,{ease:FlxEase.cubeOut});
                    }});

           FlxTween.tween(desc,{alpha : 0},0.2,{ease:FlxEase.cubeIn,onComplete: function(twn:FlxTween)
                {
                    FlxTween.tween(desc,{alpha : 1},0.2,{ease:FlxEase.cubeOut});
                    desc.text = CredsStuff.creditsStuff[curSelected][1] + '\n\n\n' + CredsStuff.creditsStuff[curSelected][2];
                }
            });

            FlxTween.tween(box,{alpha : 0},0.2,{ease:FlxEase.cubeIn,onComplete: function(twn:FlxTween)
                {
                    FlxTween.tween(box,{alpha : 1},0.2,{ease:FlxEase.cubeOut});
                    
                }
            });
        }

        if (controls.UP_P)
            {
            changeSelection(-1);
            }
        if (controls.DOWN_P)
            {
            changeSelection(1);
            }

      if (controls.ACCEPT)
        FlxG.openURL(CredsStuff.creditsStuff[curSelected][4]);

                if (controls.BACK)
                    {
                        Main.toggleMem(true);
                       nextState(new MainMenuState());
                    }
    }

    function changeSelection(change:Int = 0):Void
        {
            FlxG.sound.play(Paths.sound('scrollMenu'), 1);

                curSelected += change;
                if (curSelected < 0)
                    curSelected = credGrp.length - 1;
                if (curSelected >= credGrp.length)
                    curSelected = 0;

                switch (curSelected)
                {
                 default:
                    var newColor:Int = someShit[curSelected].menuColor;
                    if (newColor != intendedColor)
                        {
                            if (colorTween != null)
                            {
                                colorTween.cancel();
                            }
                            intendedColor = newColor;
                    colorTween = FlxTween.color(bg, 1, bg.color, someShit[curSelected].menuColor, {
                        onComplete: function(twn:FlxTween) {
                            colorTween = null;
                        }
                    });
                }
                }

                for (i in 0...iconArray.length)
                    {
                        iconArray[i].alpha = 0.45;
                    }
            
                    iconArray[curSelected].alpha = 1;

                    var bullShit:Int = 0;

                for (item in credGrp.members)
                    {
                        item.targetY = bullShit - curSelected;
                        bullShit++;

                        item.alpha = 0.7;

                        if (item.targetY == 0)
                            {
                                item.alpha = 1;
                            }
                    }
        }
    }

    class SHIT
{
	public var menuColor:Int = 0xFFffffff;

	public function new(menuColor:Int = 0xFFffffff)
	{
		this.menuColor = menuColor;
	}
}

class Icons extends FlxSprite
{
	public var SprTracker:FlxSprite;
	
	public var Ysize:Float = 0;
	public var Xsize:Float = 0;
	public var Antialiasing:Bool;

	public function new(?file:String = null, ?library:String = null)
	{
		super();if(file != null) {
			loadGraphic(Paths.image(file));
		}
		antialiasing = Antialiasing;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (SprTracker != null) {
			setPosition(SprTracker.x - 150, SprTracker.y + 19);
			scale.set(Xsize, Ysize);
		}
	}
}

class CredsStuff
{
    static public var creditsStuff:Array<Dynamic> = 
	[ 
	[
	'AmsDev', // name|icon
	'Main Programmer', // work
	'are you sure you re not gay? prove otherwise lol pls suscribe to my channel XD', // sentence
	'#727FB3', // color
	'https://www.youtube.com/channel/UCLiN7NfSI61E7Fm6g-isUGA' // link
	],
	[
    'MrNiz',
	'Extra Programmer',
	'Pixel Transition Coder',
	'#FFFFFF',
	'https://twitter.com/MrNizy'
	],
	[
	'AssmanBruh!',
	'Main Artist',
	'Hi bro im assman Plaza good',
	'#FFFFFF',
	'https://www.youtube.com/@assmanbruh7030'
	],
    [
    'Jarcor',
    'Dead OST Creator',
    'ETIQUETAAAA',
    '#FF4F4F',
    'https://www.youtube.com/@assmanbruh7030'
    ],
    [
    'Qbo',
    'Trailer Editor',
    'ANACHEI',
    '#339999',
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
	'hi guys im sas, play friday night rayman mod',
	'#FF33FF',
	'https://twitter.com/DrawPant'
	],
	[
	'HiroBerserk',
	'App Icon Artist',
	'Tmr pe',
	'#3B93C6',
	'https://twitter.com/berserk_hiro?t=IGJ8m9FVHz-ugqw1aYsRJA&s=09'
	],
	[
	'Bit',
	'Ratings Artist',
	'I am the least fan and burn Paraguay',
	'#FFFFFF',
	'https://twitter.com/Kasler_dumb'
	]
    ];
}