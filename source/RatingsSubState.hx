package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import options.PreferencesOptions;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.*;
import flixel.FlxSubState;

class RatingsSubState extends MusicBeatSubstate
{
    var cameronIloveYou:Array<String>=[];

   var ratings:Array<String> = ['A', 'B', 'C', 'D', 'E' ,'F'];

    var bf:FlxSprite;
    var ratingBig:Alphabet;

    var sicks:Int = 0;
	var goods:Int = 0;
	var bads:Int = 0;
	var shits:Int = 0;
    var combos:Int = 0;
	
   public function new(song:String, diff:Int)
    {
        super();

        sicks = Highscore.getSicks(song, diff);
        goods = Highscore.getGoods(song, diff);
        bads = Highscore.getBads(song, diff);
        shits = Highscore.getShits(song, diff);
        combos = Highscore.getRating(song, diff);
    }

    var ratingsSpr:Array<String> = ['sick', 'good', 'bad', 'shit', 'combo'];

    override function create()
    {
        var bg = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0;
        add(bg);

        cameronIloveYou = ['${sicks}', '${goods}', '${bads}', '${shits}', '${combos}%'];

for (i in 0...cameronIloveYou.length)
    {
var ratingsAGAIN = new Alphabet(0, 0, cameronIloveYou[i], true, false);
ratingsAGAIN.x += 400;
ratingsAGAIN.ID = i;
ratingsAGAIN.alpha = 0;
add(ratingsAGAIN);

FlxTween.tween(ratingsAGAIN, {y: ratingsAGAIN.y + 55 + (i * 120), alpha: 1}, 1, {ease: FlxEase.expoInOut, startDelay: 1});
    }

for (i in 0...ratingsSpr.length)
    {
var ratingsLOL = new FlxSprite(10, 0);
ratingsLOL.scale.set(0.7, 0.7);
ratingsLOL.ID = i;
ratingsLOL.alpha = 0;
ratingsLOL.antialiasing = PreferencesOptions.Antialiasing;
ratingsLOL.loadGraphic(Paths.image(ratingsSpr[i], 'shared'));
add(ratingsLOL);

FlxTween.tween(ratingsLOL, {y: ratingsLOL.y + 15 + (i * 120), alpha: 1}, 1, {ease: FlxEase.expoInOut, startDelay: 0.5});
    }

        FlxTween.tween(bg, {alpha: 0.5}, 1, {ease: FlxEase.expoInOut});

        bf = new FlxSprite(720,760);
        bf.angle = 60;
				bf.frames = Paths.getSparrowAtlas("BOYFRIEND", 'shared');
				bf.animation.addByPrefix('hey', 'BF HEY!!', 24, false);
                bf.animation.addByPrefix("damn", "BF NOTE RIGHT MISS", 24, false);
bf.antialiasing = PreferencesOptions.Antialiasing;
                add(bf);

                var ratingSpr = new FlxSprite(bf.x + 150, -190);
                ratingSpr.angle -= 60;
                ratingSpr.antialiasing = PreferencesOptions.Antialiasing;
                ratingSpr.scale.set (5, 5);
                ratingSpr.antialiasing = false;
                add(ratingSpr);

                if(sicks > 120)
                    {
                bf.animation.play('hey'); 
                    }
                else if (sicks < 120)
                    {
                bf.animation.play('damn'); 
                    }

                    if (sicks < goods)
                        {
                            ratingSpr.loadGraphic(Paths.image('rankingsShit/' + ratings[4]));
                        }
                    else if (sicks > 110)
                        {
                            ratingSpr.loadGraphic(Paths.image('rankingsShit/' + ratings[3]));
                        }
                    else if (bads > goods || shits > bads || goods < 100 || sicks < 120 || sicks == 0)
                        {
                            ratingSpr.loadGraphic(Paths.image('rankingsShit/' + ratings[5]));
                        }
                    else if (sicks > 200 || goods > 200)
                        {
                            ratingSpr.loadGraphic(Paths.image('rankingsShit/' + ratings[2]));
                        }
                    else if (sicks > 240 || goods > 210)
                        {
                            ratingSpr.loadGraphic(Paths.image('rankingsShit/' + ratings[1]));
                        }
                    else if (sicks > 500 || goods > 320)
                        {
                            ratingSpr.loadGraphic(Paths.image('rankingsShit/' + ratings[0]));
                        }

                FlxTween.tween(bf, {y: bf.y - 400, angle: 0}, 1, {ease: FlxEase.expoInOut, startDelay: 1.5});
                FlxTween.tween(ratingSpr, {y: ratingSpr.y + 350, angle: 0}, 1, {ease: FlxEase.expoInOut, startDelay: 1.5});
        super.create();
    }

    

    override function update(ELAPSED:Float)
        {
            super.update(ELAPSED);

            if (controls.BACK)
                {                
                    close();
                    #if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay", null);
		#end
                }
    }
}