require 'ruboty'
#require 'ruboty-brain_wrapper'

module Ruboty
  module RtnGaroon
    module Actions
      class Base < Ruboty::Actions::Base
        private

        def messages
          @messages ||= []
        end

        def store
          @store ||= Ruboty::BrainWrapper.new(message.robot.brain, 'rtn_garoon')
        end
      end
    end
  end
end
