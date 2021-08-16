class Source
  class Describe < ApplicationService

    attr_accessor :url, :author, :title

    def call
      analysis = Analyze.(url: url)
      text = []

      if analysis.service
        text << t("source.service_types.#{analysis.service}.#{analysis.type}", default: t("source.types.#{analysis.type || :unknown}"))

        if title.present?
          text << "»#{title}«"
        end

        if username = author.presence || analysis.username.presence
          if analysis.type == :comment
            text << "from" << username
          else
            text << "by" << username
          end
        end
      else
        text << t("source.types.unknown")

        if title.present?
          text << "»#{title}«"
        end

        if author.present?
          text << "by" << author
        end

        text << "from" << analysis.host
      end

      text.join(" ")
    end

  end
end
