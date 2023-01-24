package;

import flixel.*;
import options.PreferencesOptions;

class HealthIconNew extends FlxSprite
{
    // new icons by AMS
    public var sprTracker:FlxSprite;
    var char:String = '';

    public function new(char:String, isPlayer:Bool = false, ?animated:Bool = false, ?winningAnim:Bool = false)
        {
super();
antialiasing = PreferencesOptions.Antialiasing;

    scrollFactor.set();
    setIcon(char, animated, winningAnim);

    flipX = isPlayer;
    }

    override function update(elapsed:Float)
        {
            super.update(elapsed);
    
            if (sprTracker != null)
                setPosition(sprTracker.x - 150, sprTracker.y - 30);
        }

        public function setIcon(char:String, ?animated:Bool = false, ?winningAnim:Bool = false) // used for charting state
            {
                this.char = char;
                if (animated != false)
                    {
                    frames = Paths.getSparrowAtlas('icons/icon-'+char, 'preload');
                    animation.addByPrefix('idle', char+'-idle', 24, true);
                    animation.addByPrefix('losing', char+'-losing', 24, true);
                    animation.play('idle');
                    }
                else if (animated != false && winningAnim != false)
                    {
                    frames = Paths.getSparrowAtlas('icons/icon-'+char, 'preload');
                    animation.addByPrefix('idle', char+'-idle', 24, true);
                    animation.addByPrefix('losing', char+'-losing', 24, true);
                    animation.addByPrefix('winning', char+'-winning', 24, true);
                    animation.play('idle');
                    }
                else if (animated != true && winningAnim != false)
                    {
                        loadGraphic(Paths.image('icons/icon-'+char, 'preload')); // uwu
                        loadGraphic(Paths.image('icons/icon-'+char, 'preload'), true, Math.floor(width / 2), Math.floor(height));
                        animation.add(char, [0, 1, 2], 0, false);
                        animation.play(char);
                    }
                else if (animated != true || winningAnim != true)
                    {
                        loadGraphic(Paths.image('icons/icon-'+char, 'preload'));
                        loadGraphic(Paths.image('icons/icon-'+char, 'preload'), true, Math.floor(width / 2), Math.floor(height));
                        animation.add(char, [0, 1], 0, false);
                        animation.play(char);
                    }
            }
}
