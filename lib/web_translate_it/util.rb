module WebTranslateIt
  # A few useful functions
  class Util
    
    # Return a string representing the gem version
    # For example "1.4.4"
    def self.version
      hash = YAML.load_file File.join(File.dirname(__FILE__), '..', '..' '/version.yml')
      [hash[:major], hash[:minor], hash[:patch]].join('.')
    end
    
    # Yields a HTTP connection over SSL to Web Translate It.
    # This is used for the connections to the API throughout the library.
    # Use it like so:
    # 
    #   WebTranslateIt::Util.http_connection do |http|
    #     request = Net::HTTP::Get.new(api_url)
    #     response = http.request(request)
    #   end
    #
    def self.http_connection
      http = Net::HTTP.new('webtranslateit.com', 443)
      http.use_ssl      = true
      http.verify_mode  = OpenSSL::SSL::VERIFY_NONE
      http.read_timeout = 40
      yield http
    end
    
    def self.calculate_percentage(processed, total)
      return 0 if total == 0
      ((processed*10)/total).to_f.ceil*10
    end
    
    def self.welcome_message
      puts "Web Translate It v#{WebTranslateIt::Util.version}"
    end
    
    def self.handle_response(response, return_response = false)
      if response.code.to_i >= 400 and response.code.to_i < 500
        "We had a problem connecting to Web Translate It with this API key. Make sure it is correct."
      elsif response.code.to_i >= 500
        "Web Translate It is temporarily unavailable. Please try again shortly."
      else
        if return_response
          response.body
        else
          "#{response.code.to_i} OK"
        end
      end
    end
  end
end
