class Source
  class Analyze < ApplicationService

    class Result
      attr_accessor :host, :service, :username, :type, :title

      def initialize(attributes = {})
        attributes.each do |attribute, value|
          public_send("#{attribute}=", value)
        end
      end
    end

    SERVICES = {
      bitchute:  "bitchute.com",
      facebook:  "facebook.com",
      flickr:    "flickr.com",
      instagram: "instagram.com",
      tumblr:    "tumblr.com",
      twitter:   "twitter.com",
      youtube:   "youtube.com",
      gab:       "gab.ai",
    }

    attr_accessor :url

    def call
      return Result.new if url.blank?

      uri = parse_url
      return Result.new unless uri.try(:host)

      Result.new analyze(uri)
    end

    private

    def analyze(uri)
      service = analyze_host(uri)
      result = {}

      if service
        result[:service] = service
        result[:host] = SERVICES[service]

        result.merge! analyze_path(service, uri)
      else
        result[:host] = remove_www_from_host(uri.host)
      end

      result
    end

    def analyze_host(uri)
      SERVICES.each do |service, host|
        return service if uri.host =~ Regexp.new(Regexp.escape(host), "i")
      end

      nil
    end

    def analyze_path(service, uri)
      method = :"analyze_#{service}"
      return {} unless respond_to?(method, :including_private_methods)

      send(method, uri) || {}
    end

    def analyze_twitter(uri)
      case uri.path
      when /\/i\/moments\/[0-9]{1,}\/?/i
        { type: :moments }
      when /\/([a-z0-9_\.]{1,15})\/status\/[0-9]{1,}\/?/i
        { username: $1, type: :post }
      when /\/([a-z0-9_\.]{1,15})\/?/i
        { username: $1, type: :profile }
      end
    end

    def analyze_facebook(uri)
      case uri.path
      when /\/profile\.php/
        params = Rack::Utils.parse_query(uri.query)
        { username: params["id"], type: :profile }
      when /\/permalink\.php/
        params = Rack::Utils.parse_query(uri.query)
        { username: params["id"], type: :post } if params.key?("story_fbid")
      when /\/photo.php/
        { type: :photo }
      when /\/([a-z0-9_\-\.]{1,50})\/photos\//i
        params = Rack::Utils.parse_query(uri.query)
        { username: $1, type: params["comment_id"] ? :comment : :photo }
      when /\/events\//
        { type: :event }
      when /\/([a-z0-9_\-\.]{1,50})\/posts\/[0-9]{1,}\/?/i
        params = Rack::Utils.parse_query(uri.query)
        { username: $1, type: params["comment_id"] ? :comment : :post }
      when /\/([a-z0-9_\-\.]{1,50})\/videos\/[0-9]{1,}\/?/i
        params = Rack::Utils.parse_query(uri.query)
        { username: $1, type: params["comment_id"] ? :comment : :video }
      when /\/([a-z0-9_\-\.]{1,50})\/?/i
        { username: $1, type: :profile }
      end
    end

    def analyze_youtube(uri)
      case uri.path
      when /\/watch/i
        { type: :video }
      when /\/channel\/([a-z0-9_\-\.]{1,50})\/?/i
        { username: $1, type: :profile }
      when /\/user\/([a-z0-9_\-\.]{1,50})\/?/i
        { username: $1, type: :profile }
      end
    end

    def analyze_instagram(uri)
      case uri.path
      when /\/p\/[a-z0-9]{1,20}\/?/i
        params = Rack::Utils.parse_query(uri.query)
        { username: params["taken-by"], type: :photo }
      when /\/([a-z0-9_\-\.]{1,35})\/?/i
        { username: $1, type: :profile }
      end
    end

    def analyze_flickr(uri)
      case uri.path
      when /\/people\/([a-z0-9@_\.\-]{1,50})\/?/i
        { username: $1, type: :profile }
      when /\/photos\/([a-z0-9@_\.\-]{1,50})\/sets\/[0-9]{1,30}\/with\/[0-9]{1,30}\/?/i
        { username: $1, type: :photo_album }
      when /\/photos\/([a-z0-9@_\.\-]{1,50})\/albums\/with\/[0-9]{1,30}\/?/i
        { username: $1, type: :photo_albums }
      when /\/photos\/([a-z0-9@_\.\-]{1,50})\/[0-9]{1,30}\/in\/[a-z0-9@_\.\-]{1,70}\/?/i
        { username: $1, type: :photo }
      when /\/photos\/([a-z0-9@_\.\-]{1,50})\/?/i
        { username: $1, type: :photos }
      end
    end

    def analyze_bitchute(uri)
      case uri.path
      when /\/channel\/([a-z0-9@_\.\-]{1,50})\/?/i
        { username: $1, type: :profile }
      when /\/video\/[a-z0-9]{1,20}\/?/i
        { type: :video }
      end
    end

    def analyze_tumblr(uri)
      subdomain = uri.host.split(".").first

      case uri.path
      when /\/post\/[0-9]{1,20}\/?/i
        { username: subdomain, type: :post }
      when ""
        { username: subdomain, type: :profile }
      end
    end

    def analyze_gab(uri)
      reserved_paths = %w[/hash /tv /popular /news /topic /topics /search /auth /expore /about]
      return if reserved_paths.any? { |path| uri.path.start_with?(path) }

      case uri.path
      when /([a-z0-9_\-]{1,60})\/posts\/[0-9]{1,15}/i
        { username: $1, type: :post }
      when /([a-z0-9_\-]{1,60})\/?/i
        { username: $1, type: :profile }
      end
    end

    def remove_www_from_host(host)
      host.slice!(0..3) if host[0..3] == "www."
      host
    end

    def parse_url
      URI.parse(url)
    rescue URI::InvalidURIError
    end

  end
end
