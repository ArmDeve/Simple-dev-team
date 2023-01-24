package;

import openfl.utils.Assets;
import flixel.FlxState;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxSubState;

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	public function loadAndSwitchState(target:FlxState, stopMusic = false, ?update:Bool,?typeState:String = '')
		{
			if (typeState == '')
			nextState(getNextState(target, stopMusic), update);
		else if (typeState == 'PlayState')
			FlxG.switchState(getNextState(target, stopMusic));
		}
		
		static function getNextState(target:FlxState, stopMusic = false):FlxState
		{
			Paths.setCurrentLevel("week" + PlayState.storyWeek);
			#if NO_PRELOAD_ALL
			var loaded = isSoundLoaded(getSongPath())
				&& (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath()))
				&& isLibraryLoaded("shared");
			#end
			if (stopMusic && FlxG.sound.music != null)
				FlxG.sound.music.stop();
			
			return target;
		}
	
		static function isLibraryLoaded(library:String):Bool
			{
				return Assets.getLibrary(library) != null;
			}
			static function getSongPath()
				{
					return Paths.inst(PlayState.SONG.song);
				}

				static function getVocalPath()
				{
					return Paths.voices(PlayState.SONG.song);
				}
				
				static function isSoundLoaded(path:String):Bool
				{
					return Assets.cache.hasSound(path);
				}
	
	public function nextState(STATE:FlxState, UPDATESTATE:Bool, ?isPause:Bool)
		{
openSubState(new Trans(STATE, true, 0.01, UPDATESTATE, FlxG.camera));

if (isPause)
	{
	FlxG.sound.music.stop();
	FlxG.sound.music.volume = 0;
	}
}
	
	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		curBeat = Math.floor(curStep / 4);

		if (oldStep != curStep && curStep > 0)
			stepHit();


		super.update(elapsed);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}
