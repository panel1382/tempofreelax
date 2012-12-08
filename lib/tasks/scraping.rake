namespace :bg do

  desc "Scrape NCAA stats site for boxscores"
  task :getStats => :environment do 
    require 'nokogiri'
    require 'open-uri'
    require 'date'
    
    scoreboard = 'http://stats.ncaa.org/team/schedule_list?&sport_code=MLA'
    
    dom = Nokogiri::HTML(open(scoreboard))
    
    dom.css('.light_grey_heading a').each do |el|
      gameid = el['href'].split('/').last
      
      game = Parser.new gameid
=begin
      game_byquarter =  Nokogiri::HTML(open(byquarter.gsub('@@gameid@@', gameid)))
      game_boxscore = Nokogiri::HTML(open(boxscore.gsub('@@gameid@@', gameid))).css('.grey_heading:last-child')
      
      meta = game_byquarter.css('table:nth-child(5) td:nth-child(2)')
      away = {
        :quarter => game_byquarter.css(':nth-child(18) tr:nth-child(3) td'),
        :box => game_boxscore[0] }
      home = {
        :quarter => game_byquarter.css(':nth-child(18) tr:nth-child(4) td'),
        :box => game_boxscore[1] }
      
      arr = meta[0].text.split('/')
      date = DateTime.parse(arr[2]+'-'+arr[0]+'-'+arr[1])
      
      game_data = {
        :home_team => Team.there?(home[:quarter][0].text).id,
        :away_team => Team.there?(away[:quarter][0].text).id,
        :date => date,
        :venue => meta[1].text,
        :attendance => meta[2].text
      }
      
      game_obj = Game.new(game_data)
      game_obj.save
      
      
      puts game_obj.id
=end
    end
  end
  
  task :test => :environment do 
    require 'nokogiri'
    require 'open-uri'
    game = Parser.new 
    game.parse '1057351'
    
  end
  
  task :importAnnual => :environment do
    require 'csv'
    omit = [:created, :modified, :stat_id, :conference ]
    float = [:def_adj, :off_adj]
    file = open(Rails.root.join('lib','assets','2012stats.csv'))
    data = file.entries
    keys = data[0].gsub('"','').gsub("\n",'').split(',')
    
    data.each do |row|
      arr = row.split(',')
      c = 0
      a = {}
      arr.map do |stat| 
        key = keys[c].to_sym
        if !omit.include? key
          if float.include?(key) 
            a[key]= stat.to_f 
          else
            a[key] = stat.to_i
          end
        end
        c+=1
      end
      as = AnnualStat.new(a)
      as.save
    end
  end
  
  task :teams => :environment do
    require 'csv'
    file = open(Rails.root.join('lib','assets','teams.csv'))
    data = file.entries
    keys = [:id, :name, :conference_id]

    data.each do |row|
      arr = row.split(',')
      c = 0
      a = {}
      arr.map do |stat|
        key = keys[c]
        
       
        if key == :conference_id
          conf = Conference.find_or_create_by_name stat.gsub("\n",'')
          stat = conf.id
        end
        if c > 0
          c== 1 ? a[key] = stat : a[key] = stat.to_i 
        end    
        c+=1
      end

      team = Team.new(a)
      team.save 
      puts team.id 
    end
  end
  
  task :generateRanks => :environment do
    require 'date'
    year = 2012
    start = Date.new(year,1,1)
    finish = Date.new(year,12,31)
    a = AnnualStat.where(:year=> start..finish)
    s = Stat.find(:all)
    a.each{|b| s.each{|t| b.rank(t.slug.to_sym) }}
  end
  
  task :thang => :environment do
    require 'date'
    year = 2011
    start = Date.new(year,1,1)
    finish = Date.new(year,12,31)
    a = Game.where(:date => start..finish).select('home_team').uniq
    
    a.each_with_index do |team, i|
      stat = AnnualStat.where(:team_id => team.home_team)
      stat = AnnualStat.new(:team_id => team.home_team, :year => start) if !stat.is_a?( AnnualStat )
      stat.sum
    end
  end
  
  task :allGames => :environment do
    require 'nokogiri'
    require 'faraday'
    teams= []
    
    conn = Faraday.new(:url => 'http://stats.ncaa.org/team/inst_team_list') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    
    response = conn.post 'http://stats.ncaa.org/team/inst_team_list', :sport_code => 'MLA', :academic_year => '2011', :division => '1', :conf_id=> '-1'
     
    dom = Nokogiri::HTML(response.body)
    links = dom.css('td a')
    links.each do |link|
      teams.push link['href'].split('org_id=').last
    end
    
    games = []
    teams.each_with_index do |teamid, i|
      
        url = "http://stats.ncaa.org/team/index/10301?org_id=#{teamid}"
        response = conn.get url
        dom = Nokogiri::HTML(response.body)
        dom.css('.smtext:nth-child(3) a').each {|link| games.push link['href'].split('/').last.split('?').first}
      
    end
    games.uniq!
    puts games.inspect
    games.each{ |game| temp = Parser.new; temp.parse(game); }
  end
  
  task :killAllGames => :environment do
    games = Game.find(:all)
    games.each {|game| game.destroy}
    stats = GameStat.find(:all)
    games.each {|stat| stat.destroy}
  end 
  
  task :dropStats => :environment do
    stats = AnnualStat.find(:all)
    stats.each {|stat| stat.destroy}
  end
  
  task :schedule => :environment do
    team_id = 259
    year = 2012
    
    a = Team.find(259)
    a.schedule(2012)
  end
  
  task :addConf => :environment do
    teams = Team.find((197..258).to_a)
    puts teams.length
    teams.each do |team|
      team.destroy
    end
  end
  
  task :random => :environment do
    #AnnualStat.sum_all(2010)
    #ConferenceStat.sum_all(2011)
    #s = AnnualStat.where(:year => '2011-01-01').all
    #s.each {|as| as.rank_all if as.ranks.length == 0}
    #ConferenceStat.rank_all(2012)
    #ConferenceStat.sum_conference(10, 2012)
    #ConferenceStat.where(:conference_id => 10).each{ |c| c.rank_all}
    #teams = Team.where(:name => 'Air Force').all
    #puts teams.each{ |t| t.conference.name }
    
    #game = Game.find_by_ncaa_id('1022271')
    #puts game.id
    
    games = Game.select('home_team').uniq
    arr = []
    c = games.each do |a|
      team = Team.find(a.home_team)
      if team.name.is_a? String
        if team.name.match(/ +$/)
          arr.push team.name if !team.name.nil?
        end
      end
    end
    
    puts arr.inspect
=begin
    arr.each do |team|
      old = team.id
      new_id = Team.where(:name => team.name.gsub(/ +$/,'')).first.id
      
      games = Game.where(:home_team => old).all
      games.each{ |g| g.home_team = new_id; g.save }
      games = Game.where(:away_team => old).all
      games.each{ |g| g.home_team = new_id; g.save } 
    end
=end
  end
  
  task :fix => :environment do
    NationalRank.where(:year => '2011-01-01').all.each{|c| c.delete}
    AnnualStat.rank_all(2011)    
  end
  
  
end