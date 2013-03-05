namespace :bg do

  desc "Scrape NCAA stats site for boxscores"
  task :getGames => :environment do 
    require 'nokogiri'
    require 'open-uri'
    require 'date'
    
    doc = 'lib/assets/games_2013.csv'
    
    # set up to check for entire 2013 season
    start_date = Date.new 2013, 2, 2
    target_date = Date.new(Time.now.year, Time.now.month, Time.now.day).prev_day
    range = start_date..target_date
    games = []
    range.each do |date|
      schedule_date = "#{date.month}/#{date.day}/#{date.year}"
      scoreboard = "http://stats.ncaa.org/team/schedule_list?&sport_code=MLA&schedule_date=#{schedule_date}"
      puts scoreboard
      dom = Nokogiri::HTML(open(scoreboard))
    
      dom.css('.light_grey_heading a').each do |el|
        gameid = el['href'].split('/').last      
        games.push gameid
      end
    end
    
    File.open(doc, "w", :type => 'text/csv; charset=utf-8'){ |f| f << games.join("\n")}
  end
  
  desc "Go through the AnnualStats in a year and ranking the teams"
  task :generateRanks => :environment do
    require 'date'
    year = 2012
    start = Date.new(year,1,1)
    finish = Date.new(year,12,31)
    a = AnnualStat.where(:year=> start..finish)
    s = Stat.find(:all)
    a.each{|b| s.each{|t| b.rank(t.slug.to_sym) }}
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
  
  task :loadGames => :environment do
    require 'csv'
    require 'date'
    errorLog = File.open('lib/assets/parseErrorLog','a+')
    years = [2013] #(2010..2013).to_a
    parser = Parser.new
    errorLog.write("\n\n=====#{DateTime.now.httpdate}=====\n")
    years.each do |year|    
      doc = "lib/assets/games_#{year.to_s}.csv"
      begin
        csv_txt = File.read(doc)
        data = CSV.parse csv_txt, :headers => false
      rescue
        kill "Unable to open file: #{doc}"
      end
      
      data.each do |row|
        parser.parse(row[0].to_s)
      end
      
      begin
        AnnualStat.sum_all(year)
        AnnualStat.rank_all(year)
      rescue
        puts "Unable to sum or ranks year: #{year.to_s}"
      end
    end
    errorLog.write('\n\n=========END========\n\n\n\n') 
  end
  
  task :sumAll => :environment do
    #AnnualStat.sum_all(2010)
    #AnnualStat.rank_all(2010)
    #AnnualStat.sum_all(2011)
    #AnnualStat.rank_all(2011)
    #AnnualStat.sum_all(2012)
    #AnnualStat.rank_all(2012)
    AnnualStat.sum_all(2013)
    AnnualStat.rank_all(2013)
    PlayerAnnualStat.sumAll(2013)
  end
  
  task :rank => :environment do 
    AnnualStat.rank_all(2010)
    AnnualStat.rank_all(2011)
    AnnualStat.rank_all(2012)
    AnnualStat.rank_all(2013)
  end
  
  task :refresh => :environment do
    AnnualStat.sum_all(2010)
    AnnualStat.rank_all(2010)
    PlayerAnnualStat.sumAll(2010)
    AnnualStat.sum_all(2011)
    AnnualStat.rank_all(2011)
    PlayerAnnualStat.sumAll(2011)
    AnnualStat.sum_all(2012)
    AnnualStat.rank_all(2012)
    PlayerAnnualStat.sumAll(2012)
    AnnualStat.rank_all(2013)
    PlayerAnnualStat.sumAll(2013)
  end
  
  task :quick => :environment do
    require 'date'
    #range = Date.new(2013,1,1)..Date.new(2013,12,31)
    #as = Game.where(:year => range).all
    #as.each { |a| a.destroy }
    AnnualStat.find_or_create(6, 2013)
  end
end