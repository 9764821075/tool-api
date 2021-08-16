class Source
  class Manage < ApplicationService

    attr_accessor :model, :urls

    def call
      self.urls = [] if urls.blank?
      self.urls = clean_map_urls(self.urls)

      source_joins = model.source_joins.includes(:source)
      existing_urls = source_joins.map(&:source).map(&:url)

      delete_sources(source_joins)
      add_sources(source_joins, existing_urls)
    end

    private

    def clean_map_urls(urls)
      urls.map { |url_entry|
        url = url_entry.is_a?(String) ? url_entry : url_entry[:url]
        url.present? && valid_url?(url) ? url : nil
      }.compact
    end

    def delete_sources(source_joins)
      0.upto(source_joins.count - 1) do |i|
        source_join = model.source_joins[i]

        next if urls.include?(source_join.source.url)

        source_join.deleted = true
      end
    end

    def add_sources(source_joins, existing_urls)
      urls.each do |url|
        next if existing_urls.include?(url)

        if source = Source.where(url: url).first
          source_joins.build(source: source)
        else
          source_joins.build.build_source(url: url)
        end
      end
    end

    def valid_url?(url)
      !!URI.parse(url).host
    rescue
      false
    end

  end
end
