package;

import flixel.FlxSubState;
import flixel.FlxState;
import Conductor.BPMChangeEvent;
import openfl.utils.Assets;
import flixel.FlxG;
import options.PreferencesOptions;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);
	}

	public function loadAndSwitchState(target:FlxState, stopMusic = false)
		{
			nextState(getNextState(target, stopMusic));
			persistentUpdate = false;
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
	
	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	public function nextState(STATE:FlxState)
		{
openSubState(new Trans(STATE, true, 0.01, true, FlxG.camera));
persistentUpdate = false;
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
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
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
