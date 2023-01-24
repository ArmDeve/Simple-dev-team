package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxState;

class Trans extends FlxSubState {
	public var toState:FlxState = null;
	public var isIn:Bool = false;
    public var olas:Array<FlxSprite> = [];
    
	var vectores = [0, 0, 0, 0];
    public var max:Int = 0;
    public static var size:Int = 125;
    public var waitTime:Float = .066;
    private var updateState:Bool = false;
    public function new(to,isIn:Bool = true, waitT:Float = 0.01, updateState:Bool = false,cam){
		toState = to;
		this.isIn = isIn;
		this.updateState = updateState;
		max = Std.int((Math.floor(FlxG.width / size) * Math.floor(FlxG.height / size)) * 2);

        super();

        persistentUpdate = false;

	for (i in 0...max)
    {
		var ola = new FlxSprite().makeGraphic(1,1);
    ola.color = FlxColor.BLACK;
        ola.setGraphicSize(size);
        ola.updateHitbox();
        ola.scrollFactor.set();
		ola.ID = curID;
        if (olas[curID - 1] != null)
        {
        if (olas[curID - 1 ].x + 50 <= FlxG.width + 50)
                ola.x = olas[curID - 1].x + size;
        else
			vectores[1]++;
            ola.y = vectores[1] * size;
        }
        ola.visible = !isIn;
        curID ++;
		olas.push(ola);
		add(ola);
        if (i % 360 == 0)
            waitTime -= 0.011;
    }
    trace('new trans by size: ${size} sizemax in loop: ${max} isIn ${isIn} its any state??? ${to != null ? "true" : "false"}');
    if (waitTime <= 0.04) 
    {
        trace("wow its too long???");
        waitTime = 0.035;
    }
    waitTime -= waitT;
	trace("wait time: " + waitTime);
    if (cam != null)
		cameras = [cam];
    }
    var elap:Float = 0;
    var loops:Int = 0;
    var curID:Int = 0;
    var olaID:Array<Int> = [];
    var looped:Bool = false;
    function addNew(){
        if (looped)
            return;
		var id = FlxG.random.int(0, max,olaID);
        olaID.push(id);
        // trace("new id " + id);
      
        for (i in olas)
            if (id == i.ID)
                i.visible = isIn;
		if (olaID.length >= max) 
			looped = true;
        
    }
    override function update(e) {
        super.update(e);
		if (updateState && FlxG.state != null)
            FlxG.state.update(e);
		elap += FlxG.elapsed;
		FlxG.watch.addQuick("elap", elap);
     if (looped)
        for (i in olas)
				i.visible = isIn;
    

    
		if (elap >= waitTime) {
			elap = 0;
			addNew();
			addNew();
			addNew();
            for (i in 0...4)
                if (FlxG.random.bool(80))
                        addNew();
            if (max >= 500)
				addNew();
			if (max >= 650)
                for (i in 0...7)
					addNew();
            
            loops ++;
		}
		if (loops >= Std.int(max / 2) || looped) {
			trace(max / 2);
            looped = true;
			trace(Std.int(max / 2));
            FlxG.state.closeSubState();
            if (toState != null)
			FlxG.switchState(toState);
            // FlxG.state.;
        }
    }
}