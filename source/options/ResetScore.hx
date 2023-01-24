package options;

import flixel.util.FlxColor;
import flixel.*;
import flixel.tweens.FlxEase;
import options.PreferencesOptions;
import flixel.tweens.FlxTween;

class ResetScore extends MusicBeatSubstate
{
    var reset:FlxSprite;
    override function create()
        {
            super.create();

            var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
            bg.alpha = 0;
            add(bg);

            reset = new FlxSprite(FlxG.width, 40).loadGraphic(Paths.image('restart', 'shared'));
		reset.scale.set(0.2, 0.2);
		reset.screenCenter();
		reset.alpha = 0;
        reset.antialiasing = PreferencesOptions.Antialiasing;
        reset.angle -= 80;
		add(reset);

FlxTween.tween(bg, {alpha: 0.4}, 1, {ease: FlxEase.expoInOut});
FlxTween.tween(reset, {'scale.y': 0.6, 'scale.x': 0.6, alpha: 1, angle: 0}, 1, {ease: FlxEase.expoInOut, startDelay: 0.5});
        }
    
    override function update(ELAPSED:Float)
        {
            super.update(ELAPSED);

            if (controls.BACK)
                close();

            if (FlxG.mouse.overlaps(reset))
{
    FlxTween.tween(reset, {'scale.y': 0.75, 'scale.x': 0.75}, 0.2, {ease: FlxEase.expoInOut});

    if (FlxG.mouse.justPressed)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
		
		for (key in Highscore.songScores.keys())
			{
				Highscore.songScores[key] = 0;
			}
		for (key in Highscore.songGoodHits.keys())
			{
		Highscore.songGoodHits[key] = 0;
			}
		for (key in Highscore.songMisses.keys())
			{
		Highscore.songMisses[key] = 0;
			}
		for (key in Highscore.songRating.keys())
			{
		Highscore.songRating[key] = 0;
			}

            for (key in Highscore.songSicks.keys())
                {
            Highscore.songSicks[key] = 0;
                }
                for (key in Highscore.songGoods.keys())
                    {
                Highscore.songGoods[key] = 0;
                    }
                    for (key in Highscore.songBads.keys())
                        {
                    Highscore.songBads[key] = 0;
                        }
                        for (key in Highscore.songShits.keys())
                            {
                        Highscore.songShits[key] = 0;
                            }
        }
}
else
    {
        FlxTween.tween(reset, {'scale.y': 0.6, 'scale.x': 0.6}, 0.2, {ease: FlxEase.expoInOut});
    }
        }
}