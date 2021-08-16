class Source
  class AliasAuthor < ApplicationService

    attr_accessor :source, :user

    def call
      return unless source.known_service?

      author_alias = source.author_alias

      if author_alias
        if source.author.present?
          author_alias.update(author: source.author)
          source.update(author: nil)
        else
          author_alias.soft_delete(user)
        end
      else
        if source.author.present?
          source.create_author_alias(source.author)
        end
      end
    end

  end
end
