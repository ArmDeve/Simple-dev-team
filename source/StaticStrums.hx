package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;
using StringTools;

class StaticStrums extends FlxSprite{
	private var noteData:Int = 0;
    private var player:Int = 0;
    public var skin:String = '';
    public var initAlpha:Float = 0.8;
    public var keyAmount:Int = 4;

    // public var music:MusicBeatState;
    // public static var controlsAmount:Map<String, Array<Bool>> = [];
    // public var controlType:String = "PRESSED";
    public function new(x:Float, y:Float, skin:String = 'NOTE_assets', staticData:Int, keyAmount:Int = 4, player:Int) 
    {
        super(x, y);
/*
        switch(controlType){
        case "JUSTRELEASED":
        switch(keyAmount){
        case 5:    
        controlsAmount.set("JUSTRELEASED", [music.controlsP.LEFT, music.controlsP.DOWN, FlxG.keys.anyPressed([FlxKey.fromString(FlxG.save.data.spaceBind)]), music.controlsP.UP, music.controlsP.RIGHT]);
        default:  
        controlsAmount.set("JUSTRELEASED", [music.controlsP.LEFT, music.controlsP.DOWN, music.controlsP.UP, music.controlsP.RIGHT]);
        }
        case "JUSTPRESSED":
        switch(keyAmount){
        case 5:    
        controlsAmount.set("JUSTPRESSED", [music.controlsP.LEFT, music.controlsP.DOWN, FlxG.keys.anyPressed([FlxKey.fromString(FlxG.save.data.spaceBind)]), music.controlsP.UP, music.controlsP.RIGHT]);
        default:  
        controlsAmount.set("JUSTPRESSED", [music.controlsP.LEFT, music.controlsP.DOWN, music.controlsP.UP, music.controlsP.RIGHT]);
        }
        case "PRESSED":    
        switch(keyAmount){
        case 5:    
        controlsAmount.set("PRESSED", [music.controlsP.LEFT, music.controlsP.DOWN, FlxG.keys.anyPressed([FlxKey.fromString(FlxG.save.data.spaceBind)]), music.controlsP.UP, music.controlsP.RIGHT]);
        default:  
        controlsAmount.set("PRESSED", [music.controlsP.LEFT, music.controlsP.DOWN, music.controlsP.UP, music.controlsP.RIGHT]);
        }
    }
*/
        noteData = staticData;
        this.skin = skin;
        this.player = player;
        this.keyAmount = keyAmount;
        addStatic();
    }
    public function addStatic()
    {
            if (PlayState.isPixelStage)
                {
                loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
                animation.add('green', [6]);
                animation.add('red', [7]);
                animation.add('blue', [5]);
                animation.add('purplel', [4]);

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
                animation.addByPrefix('green', 'arrowUP');
                animation.addByPrefix('blue', 'arrowDOWN');
                animation.addByPrefix('purple', 'arrowLEFT');
                animation.addByPrefix('red', 'arrowRIGHT');

                antialiasing = true;
                setGraphicSize(Std.int(width * 0.7));

                // switch(keyAmount){
                // case 5:    
                // switch (Math.abs(noteData))
                //   {
                //     case 0:
                //         animation.addByPrefix('static', 'arrowLEFT');
                //         animation.addByPrefix('pressed', 'left press', 24, false);
                //         animation.addByPrefix('confirm', 'left confirm', 24, false);
                //     case 1:
                //         animation.addByPrefix('static', 'arrowDOWN');
                //         animation.addByPrefix('pressed', 'down press', 24, false);
                //         animation.addByPrefix('confirm', 'down confirm', 24, false);
                //     case 2:
                //         animation.addByPrefix('static', 'arrowLEFT');
                //         animation.addByPrefix('pressed', 'up press', 24, false);
                //         animation.addByPrefix('confirm', 'down confirm', 24, false);   
                //     case 3:
                //         animation.addByPrefix('static', 'arrowUP');
                //         animation.addByPrefix('pressed', 'up press', 24, false);
                //         animation.addByPrefix('confirm', 'up confirm', 24, false);
                //     case 4:
                //         animation.addByPrefix('static', 'arrowRIGHT');
                //         animation.addByPrefix('pressed', 'right press', 24, false);
                //         animation.addByPrefix('confirm', 'right confirm', 24, false);
                // }
                // case 4:
                switch (Math.abs(noteData))
                {
                    case 0:
                        animation.addByPrefix('static', 'arrowLEFT');
                        animation.addByIndices('pressed', 'left press', [0, 1, 2, 3], "", 24, false);
                        animation.addByPrefix('confirm', 'left confirm', 24, false);
                    case 1:
                        animation.addByPrefix('static', 'arrowDOWN');
                        animation.addByPrefix('pressed', 'down press', 24, false);
                        animation.addByPrefix('confirm', 'down confirm', 24, false);
                    case 2:
                        animation.addByPrefix('static', 'arrowUP');
                        animation.addByPrefix('pressed', 'up press', 24, false);
                        animation.addByPrefix('confirm', 'up confirm', 24, false);
                    case 3:
                        animation.addByPrefix('static', 'arrowRIGHT');
                        animation.addByIndices('pressed', 'right press', [0, 1, 2, 3], "", 24, false);
                        animation.addByPrefix('confirm', 'right confirm', 24, false);
                }
             }
            //     default:
            //     switch (Math.abs(noteData))
            //     {
            //         case 0:
            //             animation.addByPrefix('static', 'arrowLEFT');
            //             animation.addByIndices('pressed', 'left press', [0, 1, 2, 3], "", 24, false);
            //             animation.addByPrefix('confirm', 'left confirm', 24, false);
            //         case 1:
            //             animation.addByPrefix('static', 'arrowDOWN');
            //             animation.addByPrefix('pressed', 'down press', 24, false);
            //             animation.addByPrefix('confirm', 'down confirm', 24, false);
            //         case 2:
            //             animation.addByPrefix('static', 'arrowUP');
            //             animation.addByPrefix('pressed', 'up press', 24, false);
            //             animation.addByPrefix('confirm', 'up confirm', 24, false);
            //         case 3:
            //             animation.addByPrefix('static', 'arrowRIGHT');
            //             animation.addByIndices('pressed', 'right press', [0, 1, 2, 3], "", 24, false);
            //             animation.addByPrefix('confirm', 'right confirm', 24, false);
            //     }
            //   }
        }
    public function setPositionStatic() {
		animation.play('static');
		x += Note.swagWidth * noteData;
		x += 50;
		x += ((FlxG.width / 2) * player);
		ID = noteData;
	}
    public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0)
        {
            animation.play(AnimName, Force, Reversed, Frame);
    
            if (AnimName == "confirm"){
                alpha = 1;
            }else{
                alpha = 1 * initAlpha;
            }
        }
    override public function update(ea) {
        super.update(ea);
    }
}