package options;

#if desktop
import Discord.DiscordClient;
#end
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxAxes;
import flixel.FlxSubState;
import flixel.input.FlxInput;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import lime.utils.Assets;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.input.FlxKeyManager;


using StringTools;

class KeyBindMenu extends FlxSubState
{

    var keyTextDisplay:FlxText;
    var keyWarning:FlxText;
    var warningTween:FlxTween;
    var keyText:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT", "PAUSE"];
    var defaultKeys:Array<String> = ["D", "F", "J", "K", "ENTER"];
    var curSelected:Int = 0;

    var keys:Array<String> = [FlxG.save.data.leftBind,
                              FlxG.save.data.downBind,
                              FlxG.save.data.upBind,
                              FlxG.save.data.rightBind,
                              FlxG.save.data.pauseBind,];
    var tempKey:String = "";
    // var blacklist:Array<String> = ["ESCAPE", "ENTER", "BACKSPACE", "SPACE", "TAB"];

    var blackBox:FlxSprite;
    var infoText:FlxText;

    var state:String = "select";

	override function create()
	{	

        for (i in 0...keys.length)
        {
            var k = keys[i];
            if (k == null)
                keys[i] = defaultKeys[i];
        }
	
		//FlxG.sound.playMusic('assets/music/configurator' + TitleState.soundExt);

		persistentUpdate = true;

        keyTextDisplay = new FlxText(30, 0, -1070, "", 42);
		keyTextDisplay.scrollFactor.set(0, 0);
		keyTextDisplay.setFormat(null, 42, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		keyTextDisplay.borderSize = 3.5;
		keyTextDisplay.borderQuality = 3;

        blackBox = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        add(blackBox);

        infoText = new FlxText(keyTextDisplay.x - 470, 480, 1280, '', 72);
		infoText.scrollFactor.set(0, 0);
		infoText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoText.borderSize = 3.4;
		infoText.borderQuality = 3;
        infoText.alpha = 0;
        add(infoText);
        add(keyTextDisplay);

        blackBox.alpha = 0;
        keyTextDisplay.alpha = 0;

        FlxTween.tween(keyTextDisplay, {alpha: 1, y: keyTextDisplay.y + 30}, 1, {ease: FlxEase.expoInOut, startDelay: 0.3});
        FlxTween.tween(infoText, {alpha: 1}, 1.4, {ease: FlxEase.expoInOut});
        FlxTween.tween(blackBox, {alpha: 0.7}, 1, {ease: FlxEase.expoInOut});

        textUpdate();

		super.create();
	}

    var frames = 0;

	override function update(elapsed:Float)
	{
        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        if (frames <= 10)
            frames++;

        infoText.text = 'Press R to reset';
        switch(state){

            case "select":
                if (FlxG.keys.justPressed.UP)
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    changeItem(-1);
                }

                if (FlxG.keys.justPressed.DOWN)
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    changeItem(1);
                }

                if (FlxG.keys.justPressed.ENTER){
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    state = "input";
                }
                else if(FlxG.keys.justPressed.ESCAPE){
                    quit();
                    #if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Options Menu", null);
		#end
                }
                else if (FlxG.keys.justPressed.R){
                    reset();
                }
                if (gamepad != null) // GP Logic
                {
                    if (gamepad.justPressed.DPAD_UP)
                    {
                        FlxG.sound.play(Paths.sound('scrollMenu'));
                        changeItem(-1);
                        textUpdate();
                    }
                    if (gamepad.justPressed.DPAD_DOWN)
                    {
                        FlxG.sound.play(Paths.sound('scrollMenu'));
                        changeItem(1);
                        textUpdate();
                    }

                    if (gamepad.justPressed.START && frames > 10){
                        FlxG.sound.play(Paths.sound('scrollMenu'));
                        state = "input";
                    }
                    else if(gamepad.justPressed.LEFT_TRIGGER){
                        quit();
                    }
                    else if (gamepad.justPressed.RIGHT_TRIGGER){
                        reset();
                    }
                }

            case "input":
                if (options.KeyBinds.gamepad) {
                    tempKey = keys[curSelected];
                    keys[curSelected] = "?";
                }
                textUpdate();
                state = "waiting";

            case "waiting":
                if (gamepad != null && options.KeyBinds.gamepad) // GP Logic
                {
                    if(FlxG.keys.justPressed.ESCAPE){ // just in case you get stuck
                        state = "select";
                        FlxG.sound.play(Paths.sound('confirmMenu'));
                    }

                    if (gamepad.justPressed.START)
                    {
                        addKeyGamepad(defaultKeys[curSelected]);
                        save();
                        state = "select";
                    }

                    if (gamepad.justPressed.ANY)
                    {
                        trace(gamepad.firstJustPressedID());
                        addKeyGamepad(gamepad.firstJustPressedID());
                        save();
                        state = "select";
                        textUpdate();
                    }

                }
                else
                {
                    if(FlxG.keys.justPressed.ESCAPE){
                        keys[curSelected] = tempKey;
                        state = "select";
                        FlxG.sound.play(Paths.sound('confirmMenu'));
                    }
                    else if(FlxG.keys.justPressed.ENTER){
                        addKey(defaultKeys[curSelected]);
                        save();
                        state = "select";
                    }
                    else if(FlxG.keys.justPressed.ANY){
                        addKey(FlxG.keys.getIsDown()[0].ID.toString());
                        save();
                        state = "select";
                    }
                }


            case "exiting":


            default:
                state = "select";

        }

