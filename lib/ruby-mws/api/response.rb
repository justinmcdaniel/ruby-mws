module MWS
  module API

    class Response < Hashie::Rash

      def self.parse(hash, name, params, request_uri)
        rash = self.new(hash)
        handle_error_response(rash["error_response"]["error"], request_uri) unless rash["error_response"].nil?
        raise BadResponseError, "received non-matching response type #{rash.keys}" if rash["#{name}_response"].nil?
        rash = rash["#{name}_response"]

        if rash = rash["#{name}_result"]
          if (params[:standard_response])
            rash = standardize_rash(rash)
          end
          # only runs mods if correct result is present
          params[:mods].each {|mod| mod.call(rash) } if params[:mods]
          rash
        end
      end

      def self.handle_error_response(error, request_uri)
        msg = "#{request_uri}\n\n#{error.code}: #{error.message}"
        msg << " -- #{error.detail}" unless error.detail.nil?
        raise ErrorResponse, msg
      end

      def self.standardize_rash(rash)
        # I desired a standardly typed response in the form of an array even when only
        # one result was returned. Unfortunately, the default behavior is to return a 
        # hash when there is only one result and an array if there is more than one result.
        # So I added a "standard_response" flag to return an array no matter what for the
        # root element. 
        if rash.respond_to?('has_key?')
          rash = [rash]
        end
        rash
      end

    end

  end
end