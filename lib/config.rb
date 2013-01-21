require 'yaml'

module EtlMapping
  class Config
    class << self

      def config
        return @config if defined?(@config)
        @config = YAML.load_file("config/etl_mapping.yml") rescue {};
      end

      def method_missing(method_name, *args)
        s_method = method_name.to_s

        if s_method.match(/\=$/)
          self.config[s_method.chop] = args.first
        elsif config.has_key?(s_method)
          self.config[s_method]
        else
          super
        end
      end

    end
  end
end
