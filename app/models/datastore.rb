class Datastore < Object
  require 's3'
  
  def connect!
    @service.nil? ? @service = S3::Service.new(
      :access_key_id     => ENV['access_key'], 
      :secret_access_key => ENV['secret_key'],  
    ) : @service
  end
  
  def bucket
    connect! if @service.nil?
    @bucket.nil? ? @bucket = @service.buckets.find(ENV['bucket']) : @bucket
  end
  
  def files
    bucket if @bucket.nil?
    @bucket.objects
  end
  
  def file(name)
    bucket if @bucket.nil?
    object = @service.buckets.find('panel-tempofreelax-dev').objects.find(name)
    @bucket.objects.find(name)
    object
  end
  
  def add(name, file)
    bucket if @bucket.nil?
    new_object = @bucket.objects.build(name)
    new_object.content = open(file)
    new_object.save
  end
end
