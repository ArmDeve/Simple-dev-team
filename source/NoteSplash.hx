package;
import flixel.FlxSprite;
import flixel.FlxG;
import options.PreferencesOptions;
//by niz good
class NoteSplash extends FlxSprite {
    public function new(xPos:Float,yPos:Float,?c:Int) {
        if (c == null) c = 0;
        super(xPos,yPos);
		frames = Paths.getSparrowAtlas('noteSplashes');
        animation.addByPrefix("note1-0", "note impact 1  blue", 24, false);
		animation.addByPrefix("note2-0", "note impact 1 green", 24, false);
		animation.addByPrefix("note0-0", "note impact 1 purple", 24, false);
		animation.addByPrefix("note3-0", "note impact 1 red", 24, false);

		animation.addByPrefix("note1-1", "note impact 2 blue", 24, false);
		animation.addByPrefix("note2-1", "note impact 2 green", 24, false);
		animation.addByPrefix("note0-1", "note impact 2 purple", 24, false);
		animation.addByPrefix("note3-1", "note impact 2 red", 24, false);
        antialiasing = PreferencesOptions.Antialiasing;
        setupNoteSplash(xPos,xPos,c);
    }
    public function setupNoteSplash(xPos:Float, yPos:Float, ?c:Int) {
        if (c == null) c = 0;
        setPosition(xPos, yPos);
        alpha = 0.6;
        animation.play("note"+c+"-"+FlxG.random.int(0,1), true);
		animation.curAnim.frameRate += FlxG.random.int(-2, 2);
        updateHitbox();
        offset.set(0.3 * width, 0.3 * height);
    }
    override public function update(elapsed) {
        if (animation.curAnim.finished) {
            kill();
        }
        super.update(elapsed);
    }

    // um so i tried porting the notesplash code from psych engine and it didnt work so i guess were using this lol
}