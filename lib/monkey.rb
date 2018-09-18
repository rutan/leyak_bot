require 'repp'
require 'repp/handler/shell'

module Repp
  module Handler
    class Shell
      module KeyboardHandler
        alias upstream_receive_line receive_line
        def receive_line(data)
          upstream_receive_line(data.force_encoding('utf-8'))
        end
      end
    end
  end
end
