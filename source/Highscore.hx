package;

import flixel.FlxG;

class Highscore
{

	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var songMisses:Map<String, Int> = new Map();
	public static var songRating:Map<String, Int> = new Map();
	public static var songBreaks:Map<String, Int> = new Map();
	public static var songGoodHits:Map<String, Int> = new Map();

	public static var songSicks:Map<String, Int> = new Map();
	public static var songGoods:Map<String, Int> = new Map();
	public static var songBads:Map<String, Int> = new Map();
	public static var songShits:Map<String, Int> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map();
	public static var songMisses:Map<String, Int> = new Map();
	public static var songRating:Map<String, Int> = new Map();
	public static var songBreaks:Map<String, Int> = new Map();
	public static var songGoodHits:Map<String, Int> = new Map();

	public static var songSicks:Map<String, Int> = new Map();
	public static var songGoods:Map<String, Int> = new Map();
	public static var songBads:Map<String, Int> = new Map();
	public static var songShits:Map<String, Int> = new Map();
	#end

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
				setScore(daSong, score);
		}
		else
			setScore(daSong, score);
	}

	public static function saveMiss(song:String, misses:Int = 0, ?diff:Int = 0):Void
		{
			var daSong:String = formatSong(song, diff);
	
			if (songMisses.exists(daSong))
			{
				if (songMisses.get(daSong) < misses)
					setMiss(daSong, misses);
			}
			else
				setMiss(daSong, misses);
		}

		public static function saveSicks(song:String, sicks:Int = 0, ?diff:Int = 0):Void
			{
				var daSong:String = formatSong(song, diff);
		
				if (songSicks.exists(daSong))
				{
					if (songSicks.get(daSong) < sicks)
						setSicks(daSong, sicks);
				}
				else
					setSicks(daSong, sicks);
			}

			public static function saveGoods(song:String, goods:Int = 0, ?diff:Int = 0):Void
				{
					var daSong:String = formatSong(song, diff);
			
					if (songGoods.exists(daSong))
					{
						if (songGoods.get(daSong) < goods)
							setGoods(daSong, goods);
					}
					else
						setGoods(daSong, goods);
				}

				public static function saveBads(song:String, bads:Int = 0, ?diff:Int = 0):Void
					{
						var daSong:String = formatSong(song, diff);
				
						if (songBads.exists(daSong))
						{
							if (songBads.get(daSong) < bads)
								setBads(daSong, bads);
						}
						else
							setBads(daSong, bads);
					}

					public static function saveShits(song:String, shits:Int = 0, ?diff:Int = 0):Void
						{
							var daSong:String = formatSong(song, diff);
					
							if (songShits.exists(daSong))
							{
								if (songShits.get(daSong) < shits)
									setShits(daSong, shits);
							}
							else
								setShits(daSong, shits);
						}

		public static function saveHits(song:String, hits:Int = 0, ?diff:Int = 0):Void
			{
				var daSong:String = formatSong(song, diff);
		
				if (songGoodHits.exists(daSong))
				{
					if (songGoodHits.get(daSong) < hits)
						setHits(daSong, hits);
				}
				else
					setHits(daSong, hits);
			}

			public static function saveBreaks(song:String, breaks:Int = 0, ?diff:Int = 0):Void
				{
					var daSong:String = formatSong(song, diff);
			
					if (songBreaks.exists(daSong))
					{
						if (songBreaks.get(daSong) < breaks)
							setBreaks(daSong, breaks);
					}
					else
						setBreaks(daSong, breaks);
				}

		public static function saveRating(song:String, rating:Int = 0, ?diff:Int = 0):Void
			{
				var daSong:String = formatSong(song, diff);
		
				if (songRating.exists(daSong))
				{
					if (songRating.get(daSong) < rating)
						setRating(daSong, rating);
				}
				else
					setRating(daSong, rating);
			}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong('week' + week, diff);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setMiss(song:String, misses:Int):Void
		{
			// Reminder that I don't need to format this song, it should come formatted!
			songMisses.set(song, misses);
			FlxG.save.data.songMisses = songMisses;
			FlxG.save.flush();
		}

		static function setSicks(song:String, sicks:Int):Void
			{
				// Reminder that I don't need to format this song, it should come formatted!
				songSicks.set(song, sicks);
				FlxG.save.data.songSicks = songSicks;
				FlxG.save.flush();
			}

			static function setGoods(song:String, goods:Int):Void
				{
					// Reminder that I don't need to format this song, it should come formatted!
					songGoods.set(song, goods);
					FlxG.save.data.songGoods = songGoods;
					FlxG.save.flush();
				}

				static function setBads(song:String, bads:Int):Void
					{
						// Reminder that I don't need to format this song, it should come formatted!
						songBads.set(song, bads);
						FlxG.save.data.songBads = songBads;
						FlxG.save.flush();
					}

					static function setShits(song:String, shits:Int):Void
						{
							// Reminder that I don't need to format this song, it should come formatted!
							songBads.set(song, shits);
							FlxG.save.data.songShits = songShits;
							FlxG.save.flush();
						}

		static function setBreaks(song:String, breaks:Int):Void
			{
				// Reminder that I don't need to format this song, it should come formatted!
				songBreaks.set(song, breaks);
				FlxG.save.data.songBreaks = songBreaks;
				FlxG.save.flush();
			}

		static function setHits(song:String, hits:Int):Void
			{
				// Reminder that I don't need to format this song, it should come formatted!
				songGoodHits.set(song, hits);
				FlxG.save.data.songGoodHits = songGoodHits;
				FlxG.save.flush();
			}

		static function setRating(song:String, rating:Int):Void
			{
				// Reminder that I don't need to format this song, it should come formatted!
				songRating.set(song, rating);
				FlxG.save.data.songRating = songRating;
				FlxG.save.flush();
			}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0);

		return songScores.get(formatSong(song, diff));
	}

	public static function getMisses(song:String, diff:Int):Int
		{
			if (!songMisses.exists(formatSong(song, diff)))
				setMiss(formatSong(song, diff), 0);
	
			return songMisses.get(formatSong(song, diff));
		}

		public static function getSicks(song:String, diff:Int):Int
			{
				if (!songSicks.exists(formatSong(song, diff)))
					setSicks(formatSong(song, diff), 0);
		
				return songSicks.get(formatSong(song, diff));
			}

			public static function getGoods(song:String, diff:Int):Int
				{
					if (!songGoods.exists(formatSong(song, diff)))
						setGoods(formatSong(song, diff), 0);
			
					return songGoods.get(formatSong(song, diff));
				}

				public static function getBads(song:String, diff:Int):Int
					{
						if (!songBads.exists(formatSong(song, diff)))
							setBads(formatSong(song, diff), 0);
				
						return songBads.get(formatSong(song, diff));
					}

					public static function getShits(song:String, diff:Int):Int
						{
							if (!songShits.exists(formatSong(song, diff)))
								setShits(formatSong(song, diff), 0);
					
							return songShits.get(formatSong(song, diff));
						}

		public static function getBreaks(song:String, diff:Int):Int
			{
				if (!songBreaks.exists(formatSong(song, diff)))
					setBreaks(formatSong(song, diff), 0);
		
				return songBreaks.get(formatSong(song, diff));
			}

		public static function getHits(song:String, diff:Int):Int
			{
				if (!songGoodHits.exists(formatSong(song, diff)))
					setHits(formatSong(song, diff), 0);
		
				return songGoodHits.get(formatSong(song, diff));
			}

		public static function getRating(song:String, diff:Int):Int
			{
				if (!songRating.exists(formatSong(song, diff)))
					setRating(formatSong(song, diff), 0);
		
				return songRating.get(formatSong(song, diff));
			}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		if (!songScores.exists(formatSong('week' + week, diff)))
			setScore(formatSong('week' + week, diff), 0);

		return songScores.get(formatSong('week' + week, diff));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}

		if (FlxG.save.data.songSicks != null)
			{
				songSicks = FlxG.save.data.songSicks;
			}

			if (FlxG.save.data.songGoods != null)
				{
					songGoods = FlxG.save.data.songGoods;
				}

				if (FlxG.save.data.songBads != null)
					{
						songBads = FlxG.save.data.songBads;
					}

					if (FlxG.save.data.songShits != null)
						{
							songShits = FlxG.save.data.songShits;
						}

			if (FlxG.save.data.songMisses != null)
				{
					songMisses = FlxG.save.data.songMisses;
				}

				if (FlxG.save.data.songBreaks != null)
					{
						songBreaks = FlxG.save.data.songBreaks;
					}

				if (FlxG.save.data.songRating != null)
					{
						songRating = FlxG.save.data.songRating;
					}

					if (FlxG.save.data.songGoodHits != null)
						{
							songGoodHits = FlxG.save.data.songGoodHits;
						}
	}
}
