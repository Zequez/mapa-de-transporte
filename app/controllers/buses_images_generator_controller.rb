class BusesImagesGeneratorController < ApplicationController
  caches_action :show

  def show
    Bus.rebuild_sprite
    data = File.read(Bus.sprite_path, mode: 'rb')
    send_data(data, type: 'image/png', disposition: 'inline')
  end
end


#Connection:keep-alive
#Content-Length:1233
#Content-Type:image/png
#Last-Modified:Wed, 18 Apr 2012 16:25:20 GMT
#Server:thin 1.3.1 codename Triple Espresso

#Cache-Control:private
#Connection:keep-alive
#Content-Disposition:attachment
#Content-Length:1233
#Content-Transfer-Encoding:binary
#Content-Type:image/png
#ETag:"1a0db581ce8656aa752a6433f5a58ea8"
#Server:thin 1.3.1 codename Triple Espresso
#X-Request-Id:371c5d75576844e173f8d354beba7986
#X-Runtime:1.214984
#X-UA-Compatible:IE=Edge