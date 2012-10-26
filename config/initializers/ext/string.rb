class String
  def self.formatNCAADate
    array = self.split('/') 
    string = array[2]+'-'+array[0]+'-'+array[1]
    string
  end
end