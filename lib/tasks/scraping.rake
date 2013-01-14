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
    games= []
    years = (2010..2012).to_a
    keys = {2010 => "10301",2011 => '10500',2012 => '10860'}
    
    conn = Faraday.new(:url => 'http://stats.ncaa.org/team/inst_team_list') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    
    years.each do |ac_year|
      puts "Getting all teams from year: #{ac_year}"
      doc = "lib/assets/games_#{ac_year}.csv"
      begin
        response = conn.post 'http://stats.ncaa.org/team/inst_team_list', :sport_code => 'MLA', :academic_year => ac_year, :division => '1', :conf_id=> '-1'
        dom = Nokogiri::HTML(response.body)
        links = dom.css('td a')
        links.each do |link|
          teams.push link['href'].split('org_id=').last
        end
      
        games = []
        teams.each_with_index do |teamid, i|
          begin
            ctl = keys[ac_year]   
            url = "http://stats.ncaa.org/team/index/#{ctl}?org_id=#{teamid}"
            response = conn.get url
            dom = Nokogiri::HTML(response.body)
            dom.css('.smtext:nth-child(3) a').each {|link| games.push link['href'].split('/').last.split('?').first}
          rescue
            puts "Could not find team schedule for team: #{teamid} (#{url})"
          end
        end
      rescue
        puts "Could not resolve team list for year: #{ac_year}"
      end
      games.uniq!
      puts games.inspect
      begin
        File.open(doc, "w", :type => 'text/csv; charset=utf-8'){ |f| f << games.join("\n")}
        puts "Successfully wrote #{games.length} games to: #{doc}"
      rescue
        puts "Error writing to file."
      end
    end
    #games.each{ |game| temp = Parser.new; temp.parse(game); }
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
  
  desc "Processes LaxPower schedule stored locally"
  task :parseSchedule => :environment do
    require 'csv'
    require 'date'
    csv_txt = File.read('lib/assets/2013Schedule.html')
    data = CSV.parse csv_txt, :headers=>true
    teams = []
    data.each do |row|
      row = row.to_hash.with_indifferent_access
      home = Team.there? row['Home Team']
      away = Team.there? row['Away Team']
      year = 2013
      month = row['Date'][0].to_i
      day = row['Date'][1..2].to_i
      date = Date.new(year, month, day)      
      row['Neutral'] == 'N' ? venue = "Neutral" : venue = home.home_field
      
      game = Game.new :home_team => home.id, :away_team => away.id, :year => year,
                  :date => date, :venue => venue 
      
      game.save
      puts game.id
    end            
  end
  
  task :tester => :environment do
    gameid = '120082'
    g = Game.find_by_ncaa_id(gameid)
    g.destroy if !g.nil?
    
    a = Parser.new
    a.parse(gameid)
  end
  
end