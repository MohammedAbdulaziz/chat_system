module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mappings dynamic: 'false' do
      indexes :body, type: 'text'
      indexes :chat_id, type: 'integer'
    end
    
    def as_indexed_json(options = {})
      as_json(only: [:number, :body, :chat_id, :created_at, :updated_at])
    end

    def self.search(query, chat_id)
      params = {
        query: {
          bool: {
            must: [
              { match: { chat_id: chat_id } },
              { wildcard: { body: "*#{query}*" } }
            ]
          }
        },
        size: 10000
      }

      self.__elasticsearch__.search(params).records.to_a
    end
  end
end
