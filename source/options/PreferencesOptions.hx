package options;

import flixel.*;
import Controls.Control;
import Controls.KeyboardScheme;
class PreferencesOptions//no psych bro -_-
{

	public static var GhostTapping:Bool = true;
    public static var MiddleScroll:Bool = false;
    public static var DownScroll:Bool = false;
	public static var AutoPlay:Bool = false;
    public static var NoteSplash:Bool = true;
	public static var HitSound:Bool = false;
	public static var HitSoundVolume:Float = 0.0;
	public static var HideHud:Bool = false;
    public static var TimeBar:Bool = false;
	public static var FullScreen:Bool = false;
	public static var Antialiasing:Bool = true;
    public static var GameOverOst:Bool = false;

	public static function saveData()
		{
            FlxG.save.data.ghosttapping   = GhostTapping;
            FlxG.save.data.middlescroll   = MiddleScroll;
            FlxG.save.data.downscroll     = DownScroll;
            FlxG.save.data.splash         = NoteSplash;
            FlxG.save.data.hitsound       = HitSound;
            FlxG.save.data.autoplay       = AutoPlay;
            FlxG.save.data.hud            = HideHud;
            FlxG.save.data.timebar        = TimeBar;
            FlxG.save.data.fullscreen     = FullScreen;
            FlxG.save.data.gameoverost    = GameOverOst;
            FlxG.save.data.hitsoundvolume = HitSoundVolume;
            FlxG.save.data.antialiasing   = Antialiasing;
        }

        public static function loadData()
            {
                if (FlxG.save.data.ghosttapping != null)
                    GhostTapping = FlxG.save.data.ghosttapping;

                if (FlxG.save.data.middlescroll != null)
                    MiddleScroll = FlxG.save.data.middlescroll;

                if (FlxG.save.data.downscroll != null)
                    DownScroll = FlxG.save.data.downscroll;

                if (FlxG.save.data.splash != null)
                    NoteSplash = FlxG.save.data.splash;

                if (FlxG.save.data.hitsound != null)
                    HitSound = FlxG.save.data.hitsound;

                if (FlxG.save.data.autoplay != null)
                    AutoPlay = FlxG.save.data.autoplay;

                if (FlxG.save.data.hud != null)
                    HideHud = FlxG.save.data.hud;

                if (FlxG.save.data.timebar != null)
                    TimeBar = FlxG.save.data.timebar;

                if (FlxG.save.data.fullscreen != null)
                    FullScreen = FlxG.save.data.fullscreen;

                if (FlxG.save.data.gameoverost != null)
                    GameOverOst = FlxG.save.data.gameoverost;

                if (FlxG.save.data.hitsoundvolume != null)
                    HitSoundVolume = FlxG.save.data.hitsoundvolume;

                if (FlxG.save.data.antialiasing != null)
                    Antialiasing = FlxG.save.data.antialiasing;
            }
}