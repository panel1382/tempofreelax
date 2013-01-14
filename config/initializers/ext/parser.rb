 class Parser < Object
  require 'nokogiri'
  require 'open-uri'
  require 'date'
  
  @@player_web = {
    :name => 0,
    :goals => 2,
    :assists => 3,
    :shots => 5,
    :shots_on_goal => 6,
    :ground_balls => 7,
    :turnovers => 8,
    :caused_turnovers => 9,
    :faceoff_wins => 10,
    :faceoffs_taken => 11,
    :penalties => 12,
    :penalty_seconds => 13,
    :goalie_seconds => 14,
    :goals_allowed => 15,
    :saves => 16,
    :losses => 17,
    :ties => 18
  }
  
  @@box_web = {
    'goals' => 0,
    'assists' => 1,
    'points' => 2,
    'shot_attempts' => 3,
    'shots_on_goal' => 4,
    'extra_man_goals' => 5,
    'man_down_goals' => 6,
    'ground_balls' => 7,
    'turnovers' => 8,
    'caused_turnovers' => 9,
    'faceoffs_won' => 10,
    'faceoffs_taken' => 11,
    'penalties' => 12,
    'penalty_time' => 13,
    'goals_allowed' => 15,
    'saves' => 16
  }
  @@quarter_web = {
    'extra_man_attempts' => 2,
    'clear_attempts' => 4,
    'clear_successes' => 5
  }
  @@omit = ['id','updated_at','created_at','points','goals_allowed']
  
  attr_accessor :home
  attr_accessor :away
  attr_accessor :meta
  
  def self.k(field)
    if @@quarter_web.key? field
      @@quarter_web[field]
    elsif @@box_web.key? field
      @@box_web[field]
    else
      false
    end
  end
  
  def handleBox
    if !@game.nil?
      box = @game.css('.grey_heading:last-child')
      self.boxToHash(boxToArray(box[0]),false)
      self.boxToHash(boxToArray(box[1]),true)
    end
  end
  
  def handlePlayers
    if !@game.nil?
      home = @game.css(':nth-child(9) tr.smtext')
      away = @game.css(':nth-child(11) tr.smtext')
      
      playerBoxToRow(home, true)
      playerBoxToRow(away, false)
    end
  end
  
  def handlePBP
    success = /Clear attempt by [a-zA-Z]+ good./
    failure = /Clear attempt by [a-zA-Z]+ failed./
    emo = /Extra-man opportunity./
    if !@pbp.nil?
      away = @pbp.css('.smtext:nth-child(2)')
      home = @pbp.css('.smtext:nth-child(4)')
      s=0
      f=0
      e=0
      away.each do |row|
        s+=1 if success.match(row.text)
        f+=1 if failure.match(row.text)
        e+=1 if emo.match(row.text)
      end
      @away[:clear_attempts] = s+f
      @away[:clear_success] = s
      @away[:extra_man_opportunities] = e
      s=0
      f=0
      e=0
      home.each do |row|
        s+=1 if success.match(row.text)
        f+=1 if failure.match(row.text)
        e+=1 if emo.match(row.text)
      end
      @home[:clear_attempts] = s+f
      @home[:clear_success] = s
      @home[:extra_man_opportunities] = e
    end
  end
  
  def boxToHash(box,home)
    k = @@box_web.invert
    c = 0
    box.each do |stat|
      if !@@omit.include? k[c] and !k[c].nil?
        if home==true
          @home[k[c].to_sym] = stat
        else
          @away[k[c].to_sym] = stat
        end
      end
      c+=1
    end
  end
  
  def playerBoxToRow(table, home)
    players= []
    table.css('tr').each do |row|
      players.push playerRowToHash(row, home)
    end
  end
  
  def playerRowToHash(row, home)
    # Takes a row of player game data. Checks to see if player exists and will create new
    # then takes that data to create or update a player game stat row.
    k = @@player_web
    times = [:penalty_seconds, :goalie_seconds]
    values = row.css('td')
    player = {}
    stats = {}
    
    # Populate player values
    name = values[k[:name]].text.split(',')
    if(name.length > 1)
      player[:first_name] = name[1].strip
      player[:last_name] = name[0].strip
      home ? player[:team_id] = @home[:team_id] : player[:team_id] = @away[:team_id]
      @players.push Player.there? player
      
      # Populate player stat values
      stats[:player_id] = @players.last.id
      stats[:game_id] = @game_id
      k.each do |key, value|
        if key != :name
          # change minute:seconds to seconds
          if times.include? key
            puts values[value].text
            
            v = values[value].text.split(':')
            time = (v[0].to_i * 60) + v[1].to_i
            stats[key] = time
            
            puts time
          else
            stats[key] = values[value].text.to_i
          end
        end
      end
      
      # Check if stat exists. If it does, update else creates a new and updates
      pgs = PlayerGameStat.there? stats[:player_id], stats[:game_id]
      pgs = PlayerGameStat.new if pgs.nil?
      stats.each { |name, stat| pgs.send("#{name}=",stat) }
      pgs.save
    end
  end
    
  def fixTime(string)
    arr = string.split('/')
    date = DateTime.parse(arr[2]+'-'+arr[0]+'-'+arr[1])
    date
  end
  
  def boxToArray(dom)
    arr = Array.new
    dom.children.each do |el|
      value = el.text.strip.gsub("/\s/",'')
      arr.push value.to_i if value.length > 0 and value != 'Totals'
    end
    arr
  end
  
  
  def initHash
    @home = {}
    @away = {}
    keys = GameStat.column_names
    
    keys.each do |k|
      if !@@omit.include? k
        @home[k.to_sym] = nil
        @away[k.to_sym] = nil
      end
    end
    @players = []
    @home[:home] = true
    @away[:home] = false
  end
  
  def parse(gameID)
    puts gameID
    if(Game.find_by_ncaa_id(gameID).nil?)
      initHash
      
      boxscore = 'http://stats.ncaa.org/game/box_score/@@gameid@@'
      playbyplay = 'http://stats.ncaa.org/game/play_by_play/@@gameid@@'
      
      #byquarter is broken on the NCAA side
      #byquarter = 'http://stats.ncaa.org/game/period_stats/@@gameid@@'
      
      #begin
        @game = Nokogiri::HTML(open(boxscore.gsub('@@gameid@@', gameID)))
        @pbp = Nokogiri::HTML(open(playbyplay.gsub('@@gameid@@', gameID)))
        handleBox
        handlePBP
        
        meta = @game.css('table:nth-child(5) td:nth-child(2)')
        away = Team.find_or_create_by_name @game.css('.heading td')[0].text.gsub(/^ +/,'').gsub(/ +$/,'')
        home = Team.find_or_create_by_name @game.css('.heading td')[1].text.gsub(/^ +/,'').gsub(/ +$/,'')
        
        game_data = {
          :home_team => home.id,
          :away_team => away.id,
          :date => fixTime(meta[0].text),
          :venue => meta[1].text,
          :attendance => meta[2].text,
          :ncaa_id => gameID
        }
        puts game_data.inspect
        
        game_obj = Game.new(game_data)
        game_obj.save
        @game_id = game_obj.id
        
        @home[:team_id] = home.id
        @home[:game_id] = game_obj.id
        @away[:team_id] = away.id
        @away[:game_id] = game_obj.id
        
        home_obj = GameStat.new(@home)
        home_obj.save
        away_obj = GameStat.new(@away)
        away_obj.save
        
        handlePlayers
        
        game_obj
      #rescue
        #puts "Game: #{gameID} had an HTTP Error"
      #end
    end
  end

end 