        if(FlxG.keys.justPressed.ANY)
			textUpdate();

		super.update(elapsed);
		
	}

    function textUpdate(){

        keyTextDisplay.text = "\n\n";

        {
            for(i in 0...5){

                var textStart = (i == curSelected) ? " <" : " ";
                keyTextDisplay.text += keyText[i] + ": " + ((keys[i] != keyText[i]) ? (keys[i]) : "" ) + textStart + "\n";

            }
        }

        //keyTextDisplay.screenCenter();

    }

    function save(){

        FlxG.save.data.upBind = keys[2];
        FlxG.save.data.downBind = keys[1];
        FlxG.save.data.leftBind = keys[0];
        FlxG.save.data.rightBind = keys[3];
        FlxG.save.data.pauseBind = keys[4];

        FlxG.save.flush();

        PlayerSettings.player1.controls.loadKeyBinds();

    }

    function reset(){

        for(i in 0...6){
            keys[i] = defaultKeys[i];
        }
        quit();

    }

    function quit(){

        state = "exiting";

        save();

        FlxTween.tween(keyTextDisplay, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(blackBox, {alpha: 0}, 1.1, {ease: FlxEase.expoInOut, onComplete: function(flx:FlxTween){close();}});
        FlxTween.tween(infoText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
    }


    function addKeyGamepad(r:String){

        var shouldReturn:Bool = true;

        var notAllowed:Array<String> = ["START"];
        var swapKey:Int = -1;

	}

    public var lastKey:String = "";

	function addKey(r:String){

        var shouldReturn:Bool = true;

        var notAllowed:Array<String> = [];
        var swapKey:Int = -1;

        trace(notAllowed);

        for(x in 0...keys.length)
            {
                var oK = keys[x];
                if(oK == r) {
                    swapKey = x;
                    keys[x] = null;
                }
                if (notAllowed.contains(oK))
                {
                    keys[x] = null;
                    lastKey = oK;
                    return;
                }
            }

        if (notAllowed.contains(r))
        {
            keys[curSelected] = tempKey;
            lastKey = r;
            return;
        }

        lastKey = "";

        if(shouldReturn){
            // Swap keys instead of setting the other one as null
            if (swapKey != -1) {
                keys[swapKey] = tempKey;
            }
            keys[curSelected] = r;
            FlxG.sound.play(Paths.sound('scrollMenu'));
        }
        else{
            keys[curSelected] = tempKey;
            lastKey = r;
        }

	}

    function changeItem(_amount:Int = 0)
    {
        curSelected += _amount;
                
        if (curSelected > 4)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = 4;
    }
}