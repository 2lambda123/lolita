module Lolita
  module Configuration
    class DateField < Lolita::Configuration::Field
      attr_accessor :format
      def initialize *args
        @type="date"
        super
      end
    end
  end
end