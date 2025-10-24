module Front
  class ApplicationController < ActionController::Base
    include PlayerAuthentication
    layout "front"
  end
end
