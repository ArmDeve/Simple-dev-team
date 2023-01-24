package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;

using StringTools;

class StaticStrums extends FlxSprite{
	private var noteData:Int = 0;
    private var player:Int = 0;
    public var skin:String = '';

    public var setAlpha:Float = 0.8;

    public static var directionsPrefix:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT"];
    public static var colorsPrefix:Array<String> = ["PURPLE", "BLUE", "GREEN", "RED"];

    public function new(x:Float, y:Float, skin:String = 'NOTE_assets', staticData:Int, player:Int) 
    {
        super(x, y);
        noteData = staticData;
        this.skin = skin;
        this.player = player;
        addStatic();
    }
    public function addStatic()
    {
            if (PlayState.isPixelStage)
                {
                loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
                animation.add('green', [noteData + 4]);
                animation.add('red', [noteData + 4]);
                animation.add('blue', [noteData + 4]);
                animation.add('purplel', [noteData + 4]);

                setGraphicSize(Std.int(width * PlayState.daPixelZoom));
                updateHitbox();
                antialiasing = false;

                switch (Math.abs(noteData))
                {
                    case 0:
                        animation.add('static', [0]);
                        animation.add('pressed', [4, 8], 12, false);
                        animation.add('confirm', [12, 16], 24, false);
                    case 1:
                        animation.add('static', [1]);
                        animation.add('pressed', [5, 9], 12, false);
                        animation.add('confirm', [13, 17], 24, false);
                    case 2:
                        animation.add('static', [2]);
                        animation.add('pressed', [6, 10], 12, false);
                        animation.add('confirm', [14, 18], 12, false);
                    case 3:
                        animation.add('static', [3]);
                        animation.add('pressed', [7, 11], 12, false);
                        animation.add('confirm', [15, 19], 24, false);
                }
            }
            else
                {
                
                frames = Paths.getSparrowAtlas(skin);
                for (i in 0...4){
                animation.addByPrefix('${colorsPrefix[Std.int(noteData)].toLowerCase()}',
                'arrow' + directionsPrefix[Std.int(noteData)]);
                }

                antialiasing = true;
                setGraphicSize(Std.int(width * 0.7));

                animation.addByPrefix('static', 'arrow' + directionsPrefix[Std.int(noteData)]);
                animation.addByPrefix('pressed', '${directionsPrefix[Std.int(noteData)].toLowerCase()} press', 24, false);
                animation.addByPrefix('confirm', '${directionsPrefix[Std.int(noteData)].toLowerCase()} confirm', 24, false);
            }
    }	
    public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
        {
            if (AnimName == 'confirm')
                alpha = 1;
            else
                alpha = setAlpha;
    
            animation.play(AnimName, Force, Reversed, Frame);
            // updateHitbox();
        }

    public function setPositionStatic() {
		animation.play('static');
		x += Note.swagWidth * noteData;
		x += 50;
		x += ((FlxG.width / 2) * player);
		ID = noteData;
	}

    /**
     * a innecesarly shit
    **/
    public function playConfirmData(reset:Bool = false){
     if (reset)  {
        if (animation.finished)
			{
				playAnim('static');
				centerOffsets();
			}
     }else{
        if (Math.abs(noteData) == ID)
            {
                playAnim('confirm', true);
            }
            if (animation.curAnim.name == 'confirm' && !PlayState.isPixelStage)
            {
                centerOffsets();
                offset.x -= 13;
                offset.y -= 13;
            }
            else
                centerOffsets();
        }
    }

    override public function update(ea) {
        super.update(ea);
    }
}