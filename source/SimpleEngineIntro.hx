package;

import flixel.util.FlxColor;
import flixel.*;
import flixel.util.FlxTimer;
import options.PreferencesOptions;
using StringTools;

class SimpleEngineIntro extends MusicBeatState
{
    var logo:FlxSprite;
    var nexState:FlxState;

    public function new(nextState:FlxState)
        {
            super();
            nexState = nextState;
        }
 
        override public function create()
        {
            super.create();

            new FlxTimer().start(0.05, function(tmr:FlxTimer)
                {
            FlxG.sound.play(Paths.sound('confirmMenu'));
                });

            logo = new FlxSprite();
            logo.scale.set(1.2, 1.2);
            logo.antialiasing = PreferencesOptions.Antialiasing;
            logo.frames = Paths.getSparrowAtlas('SimpleEngineLogo');
            logo.animation.addByPrefix('intro', 'anim', 24, false);
            logo.animation.play('intro');
            logo.screenCenter();
            add(logo);
        }

        override function update(elapsed:Float) {
            super.update(elapsed);

                new FlxTimer().start(3.5, function(tmr:FlxTimer)
                    {
                FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
                    {
                        nextState(nexState);
                        logo.alpha = 0;
                    });
                });
        }
}