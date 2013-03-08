class LogMailer < ActionMailer::Base
  default from: "system@tempofreelax.com"
  
  def send_logs
    require 'date'
    @parseErrorLog = File.open(File.join('lib','assets','parseErrorLog'),'r').readlines
    mail :to => 'panel1382@gmail.com', :subject => "Parse Log: #{DateTime.now}"
  end
end
