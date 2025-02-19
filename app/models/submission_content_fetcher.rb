# frozen_string_literal: true

class SubmissionContentFetcher
  class << self
    def doc_factory(url)
      params = { 'url' => url }

      if GoogleDocFetcher.supports_url?(url)
        return GoogleDocFetcher.new(params)
      elsif WebsiteFetcher.supports_url?(url) # leave last as catch-all
        return WebsiteFetcher.new(params)
      end

      nil
    end

    def code_factory(url)
      params = { 'url' => url }

      if GithubPullRequestFetcher.supports_url?(url)
        return GithubPullRequestFetcher.new(params)
      end

      nil
    end

    # Don't allow this object to be instantiated
    private :new
  end
end
